"""Watch an ASPGARP model and serve its diagrams on localhost."""

import argparse
from graphlib import CycleError, TopologicalSorter
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import math
from pathlib import Path
from subprocess import CalledProcessError
from tempfile import NamedTemporaryFile
from threading import Lock

import clingo


ROOT = Path(__file__).resolve().parent
CAUSAL = ROOT / "src/asp/viz/causal.lp"
PAGE = ROOT / "viewer.html"


def diagram(files):
    """Read the node, edge, and attribute facts used by Clingraph."""
    diagnostics = []
    control = clingo.Control(["1", "--warn=none"], logger=lambda _, message: diagnostics.append(message))
    try:
        for file in (*files, CAUSAL):
            control.load(str(file))
        control.ground([("base", [])])
        with control.solve(yield_=True) as models:
            model = next(iter(models), None)
            if model is None:
                raise ValueError("The model has no answer sets.")
            atoms = model.symbols(atoms=True)
    except RuntimeError as error:
        raise ValueError("".join(diagnostics).strip() or str(error)) from error

    nodes, edges, rules = set(), [], {}
    arrows, ports = set(), {}
    landmarks, adjacency = {}, {}
    for atom in atoms:
        if atom.match("node", 1):
            nodes.add(atom.arguments[0])
        elif atom.match("edge", 1):
            edges.append(atom.arguments[0])
        elif atom.match("rule", 3):
            rules[atom.arguments[0]] = atom
        elif atom.match("attr", 4):
            kind, key, name, value = atom.arguments
            if str(kind) == "edge" and str(name) == "dir" and str(value) == "forward":
                arrows.add(key)
            elif str(kind) == "edge" and str(name) == "label" and value.type == clingo.SymbolType.Number:
                ports[key] = str(value)
        elif atom.match("landmark", 2):
            quantity, landmark = atom.arguments
            landmarks.setdefault(quantity, set()).add(landmark)
        elif atom.match("adjacent_landmark", 3):
            quantity, lower, upper = atom.arguments
            adjacency.setdefault(quantity, set()).add((lower, upper))

    quantity_spaces = {}
    for quantity, declared in landmarks.items():
        ordered = sorted(declared)
        order = TopologicalSorter({landmark: () for landmark in ordered})
        for lower, upper in sorted(adjacency.get(quantity, ())):
            if lower in declared and upper in declared:
                order.add(upper, lower)
        try:
            ordered = list(order.static_order())
        except CycleError:
            pass  # Keep the declared landmarks visible while an edit is incomplete.
        quantity_spaces[clingo.Function("qvar", [quantity])] = list(map(str, ordered))

    links = []
    for edge in sorted(edges):
        source, target, *key = edge.arguments
        nodes.update((source, target))
        rule = rules.get(key[0]) if key else None
        component = rule.arguments[2] if rule else edge
        links.append({
            "source": str(source),
            "target": str(target),
            "directed": edge in arrows,
            "label": ports.get(edge, "") if component.match("minus", 3) else str(component),
            "rule": f"{rule}." if rule else f"edge({edge}).",
        })

    return {
        "nodes": [
            {"id": str(node), "landmarks": quantity_spaces.get(node, [])}
            for node in sorted(nodes)
        ],
        "edges": links,
    }


class Viewer:
    def __init__(self, files, metadata, simulator=None):
        self.files = files
        self.metadata = metadata
        self.simulator = simulator
        self.state_svg = None
        self.state_tables = None
        self.state_render_error = None
        self.simulation_error = None
        self.signature = None
        self.revision = 0
        self.graph = {"nodes": [], "edges": []}
        self.error = None
        self.positions = {}
        if metadata.exists():
            data = json.loads(metadata.read_text(encoding="utf-8"))
            self.positions = {key: self.point(value) for key, value in data["positions"].items()}

    @staticmethod
    def point(value):
        if (
            not isinstance(value, list) or len(value) != 2
            or any(type(n) not in (int, float) or not 0 <= n <= 10000 or not math.isfinite(n) for n in value)
        ):
            raise ValueError("Expected two finite position coordinates between 0 and 10000.")
        return value

    def snapshot(self):
        try:
            stats = [path.stat() for path in (*self.files, CAUSAL)]
            signature = tuple((stat.st_ino, stat.st_mtime_ns, stat.st_size) for stat in stats)
        except OSError as error:
            self.signature = None
            self.error = str(error)
        else:
            if signature != self.signature:
                self.signature = signature
                try:
                    self.graph = diagram(self.files)
                    self.revision += 1
                    self.error = None
                except (OSError, ValueError) as error:
                    self.error = str(error)
                else:
                    if self.simulator is not None:
                        self.refresh_simulation()
        return {
            "revision": self.revision,
            "graph": self.graph,
            "error": self.error,
            "positions": self.positions,
            "simulate": self.simulator is not None,
            "has_state_graph": self.state_svg is not None,
            "state_tables": self.state_tables,
            "state_render_error": self.state_render_error,
            "simulation_error": self.simulation_error,
        }

    def refresh_simulation(self):
        try:
            result = self.simulator(*self.files)
        except (OSError, RuntimeError, ValueError) as error:
            self.simulation_error = str(error)
            return
        self.simulation_error = None
        self.state_svg = self.state_tables = self.state_render_error = None
        if not result.states:
            return

        from src.aspgarp.export import state_tables, to_dot

        try:
            from graphviz import Source

            self.state_svg = Source(to_dot(result)).pipe(format="svg", quiet=True)
        except (ImportError, OSError, RuntimeError, ValueError, CalledProcessError) as error:
            self.state_tables = state_tables(result)
            self.state_render_error = str(error)

    def move(self, node, position):
        if not any(item["id"] == node for item in self.graph["nodes"]):
            raise ValueError("Unknown node.")
        positions = {**self.positions, node: self.point(position)}
        with NamedTemporaryFile(mode="w", encoding="utf-8", dir=self.metadata.parent, delete=False) as file:
            temporary = Path(file.name)
            try:
                json.dump({"positions": positions}, file, indent=2, sort_keys=True)
                file.write("\n")
                file.close()
                temporary.replace(self.metadata)
            finally:
                temporary.unlink(missing_ok=True)
        self.positions = positions


