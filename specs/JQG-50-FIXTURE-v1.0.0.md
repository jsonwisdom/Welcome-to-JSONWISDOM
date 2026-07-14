# JQG-50 Fixture v1.0.0-rc.1

## Status

- Protocol: `JQG-50`
- Release: `v1.0.0-rc.1`
- Artifact type: operational audit fixture
- Authority scope: repository protocol logic only
- Governmental authority: `false`
- Mutation policy: append-only receipts; prior packets are never edited

## Purpose

JQG-50 is a replay-safe audit framework that separates two evidence streams:

- **Left Pincer — Value:** financial and resource flows.
- **Right Pincer — Control:** identity, device, access, location, and communications flows.

The streams may intersect on an actor, resource, place, or time. An intersection is an audit signal, not proof of misconduct.

## Immutable Invariants

- `I-01` NULL SEARCH RESULT ≠ NONEXISTENCE.
- `I-02` HASH VALIDITY ≠ SOURCE TRUTH.
- `I-03` INTERSECTION ≠ MISCONDUCT.
- `I-04` GAP ≠ DELETION.
- `I-05` HIGH-PRIORITY TARGET ≠ ATTRIBUTION.
- `I-06` CONTRADICTIONS MUST BE PRESERVED.
- `I-07` PRIOR RECEIPTS MUST NEVER BE EDITED.
- `I-08` EVERY DISPOSITION REQUIRES A REASON.
- `I-09` PERSONALLY IDENTIFYING DATA MUST BE MINIMIZED.
- `I-10` CHILD, VICTIM, AND WITNESS GEOLOCATION MUST NOT BE PUBLIC.

## State Machine

| State | Label | Definition | Gate |
|---|---|---|---|
| `L-0` | RAW | Unprocessed material; no attribution. | Indexing only. |
| `L-1` | NORMALIZED | Canonical format, source identity, and hashes recorded. | Canonicalization and integrity metadata complete. |
| `L-2` | INTERSECTED | Value and control streams overlap on actor, resource, place, or time. | Intersection basis and time window recorded. |
| `L-3` | CORROBORATED | Integrity and source relevance tested; contradictions preserved. | Source binding and claim relevance evaluated. |
| `L-4` | DISPOSITIONED | Explicit result issued with rationale and immutable receipt. | Reason and final receipt required. |

```text
L-0 → L-1 → L-2 → L-3 → L-4
```

No packet moves backward. A later contradiction creates a new packet referencing the prior packet hash.

## Audit Priority Gate

A packet may be classified as `HIGH_PRIORITY_AUDIT_TARGET` only when all four conditions are recorded:

```text
UNEXPLAINED_ACCESS
+ MATERIAL_BENEFIT
+ TEMPORAL_ALIGNMENT
+ MISSING_OR_CONFLICTING_RECEIPT
```

This classification is not attribution and does not establish misconduct.

## Verification Dimensions

- `integrity`: `PASS | FAIL | UNOBSERVED`
- `source_binding`: `PASS | FAIL | PARTIAL`
- `claim_relevance`: `DIRECT | INDIRECT | NONE`
- `independent_corroboration`: `PRESENT | ABSENT`

A valid hash proves byte preservation only. Source honesty, completeness, authority, and relevance require separate evaluation.

## Disposition Results

- `HIGH_PRIORITY_AUDIT_TARGET`
- `SUBSTANTIATED`
- `UNSUBSTANTIATED`
- `UNRESOLVED`
- `PARTIAL_TRACE_GAP`
- `DISMISSED`
- `OUT_OF_SCOPE`

A null search result must return `404_VOID` and remain `UNRESOLVED`; it must never be promoted to `CLEARED`.

## Versioning

- **MAJOR:** incompatible semantic or validation change.
- **MINOR:** backward-compatible field or state addition.
- **PATCH:** clarification, test correction, typo, or implementation repair.

Silent hot-patching is forbidden.

## Repository Layout

```text
specs/JQG-50-FIXTURE-v1.0.0.md
schemas/jqg50-audit-packet-v1.0.0.schema.json
tests/jqg50-fixtures/README.md
```

## Verdict

```text
COMPRESSION_REQUIREMENTS = CAPTURED
TARGET_VERSION = JQG-50 v1.0.0-rc.1
FREEZE_STATUS = RELEASE_CANDIDATE
PUBLIC_AUTHORITY = FALSE
RECEIPT_MUTATION = FORBIDDEN
```