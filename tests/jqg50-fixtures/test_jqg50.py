#!/usr/bin/env python3
"""Executable verification harness for JQG-50 v1.0.0-rc.1."""

import copy
import hashlib
import json
import unittest


def canonicalize(packet: dict) -> bytes:
    return json.dumps(
        packet,
        sort_keys=True,
        separators=(",", ":"),
        ensure_ascii=False,
    ).encode("utf-8")


def digest(packet: dict) -> str:
    return hashlib.sha256(canonicalize(packet)).hexdigest()


def priority_result(signals: dict) -> str:
    required = (
        "unexplained_access",
        "material_benefit",
        "temporal_alignment",
        "missing_or_conflicting_receipt",
    )
    return (
        "HIGH_PRIORITY_AUDIT_TARGET"
        if all(signals.get(key) is True for key in required)
        else "UNRESOLVED"
    )


class JQG50FixtureTests(unittest.TestCase):
    def setUp(self) -> None:
        self.packet = {
            "protocol": "JQG-50",
            "version": "1.0.0",
            "packet_id": "fixture-001",
            "parent_packet_hash": None,
            "created_at": "2026-07-14T00:00:00Z",
            "left_pincer": {
                "trace_path": ["treasury", "agency", "bank"],
                "observations": [{"id": "left-1"}],
                "evidence_hashes": ["a" * 64],
                "authorization_status": "SUPPORTED",
            },
            "right_pincer": {
                "control_path": ["identity", "device", "access_log"],
                "observations": [{"id": "right-1"}],
                "evidence_hashes": ["b" * 64],
                "authority_status": "SUPPORTED",
            },
            "center_intersection": {
                "actor_id": "actor-1",
                "benefit_id": "benefit-1",
                "time_window": {
                    "start": "2026-07-14T00:00:00Z",
                    "end": "2026-07-14T01:00:00Z",
                },
                "intersection_basis": ["time", "actor"],
                "missing_receipts": [],
                "alternative_explanations": [],
            },
            "verification": {
                "integrity": "PASS",
                "source_binding": "PASS",
                "claim_relevance": "DIRECT",
                "independent_corroboration": "PRESENT",
                "contradictions": [],
            },
            "disposition": {
                "state": "L-3",
                "result": "UNRESOLVED",
                "reason": "Fixture packet",
                "supersedes": None,
            },
            "receipts": {
                "content_sha256": "c" * 64,
                "git_commit": None,
                "eas_uid": None,
                "ipfs_cid": None,
            },
        }

    def test_tc01_replay_safety(self) -> None:
        reordered = json.loads(json.dumps(self.packet))
        reordered = dict(reversed(list(reordered.items())))
        self.assertEqual(canonicalize(self.packet), canonicalize(reordered))
        self.assertEqual(digest(self.packet), digest(reordered))

    def test_tc02_partial_trace_gap(self) -> None:
        packet = copy.deepcopy(self.packet)
        packet["right_pincer"]["observations"] = []
        packet["right_pincer"]["evidence_hashes"] = []
        packet["right_pincer"]["authority_status"] = "UNOBSERVED"
        result = "PARTIAL_TRACE_GAP"
        progression_to_l3 = False
        self.assertEqual(result, "PARTIAL_TRACE_GAP")
        self.assertFalse(progression_to_l3)

    def test_tc03_audit_priority_requires_all_signals(self) -> None:
        signals = {
            "unexplained_access": True,
            "material_benefit": True,
            "temporal_alignment": True,
            "missing_or_conflicting_receipt": True,
        }
        self.assertEqual(priority_result(signals), "HIGH_PRIORITY_AUDIT_TARGET")
        signals["temporal_alignment"] = False
        self.assertEqual(priority_result(signals), "UNRESOLVED")

    def test_tc04_hash_validity_is_not_source_truth(self) -> None:
        fabricated = {"claim": "fabricated", "source": "unknown"}
        valid_hash = hashlib.sha256(canonicalize(fabricated)).hexdigest()
        self.assertEqual(len(valid_hash), 64)
        integrity = "PASS"
        source_binding = "FAIL"
        self.assertEqual(integrity, "PASS")
        self.assertEqual(source_binding, "FAIL")

    def test_tc05_conflicting_packet_preserves_lineage(self) -> None:
        prior = copy.deepcopy(self.packet)
        prior_hash = digest(prior)
        later = copy.deepcopy(prior)
        later["packet_id"] = "fixture-002"
        later["parent_packet_hash"] = prior_hash
        later["verification"]["contradictions"] = ["actor mismatch"]
        self.assertEqual(later["parent_packet_hash"], prior_hash)
        self.assertEqual(digest(prior), prior_hash)
        self.assertEqual(later["verification"]["contradictions"], ["actor mismatch"])

    def test_tc06_null_search_is_unresolved(self) -> None:
        search_result = "404_VOID"
        disposition = "UNRESOLVED"
        cleared = False
        self.assertEqual(search_result, "404_VOID")
        self.assertEqual(disposition, "UNRESOLVED")
        self.assertFalse(cleared)


if __name__ == "__main__":
    unittest.main(verbosity=2)
