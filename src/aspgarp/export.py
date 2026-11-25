#AI:X
"""Serialize a state graph for ASP or Graphviz."""

import clingo

from .simulation import ASP_DIR, StateGraph


def to_facts(graph: StateGraph) -> str:
    """Return state, observation, and directed edge facts."""
    lines = []
    for state_id, state in enumerate(graph.states):
        lines.append(f"state({state_id}).")
        for observation in state:
            atom = clingo.Function(
                observation.name, [clingo.Number(state_id), *observation.arguments]
            )
            lines.append(f"{atom}.")
    lines.extend(f"edge(({source},{target}))." for source, target in graph.transitions)
    return "".join(f"{line}\n" for line in lines)


def to_dot(graph: StateGraph) -> str:
    """Return directed DOT using Clingraph."""
    try:
        from clingraph import Factbase
        from clingraph.graphviz import compute_graphs
    except ImportError as error:
        raise RuntimeError(f"DOT export requires the clingraph Python package: {error}") from error

    labels = []
    for state_id, state in enumerate(graph.states):
        lines = []
        for observation in state:
            name, value, *direction = observation.arguments
            detail = f"{value} ({direction[0]})" if direction else str(value)
            lines.append(f"{name}: {detail}")
        label = clingo.String("\n".join(lines))
        labels.append(f"statelabel({state_id},{label}).\n")

    facts = "graph(default).\n" + to_facts(graph) + "".join(labels)
    control = clingo.Control(["--warn=none"])
    control.load(str(ASP_DIR / "viz" / "states.lp"))
    control.add("base", [], facts)
    control.ground([("base", [])])
    with control.solve(yield_=True) as models:
        factbase = Factbase.from_model(next(iter(models)))
    dot_graph = compute_graphs(factbase, graphviz_type="digraph")["default"]
    # Clingraph emits nodes and edges in set order.
    dot_graph.body.sort()
    return dot_graph.source