def handler(viewer, page):
    lock = Lock()

    class Request(BaseHTTPRequestHandler):
        def reply(self, status, content_type, body):
            self.send_response(status)
            self.send_header("Content-Type", content_type)
            self.send_header("Content-Length", str(len(body)))
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            self.wfile.write(body)

        def json_reply(self, status, data):
            self.reply(status, "application/json", json.dumps(data).encode())

        def local_host(self):
            return f"127.0.0.1:{self.server.server_port}"

        def do_GET(self):
            if self.headers.get("Host") != self.local_host():
                self.send_error(403)
            elif self.path == "/":
                self.reply(200, "text/html; charset=utf-8", page)
            elif self.path == "/api/model":
                with lock:
                    snapshot = viewer.snapshot()
                self.json_reply(200, snapshot)
            elif self.path.partition("?")[0] == "/state.svg":
                with lock:
                    image = viewer.state_svg
                if image is None:
                    self.send_error(404)
                else:
                    self.reply(200, "image/svg+xml", image)
            else:
                self.send_error(404)

        def do_POST(self):
            if self.path != "/api/position":
                self.send_error(404)
                return
            if (self.headers.get("Host") != self.local_host()
                    or self.headers.get("Origin") != f"http://{self.local_host()}"):
                self.send_error(403)
                return
            try:
                size = int(self.headers.get("Content-Length", "0"))
                if not 0 < size <= 8192 or self.headers.get_content_type() != "application/json":
                    raise ValueError("Expected a JSON position.")
                data = json.loads(self.rfile.read(size))
                with lock:
                    viewer.move(data["node"], data["position"])
            except (KeyError, TypeError, ValueError, OverflowError) as error:
                self.json_reply(400, {"error": str(error)})
            except OSError as error:
                self.json_reply(500, {"error": str(error)})
            else:
                self.json_reply(200, {})

        def log_message(self, *_):
            pass  # Polling every second would otherwise fill the terminal.

    return Request


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("model", type=Path, help="A model folder or a standalone ASP model file")
    parser.add_argument("--metadata", type=Path, help="Path to the layout JSON file")
    parser.add_argument("--simulate", action="store_true", help="Also compute and display the state graph")
    args = parser.parse_args()
    model = args.model.resolve()
    if model.is_dir():
        files = (model / "db.lp", model / "ref.lp")
        default_metadata = model / "viewer.json"
    else:
        files = (model,)
        default_metadata = model.with_suffix(model.suffix + ".viewer.json")
    metadata = (args.metadata or default_metadata).resolve()
    if metadata in (CAUSAL, *(path.resolve() for path in files)):
        parser.error("The metadata path must differ from the model and encoding files.")
    try:
        for file in files:
            if not file.is_file():
                raise FileNotFoundError(f"Model file not found: {file}")
        simulator = None
        if args.simulate:
            from src.aspgarp.simulation import simulate

            simulator = simulate
        viewer = Viewer(files, metadata, simulator)
        with ThreadingHTTPServer(("127.0.0.1", 0), handler(viewer, PAGE.read_bytes())) as server:
            print(f"Open http://127.0.0.1:{server.server_port}/", flush=True)
            print(f"Layout: {metadata}", flush=True)
            server.serve_forever()
    except KeyboardInterrupt:
        pass
    except (OSError, KeyError, AttributeError, TypeError, ValueError) as error:
        parser.exit(1, f"{parser.prog}: {error}\n")


if __name__ == "__main__":
    main()
