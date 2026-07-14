#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
import pathlib
from typing import Any

SCHEMA = "JQG50_TOPOLOGY_EQUIVALENCE_V1"
ROLE_ENUM = {
    "ASSERTION_SOURCE",
    "REVIEW_CONTEXT",
    "CLASSIFIER_IMPLEMENTATION",
    "COMMIT_CONTEXT",
}
ARTIFACT_FIELDS = {
    "path",
    "content_sha256",
    "evidence_role",
    "gap_class",
    "exit_reason",
    "max_state",
}
POLICY_FIELDS = {"mode", "version"}
FINDINGS_FIELDS = {"artifacts", "policy"}


def _canonical_bytes(value: Any) -> bytes:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode("utf-8")


def _normalize_path(raw: str) -> str:
    path = pathlib.PurePosixPath(raw)
    normalized = str(path)
    if path.is_absolute() or normalized in {"", "."} or ".." in path.parts:
        raise ValueError("INVALID_NORMALIZED_PATH")
    return normalized


def canonicalize(graph_findings: dict[str, Any]) -> tuple[dict[str, Any], str]:
    unknown_top = set(graph_findings) - FINDINGS_FIELDS
    missing_top = FINDINGS_FIELDS - set(graph_findings)
    if unknown_top:
        raise ValueError(f"UNKNOWN_FINDINGS_FIELDS:{sorted(unknown_top)}")
    if missing_top:
        raise ValueError(f"MISSING_FINDINGS_FIELDS:{sorted(missing_top)}")

    policy = graph_findings["policy"]
    if not isinstance(policy, dict) or set(policy) != POLICY_FIELDS:
        raise ValueError("INVALID_POLICY_FIELDS")

    raw_artifacts = graph_findings["artifacts"]
    if not isinstance(raw_artifacts, list) or not raw_artifacts:
        raise ValueError("ARTIFACTS_REQUIRED")

    artifacts: list[dict[str, str]] = []
    seen: set[str] = set()
    for raw in raw_artifacts:
        if not isinstance(raw, dict) or set(raw) != ARTIFACT_FIELDS:
            raise ValueError("INVALID_ARTIFACT_FIELDS")
        artifact = {key: str(raw[key]) for key in ARTIFACT_FIELDS}
        artifact["path"] = _normalize_path(artifact["path"])
        if artifact["path"] in seen:
            raise ValueError("DUPLICATE_NORMALIZED_PATH")
        seen.add(artifact["path"])
        if artifact["evidence_role"] not in ROLE_ENUM:
            raise ValueError("INVALID_EVIDENCE_ROLE")
        if artifact["max_state"] != "L-2":
            raise ValueError("MAX_STATE_CEILING_VIOLATION")
        if len(artifact["content_sha256"]) != 64:
            raise ValueError("INVALID_CONTENT_SHA256")
        artifacts.append(artifact)

    artifacts.sort(key=lambda item: item["path"])
    tree_material = [
        {"path": item["path"], "content_sha256": item["content_sha256"]}
        for item in artifacts
    ]
    final_tree_digest = hashlib.sha256(_canonical_bytes(tree_material)).hexdigest()
    projection = {
        "schema": SCHEMA,
        "final_tree_digest": final_tree_digest,
        "artifacts": artifacts,
        "policy": {"mode": str(policy["mode"]), "version": str(policy["version"])},
    }
    digest = hashlib.sha256(_canonical_bytes(projection)).hexdigest()
    return projection, digest
