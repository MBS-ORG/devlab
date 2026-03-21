"""Tests for main.py using pytest."""

from __future__ import annotations

import json
from pathlib import Path

import pytest

from main import main, process


@pytest.fixture()
def tmp_input(tmp_path: Path) -> Path:
    p = tmp_path / "input.txt"
    p.write_text("line1\nline2\nline3\n", encoding="utf-8")
    return p


def test_process_creates_output(tmp_input: Path, tmp_path: Path) -> None:
    output = tmp_path / "out.json"
    result = process(tmp_input, output)

    assert output.exists()
    assert result["line_count"] == 3


def test_process_output_is_valid_json(tmp_input: Path, tmp_path: Path) -> None:
    output = tmp_path / "out.json"
    process(tmp_input, output)

    data = json.loads(output.read_text())
    assert "line_count" in data
    assert "lines" in data


def test_process_missing_input(tmp_path: Path) -> None:
    with pytest.raises(FileNotFoundError):
        process(tmp_path / "nonexistent.txt", tmp_path / "out.json")


def test_main_returns_zero_on_success(tmp_input: Path, tmp_path: Path) -> None:
    output = tmp_path / "out.json"
    rc = main(["--input", str(tmp_input), "--output", str(output)])
    assert rc == 0


def test_main_returns_one_on_missing_file(tmp_path: Path) -> None:
    output = tmp_path / "out.json"
    rc = main(["--input", str(tmp_path / "missing.txt"), "--output", str(output)])
    assert rc == 1
