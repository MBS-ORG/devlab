# Python Script Boilerplate

Minimal Python script template with argument parsing, structured logging, proper exit codes, and tests.

## Features

- `argparse` with typed arguments and `--help`
- Structured logging (configurable verbosity with `-v`)
- Explicit exit codes: `0` success, `1` expected error, `2` unexpected error
- `pytest` tests with `tmp_path` fixture
- `ruff` for linting and formatting
- `mypy` for type checking

## Quick Start

```bash
# Install dev dependencies
pip install -r requirements-dev.txt

# Run
python main.py --input myfile.txt --output result.json

# Test
pytest -v

# Lint
ruff check .
ruff format --check .

# Type check
mypy main.py
```

## Customisation

1. Update `parse_args()` with your required/optional arguments.
2. Replace the processing logic in `process()`.
3. Add runtime packages to `requirements.txt`.
