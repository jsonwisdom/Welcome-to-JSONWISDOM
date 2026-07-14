# JQG-50 Fixture Verification Harness

Target fixture: `JQG-50 v1.0.0-rc.1`

## Canonicalization Requirement

Replay safety requires deterministic serialization before hashing.

Recommended rules:

1. UTF-8 encoding.
2. Object keys sorted lexicographically.
3. No insignificant whitespace.
4. Arrays preserve declared order.
5. Timestamps use RFC 3339 UTC form.
6. SHA-256 is computed over canonical bytes only.

## Test Matrix

| Test ID | Objective | Input | Expected Result |
|---|---|---|---|
| `TC-01` | Replay safety | Canonical packet replayed through parser | Deterministic bytes and identical SHA-256 |
| `TC-02` | Partial trace | Valid Left Pincer with missing Right Pincer metadata | `PARTIAL_TRACE_GAP`; progression to `L-3` blocked |
| `TC-03` | Audit priority | Unexplained access + material benefit + temporal alignment + missing/conflicting receipt | `HIGH_PRIORITY_AUDIT_TARGET` without attribution |
| `TC-04` | Hash validity boundary | Correctly hashed fabricated source | Integrity may pass; source binding fails |
| `TC-05` | Lineage integrity | New packet contradicts prior packet | New packet references parent; both preserved |
| `TC-06` | Null void | Search operation returns no result or fails | `404_VOID` and `UNRESOLVED`; never `CLEARED` |

## Required Assertions

### TC-01

```text
canonicalize(packet_a) == canonicalize(packet_b)
sha256(canonicalize(packet_a)) == sha256(canonicalize(packet_b))
```

### TC-02

```text
result = PARTIAL_TRACE_GAP
state ∈ {L-1, L-2}
progression_to_L3 = BLOCKED
```

### TC-03

All four signals are required:

```text
UNEXPLAINED_ACCESS = TRUE
MATERIAL_BENEFIT = TRUE
TEMPORAL_ALIGNMENT = TRUE
MISSING_OR_CONFLICTING_RECEIPT = TRUE
```

Expected:

```text
result = HIGH_PRIORITY_AUDIT_TARGET
attribution = NOT_ESTABLISHED
```

### TC-04

```text
integrity = PASS
source_binding = FAIL
claim_relevance = NONE | INDIRECT
```

A valid hash must not promote a fabricated source to truth.

### TC-05

```text
new.parent_packet_hash = sha256(canonicalize(prior_packet))
prior_packet_mutated = FALSE
contradictions_preserved = TRUE
```

### TC-06

```text
search_result = 404_VOID
result = UNRESOLVED
cleared = FALSE
```

## Release Gate

The release candidate is eligible for freeze only when all six tests have observed execution receipts.

```text
SPEC_PRESENT = TRUE
SCHEMA_PRESENT = TRUE
TEST_DEFINITIONS_PRESENT = TRUE
TEST_EXECUTION_OBSERVED = FALSE
FREEZE_READY = FALSE
```