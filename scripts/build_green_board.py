#!/usr/bin/env python3
import argparse
import json
import os
import re
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

API = "https://api.github.com"
USER = "jsonwisdom"
SHA40 = re.compile(r"^[0-9a-f]{40}$")


def request_json(url: str, token: str | None):
    headers = {
        "Accept": "application/vnd.github+json",
        "User-Agent": "jsonwisdom-no-fake-green-indexer/0.1",
        "X-GitHub-Api-Version": "2022-11-28",
    }
    if token:
        headers["Authorization"] = f"Bearer {token}"
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.load(resp)


def paged(url_template: str, token: str | None):
    page = 1
    while True:
        batch = request_json(url_template.format(page=page), token)
        if not isinstance(batch, list):
            raise RuntimeError(f"Expected list from {url_template}")
        yield from batch
        if len(batch) < 100:
            break
        page += 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="build/GREEN_BOARD.json")
    args = ap.parse_args()

    token = os.getenv("GITHUB_TOKEN")
    repos = list(paged(f"{API}/users/{USER}/repos?type=owner&sort=full_name&per_page=100&page={{page}}", token))

    entries = []
    closed_seen = 0
    closed_unmerged = 0
    repos_scanned = 0

    for repo in repos:
        if repo.get("archived") or repo.get("private"):
            continue
        name = repo["name"]
        repos_scanned += 1
        pulls_url = f"{API}/repos/{USER}/{name}/pulls?state=closed&sort=updated&direction=desc&per_page=100&page={{page}}"
        for pr in paged(pulls_url, token):
            closed_seen += 1
            merged_at = pr.get("merged_at")
            merge_sha = pr.get("merge_commit_sha")
            if not merged_at:
                closed_unmerged += 1
                continue
            if not merge_sha or not SHA40.fullmatch(merge_sha):
                raise RuntimeError(f"Merged PR missing valid merge SHA: {USER}/{name}#{pr.get('number')}")
            number = pr.get("number")
            url = pr.get("html_url")
            author = (pr.get("user") or {}).get("login")
            if not isinstance(number, int) or not url or not author:
                raise RuntimeError(f"Merged PR missing required metadata: {USER}/{name}#{number}")
            repo_full = f"{USER}/{name}"
            entries.append({
                "id": f"{name}-pr-{number}",
                "repo": repo_full,
                "pr": number,
                "title": pr.get("title") or f"PR #{number}",
                "commit_sha": merge_sha,
                "merged_at": merged_at,
                "replay_pointer": url,
                "author": author,
                "authority": False,
                "claim_truth": False,
                "ci_verified": False,
                "green_type": "MERGED_PR_CYCLE",
                "scope": "GITHUB_LIFECYCLE_RECEIPT",
                "status": "GREEN_MERGED_CYCLE",
                "epoch": merged_at[:7],
                "cycle": f"{repo_full}#{number}",
                "proof_statement": "GitHub reports this pull request as merged with the recorded merge commit and timestamp. This green is repository-lifecycle evidence only."
            })

    entries.sort(key=lambda x: (x["merged_at"], x["repo"], x["pr"]), reverse=True)
    payload = {
        "schema_version": "0.1.0",
        "board": "JSONWISDOM_NO_FAKE_GREEN_BOARD",
        "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "owner": USER,
        "wrapper": "PARENTAL_BOXDEE",
        "authority": False,
        "claim_truth": False,
        "green_semantics": "A green entry proves only that GitHub reports a merged PR cycle with complete required lifecycle metadata. It does not prove the underlying claim true, CI successful, employment, credential, production deployment, legal authority, or institutional endorsement.",
        "coverage": {
            "status": "LIVE_PUBLIC_REPO_SCAN",
            "repos_scanned": repos_scanned,
            "closed_prs_seen": closed_seen,
            "merged_prs_indexed": len(entries),
            "closed_unmerged_seen": closed_unmerged
        },
        "entries": entries
    }
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"wrote {len(entries)} merged lifecycle receipts to {out}")


if __name__ == "__main__":
    main()
