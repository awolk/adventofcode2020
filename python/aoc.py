import pathlib


def get_input(name: str) -> str:
    """Read input from input/name file in the outer directory"""
    filename = pathlib.Path(__file__).parent.parent / 'input' / name
    with open(filename) as f:
        return f.read()
