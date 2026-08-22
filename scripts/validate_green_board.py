#!/usr/bin/env python3
import argparse
import json
import re
import sys
import urllib.request
from pathlib import Path

REPO = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
SHA40 = re.compile(r"^[0-9a-f]{40}$")
EPOCH = re.compile(r"^\d{4}-\d{2}$")
REQUIRED = {
    "id", "repo", "pr", "commit_sha", "merged_at", "replay_pointer",
    "authority", "author", "green_type", "scope", "cycle", "epoch",
    "claim_truth", "ci_verified", "status"
}


def fail(msg):
    print(f"ERROR: {msg}", file=sys.stderr)
    return 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("path")
    ap.add_argument("--check-pointers", action="store_true")
    args = ap.parse_args()
    data = json.loads(Path(args.path).read_text(encoding="utf-8"))
    errors = 0
    if data.get("authority") is not False:
        errors += fail("board authority must be false")
    if data.get("claim_truth") is not False:
        errors += fail("board claim_truth must be false")
    entries = data.get("entries")
    if not isinstance(entries, list):
        errors += fail("entries must be a list")
        entries = []
    seen = set()
    for i, entry in enumerate(entries):
        missing = REQUIRED - set(entry)
        if missing:
            errors += fail(f"entry[{i}] missing {sorted(missing)}")
            continue
        if entry["id"] in seen:
            errors += fail(f"duplicate id {entry['id']}")
        seen.add(entry["id"])
        if not REPO.fullmatch(entry["repo"]): errors += fail(f"bad repo {entry['repo']}")
        if not isinstance(entry["pr"], int) or entry["pr"] < 1: errors += fail(f"bad pr in {entry['id']}")
        if not SHA40.fullmatch(entry["commit_sha"]): errors += fail(f"bad sha in {entry['id']}")
        if not isinstance(entry["replay_pointer"], str) or not entry["replay_pointer"].startswith("https://"):
            errors += fail(f"bad replay_pointer in {entry['id']}")
        if entry["authority"] is not False: errors += fail(f"authority must be false in {entry['id']}")
        if entry["claim_truth"] is not False: errors += fail(f"claim_truth must be false in {entry['id']}")
        if entry["ci_verified"] is not False: errors += fail(f"ci_verified must be false unless separately bound in {entry['id']}")
        if entry["green_type"] != "MERGED_PR_CYCLE": errors += fail(f"bad green_type in {entry['id']}")
        if entry["scope"] != "GITHUB_LIFECYCLE_RECEIPT": errors += fail(f"bad scope in {entry['id']}")
        if entry["status"] != "GREEN_MERGED_CYCLE": errors += fail(f"bad status in {entry['id']}")
        if entry["cycle"] != f"{entry['repo']}#{entry['pr']}": errors += fail(f"cycle mismatch in {entry['id']}")
        if not EPOCH.fullmatch(entry["epoch"]) or not entry["merged_at"].startswith(entry["epoch"]):
            errors += fail(f"epoch mismatch in {entry['id']}")
        if not entry.get("author"): errors += fail(f"missing author in {entry['id']}")
        if args.check_pointers:
            try:
                req = urllib.request.Request(entry["replay_pointer"], method="HEAD", headers={"User-Agent":"jsonwisdom-no-fake-green-validator/0.1"})
                with urllib.request.urlopen(req, timeout=8) as resp:
                    if resp.status >= 400:
                        print(f"WARN: pointer returned {resp.status}: {entry['replay_pointer']}", file=sys.stderr)
            except Exception as exc:
                print(f"WARN: pointer check failed for {entry['replay_pointer']}: {exc}", file=sys.stderr)
    if errors:
        print(f"NO FAKE GREEN: FAIL ({errors} errors)", file=sys.stderr)
        raise SystemExit(1)
    print(f"NO FAKE GREEN: PASS — {len(entries)} lifecycle receipts validated; authority=false; claim_truth=false")


if __name__ == "__main__":
    main()
