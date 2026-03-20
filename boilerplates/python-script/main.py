#!/usr/bin/env python3
"""
Python script boilerplate with argument parsing, structured logging, and exit codes.

Usage:
    python main.py --input data.csv --output results.json
    python main.py --help
"""

from __future__ import annotations

import argparse
import json
import logging
import sys
from pathlib import Path


logger = logging.getLogger(__name__)


def configure_logging(verbose: bool = False) -> None:
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format="%(asctime)s %(levelname)-8s %(name)s %(message)s",
        datefmt="%Y-%m-%dT%H:%M:%S",
    )


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--input",
        type=Path,
        required=True,
        help="Path to the input file.",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("output.json"),
        help="Path to write output (default: output.json).",
    )
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable debug logging.",
    )
    return parser.parse_args(argv)


def process(input_path: Path, output_path: Path) -> dict:
    """Core processing logic. Replace with your implementation."""
    logger.info("Reading input from %s", input_path)

    if not input_path.exists():
        raise FileNotFoundError(f"Input file not found: {input_path}")

    # --- Replace with real processing ---
    lines = input_path.read_text(encoding="utf-8").splitlines()
    result = {
        "input": str(input_path),
        "line_count": len(lines),
        "lines": lines[:5],  # first 5 lines as preview
    }
    # ------------------------------------

    output_path.write_text(json.dumps(result, indent=2), encoding="utf-8")
    logger.info("Output written to %s", output_path)
    return result


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    configure_logging(args.verbose)

    try:
        result = process(args.input, args.output)
        logger.info("Done. Processed %d lines.", result.get("line_count", 0))
        return 0
    except FileNotFoundError as exc:
        logger.error("%s", exc)
        return 1
    except Exception:
        logger.exception("Unexpected error")
        return 2


if __name__ == "__main__":
    sys.exit(main())
