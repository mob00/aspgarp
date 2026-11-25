#AI:X
"""Simulate an ASPGARP reference model."""

from dataclasses import dataclass
from pathlib import Path

import clingo


ASP_DIR = Path(__file__).resolve().parents[1] / "asp"
SIMULATION_FILES = (
    "single/qsim.lp",
    "single/cd.lp",
    "adapter.lp",
    "db.lp",
    "preds.lp",
    "single/garp_dynamics.lp",
    "qcn/encoding.lp",
    "qcn/calculi/point.lp",
    "single/calculi.lp",
    "single/qcn_dynamics.lp",
    "single/single.lp",
)

State = tuple[clingo.Symbol, ...]


@dataclass(frozen=True)
class StateGraph:
    """Observable states indexed by their position and directed transitions."""

    states: tuple[State, ...]
    transitions: tuple[tuple[int, int], ...]


def _simulate_steps(paths: tuple[Path, ...]):
    control = clingo.Control(["0", "--project=show", "--warn=none"])
    for path in paths:
        control.load(str(path))
    control.add("base", [], ":- violation.\n#show obsT/1.\n#show from_state/0.")
    control.ground([("base", [])])
    with control.solve(yield_=True) as models:
        for model in models:
            endpoints = [[], []]
            for atom in model.symbols(shown=True):
                if atom.match("obsT", 1):
                    observation = atom.arguments[0]
                    endpoint, *arguments = observation.arguments
                    endpoints[endpoint.number].append(
                        clingo.Function(observation.name, arguments)
                    )
            source, target = (tuple(sorted(endpoint)) for endpoint in endpoints)
            point = source if model.contains(clingo.Function("from_state")) else target
            yield point, (source, target)


def simulate(model: str | Path, reference: str | Path | None = None) -> StateGraph:
    """Load a model directory, a standalone file, or a database/reference pair.

    Each state contains its observable holds/3 and holds_relation/2 symbols.
    State IDs follow the sorted observations and are stable for the same graph.
    """
    model = Path(model)
    if reference is not None:
        model_files = (model, Path(reference))
    elif model.is_dir():
        model_files = (model / "db.lp", model / "ref.lp")
    else:
        model_files = (model,)
    for path in model_files:
        if not path.is_file():
            raise FileNotFoundError(f"Model file not found: {path}")

    paths = (*model_files, *(ASP_DIR / name for name in SIMULATION_FILES))
    point_states = set()
    steps = set()
    for point, step in _simulate_steps(paths):
        point_states.add(point)
        steps.add(step)
    states = tuple(sorted(point_states))
    state_ids = {state: index for index, state in enumerate(states)}
    # Report transitions between observable states that occur at a time point.
    transitions = (
        (state_ids[source], state_ids[target])
        for source, target in steps
        if source in state_ids and target in state_ids
    )
    return StateGraph(states, tuple(sorted(transitions)))
