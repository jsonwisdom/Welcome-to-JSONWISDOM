#!/usr/bin/env bash
set -euo pipefail

repo="${1:?fixture repository path required}"
base_json="${2:?shared fixture base required}"

mkdir -p "$repo"
git -C "$repo" init -q
git -C "$repo" config user.name "JQG-50 Fixture"
git -C "$repo" config user.email "fixture@example.invalid"

mkdir -p "$repo/src"
python3 - "$base_json" "$repo/src/handler.py" <<'PY'
import json, pathlib, sys
base = json.loads(pathlib.Path(sys.argv[1]).read_text())
pathlib.Path(sys.argv[2]).write_text(base["artifact"]["content"])
PY

git -C "$repo" add src/handler.py
git -C "$repo" commit -q -m 'fixture(graph-b): apply final state atomically'
