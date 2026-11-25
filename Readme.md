# ASPGARP

[Qualitative Causal Modelling](https://dynalearn.nl) in Answer Set Programming. Based on [ASP-QSIM](https://github.com/timothy-wiley/aspqsim).

## Start with the demo

Open [notebooks/demo.ipynb](notebooks/demo.ipynb) in Jupyter. Set `INSTANCE` to
`tree`, `vessels`, `population`, `falling`, or `heating` to select an example.
The notebook uses the Python packages `clingo` and `pandas`. The graph rendering
cells also use the `clingo`, `clingraph`, and Graphviz command-line tools.

- [src/asp/](src/asp/) contains the ASP encodings.
- [models/](models/) contains the example models.
- [tests/](tests/) contains the regression tests.

## License

This project includes modified code from **ASP-QSIM**, originally copyright
(c) Dr. Timothy Wiley, 2017.

This repository is licensed under the **GNU Affero General Public License,
version 3 only** (`AGPL-3.0-only`). See [`LICENSE`](LICENSE) for the complete
licence text.
