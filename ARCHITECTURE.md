# ARCHITECTURE.md — Canonical Root v1.0

**Classification:** JSONWisdom repository architecture canon  
**Legal authority created:** FALSE  
**External governmental authority created:** FALSE

This document is the canonical architecture root for the JSONWisdom repository ecosystem. It defines repository duties, replay boundaries, and internal governance invariants. Its use of the word `authority` does not create statutory, judicial, governmental, or other external legal authority.

## 1. Topology — Identity & Duty

| Surface | Role |
|---|---|
| `Welcome-to-JSONWISDOM` | identity root / canonical doorway |
| `COMPUTERWISDOM` | operational control plane + mission charter |
| `AL` | registry / courthouse / receipt machinery |
| `receiptos-base` | replay / frame / public-docket rail |
| `receipts-engine-v1` | public verifier / proof-display surface |
| `JOY` | witness / continuity layer |

### Replay Rail vs Verifier Surface

`receiptos-base` produces replay frames; `receipts-engine-v1` displays verified frames.

They are sequential, not interchangeable. This prevents downstream repositories from treating the verifier as a replay engine.

```text
receiptos-base
    ↓
REPLAY / FRAME / DOCKET
    ↓
receipts-engine-v1
    ↓
PUBLIC VERIFIER / PROOF DISPLAY
```

## 2. Invariants — Membrane & Authority

### 2.1 Replay Does Not Imply Truth

- `GREEN = receipt verified + hash matches + replay succeeds + authority=false`.
- `GREEN` does not mean the underlying claim is true.
- Replay is a timestamp, not a tribunal.
- Successful replay never elevates to truth, verdict, or legal finding.

```text
HASH_MATCH != FACT_TRUE
REPLAY_SUCCESS != LEGAL_FINDING
MERKLE_PROOF != JUDICIAL_PROOF
RECEIPT != VERDICT
```

### 2.2 No Recursive Authority

No surface may elevate another surface. Authority cannot be recursively granted.

This prohibits:

- JOY elevating AL;
- AL elevating `receiptos-base`;
- `receiptos-base` elevating `receipts-engine-v1`;
- `receipts-engine-v1` elevating EAS;
- EAS elevating ENS;
- ENS elevating anything else.

Authority must originate from an explicit external standard appropriate to the claimed authority — for example statute, delegation, tribunal charter, contract, or other independently valid source. It cannot be bootstrapped through the repository graph.

```text
REPOSITORY_ROLE != LEGAL_AUTHORITY
UPSTREAM_RECEIPT != DOWNSTREAM_AUTHORITY
WITNESS != ADJUDICATION
DISCOVERY != AUTHORIZATION
```

### 2.3 Cross-Surface Drift Detector

Any surface — README, duty table, narrative, binding, registry, or render layer — that contradicts this topology is out of architectural canon until reconciled.

Examples include:

- Welcome README omitting `receiptos-base`;
- COMPUTERWISDOM misstating roles;
- AL duty-table drift;
- JOY narrative self-elevating;
- verifier surfaces claiming replay-engine authority.

Reconciliation requires updating the offending document to match this root, not silently redefining this root through downstream drift.

```text
DOWNSTREAM_DRIFT != ROOT_REDEFINITION
CONTRADICTION → HOLD_CANON → RECONCILE
```

## 3. Authority Elevation Path — Explicit

A claim may move through the following repository-governance sequence. No step implies the next unless separately authorized.

1. Machine-readable receipt — raw event.
2. Replay instructions — how to reproduce.
3. Review record — human or procedural check.
4. Merge commit — integration into a public docket.
5. Witness record — JOY continuity seal.

This sequence records promotion state inside the ecosystem. It does **not** create legal authority merely by completion.

```text
RECEIPT != REVIEW
REVIEW != MERGE
MERGE != WITNESS
WITNESS != LEGAL_AUTHORITY
```

## 4. Layer Law

| Layer | Function |
|---|---|
| Replay | verifies bytes / hashes / integrity |
| GitHub | provides context, timeline, and provenance |
| EAS | witnesses the receipt on-chain / timestamp layer |
| ENS | discovers the canonical packet when valid and unexpired |

```text
REPLAY = INTEGRITY
GITHUB = CONTEXT + PROVENANCE
EAS = WITNESS
ENS = DISCOVERY
```

None of these roles silently promotes into another.

## 5. Closing Invariant

Continuity is preserved through evidence, not assertion.

```text
NO RECEIPT → NO AUTHORITY CLAIM
NO REPLAY → NO PROMOTION
NO FAKE GREEN
```

## Status

```text
ARCHITECTURE_VERSION = 1.0
CANONICAL_REPOSITORY_ROOT = Welcome-to-JSONWISDOM/ARCHITECTURE.md
CROSS_SURFACE_ALIGNMENT_REQUIRED = TRUE
RECURSIVE_AUTHORITY = FORBIDDEN
REPLAY_IMPLIES_TRUTH = FALSE
LEGAL_AUTHORITY_CREATED = FALSE
```

This document is the single authoritative **repository-architecture root** for the ecosystem. All connected JSONWisdom surfaces should align with it. Drift is flagged and corrected through explicit reviewable changes.
