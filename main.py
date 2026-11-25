"""Command-line interface for ASPGARP simulation."""

import argparse
from pathlib import Path
import sys

from src.aspgarp.export import to_dot, to_facts
from src.aspgarp.simulation import simulate


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Generate an ASPGARP state graph.")
    parser.add_argument("model", type=Path, help="Model directory or database file")
    parser.add_argument("reference", type=Path, nargs="?", help="Reference file when passing a database file")
    parser.add_argument("--format", choices=("asp", "dot"), default="asp", help="Output format (default: asp)")
    parser.add_argument("-o", "--output", type=Path, help="Write to this file instead of stdout")
    args = parser.parse_args(argv)

    try:
        graph = simulate(args.model, args.reference)
        output = to_dot(graph) if args.format == "dot" else to_facts(graph)
        if args.output is None:
            sys.stdout.write(output)
        else:
            args.output.write_text(output, encoding="utf-8")
    except (OSError, ValueError, RuntimeError) as error:
        print(f"{parser.prog}: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
