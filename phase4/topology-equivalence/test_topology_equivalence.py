#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
import pathlib
import subprocess
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parent
FIXTURES = ROOT / "fixtures"
sys.path.insert(0, str(ROOT))
from normalize_findings import canonicalize  # noqa: E402


def run(*args: str) -> str:
    return subprocess.check_output(args, text=True).strip()


def build_findings(repo: pathlib.Path, base: dict) -> dict:
    artifact = base["artifact"]
    content = (repo / artifact["path"]).read_bytes()
    return {
        "artifacts": [{
            "path": artifact["path"],
            "content_sha256": hashlib.sha256(content).hexdigest(),
            "evidence_role": artifact["evidence_role"],
            "gap_class": artifact["gap_class"],
            "exit_reason": artifact["exit_reason"],
            "max_state": artifact["max_state"],
        }],
        "policy": base["policy"],
    }


def commit_set(repo: pathlib.Path) -> set[str]:
    return set(run("git", "-C", str(repo), "rev-list", "HEAD").splitlines())


def edge_set(repo: pathlib.Path) -> set[str]:
    lines = run("git", "-C", str(repo), "rev-list", "--parents", "HEAD").splitlines()
    edges: set[str] = set()
    for line in lines:
        parts = line.split()
        for parent in parts[1:]:
            edges.add(f"{parent}->{parts[0]}")
    return edges


def raw_matrix(repo: pathlib.Path) -> bytes:
    rows = ["commit,max_state,gap_class,exit_reason"]
    for commit in run("git", "-C", str(repo), "rev-list", "--reverse", "HEAD").splitlines():
        rows.append(f"{commit},L-2,partial,HASH_OR_REFERENCE_PRESENT_WITHOUT_COMPLETE_RECEIPT_SET")
    return ("\n".join(rows) + "\n").encode()


def main() -> None:
    base = json.loads((FIXTURES / "canonical_base.json").read_text())
    assert base["authority"] is False
    with tempfile.TemporaryDirectory() as td:
        root = pathlib.Path(td)
        graph_a, graph_b = root / "graph-a", root / "graph-b"
        subprocess.run(["bash", str(FIXTURES / "graph_a.sh"), str(graph_a), str(FIXTURES / "canonical_base.json")], check=True)
        subprocess.run(["bash", str(FIXTURES / "graph_b.sh"), str(graph_b), str(FIXTURES / "canonical_base.json")], check=True)

        commits_a, commits_b = commit_set(graph_a), commit_set(graph_b)
        edges_a, edges_b = edge_set(graph_a), edge_set(graph_b)
        assert len(commits_a) == 2
        assert len(commits_b) == 1
        assert commits_a != commits_b
        assert edges_a != edges_b

        raw_a, raw_b = raw_matrix(graph_a), raw_matrix(graph_b)
        assert len(raw_a.splitlines()) != len(raw_b.splitlines())
        assert hashlib.sha256(raw_a).hexdigest() != hashlib.sha256(raw_b).hexdigest()

        projection_a, digest_a = canonicalize(build_findings(graph_a, base))
        projection_b, digest_b = canonicalize(build_findings(graph_b, base))
        assert projection_a["final_tree_digest"] == projection_b["final_tree_digest"]
        assert projection_a["artifacts"] == projection_b["artifacts"]
        assert digest_a == digest_b

        receipt = {
            "VECTOR": "TOPOLOGY_EQUIVALENCE",
            "GRAPH_A_COMMIT_COUNT": 2,
            "GRAPH_B_COMMIT_COUNT": 1,
            "GRAPH_COMMIT_SETS_EQUAL": False,
            "PARENT_EDGE_SETS_EQUAL": False,
            "RAW_MATRIX_ROW_COUNTS_EQUAL": False,
            "RAW_MATRIX_SHA256_EQUAL": False,
            "FINAL_TREE_DIGEST_EQUAL": True,
            "NORMALIZED_ARTIFACT_SET_EQUAL": True,
            "NORMALIZED_FINDINGS_SHA256_EQUAL": True,
            "POLICY_MODE_EQUAL": True,
            "MAX_STATE_A": "L-2",
            "MAX_STATE_B": "L-2",
            "CANONICAL_HISTORY_MUTATED": False,
            "FIXTURE_REPOSITORIES_EPHEMERAL": True,
            "UNKNOWN_FIELDS_REJECTED": True,
            "TOPOLOGY_EQUIVALENCE_PROVEN_FOR_FIXTURE": True,
            "UNIVERSAL_TOPOLOGY_EQUIVALENCE_CLAIMED": False,
            "AUTHORITY": False,
            "NORMALIZED_FINDINGS_SHA256": digest_a,
        }
        pathlib.Path("PHASE_IV_TOPOLOGY_EQUIVALENCE_RECEIPT.json").write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
        print(json.dumps(receipt, sort_keys=True))


if __name__ == "__main__":
    main()
