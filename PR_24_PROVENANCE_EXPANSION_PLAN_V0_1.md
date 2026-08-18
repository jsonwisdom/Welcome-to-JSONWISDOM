# PR #24 Provenance Expansion Plan v0.1

**Target:** Move `PR_24_GENESIS_SAFE` from `HOLD_PARTICIPATION_PROVENANCE` toward `GENESIS_SAFE` without inventing participants, consent, authorship, dissent, or exclusion.

**Current PR:** #24  
**Current branch:** `agent/women-from-genesis-epistemic-v1-1`  
**Current legal authority created:** FALSE

## Current Hold

```text
GENESIS = HOLD_PARTICIPATION_PROVENANCE
EVIDENCE = HOLD_SELF_PROVENANCE
MERGE_READY = FALSE
MERGE_AUTHORIZED = FALSE
```

The doctrine text defines the required participation model. The missing edge is evidence that the doctrine's own genesis followed that model.

## Required Expansion

### 1. Bind Genesis Period

Record the bounded time window in which the doctrine's core questions, ontology, and invariants were first formed.

Required receipt:
- earliest source carrying Women-From-Genesis concept;
- first ontology/schema expression;
- chronology between those two events.

### 2. Bind Origin Questions

For each material genesis question:
- who asked it;
- exact wording or faithful bounded summary;
- timestamp or bounded period;
- source pointer;
- whether it predates ontology/schema creation.

### 3. Bind Women-at-Genesis Participation

Do not infer from doctrine content or later review.

Required evidence:
- at least one consented/appropriately identified woman participant;
- receipt-bound genesis-stage contribution;
- timing showing contribution existed before or during ontology creation.

This proves presence only. It does not prove representativeness, consent of others, or absence of exclusion.

### 4. Bind Authorship Provenance

Map material sections/invariants to their known originators or mark attribution `HOLD`.

```text
UNKNOWN_AUTHOR != COLLECTIVE_AUTHORSHIP_PROVEN
EDITOR != ORIGINATOR_BY_DEFAULT
COMMITTER != SOLE_AUTHOR_BY_DEFAULT
```

### 5. Bind Dissent / Alternatives

Search available genesis records for objections and alternatives.

If none are found:

```text
NO_DISSENT_RECEIPT_FOUND = HOLD_NO_DISSENT_EVIDENCE
NOT = NO_DISSENT_EXISTED
```

Preserve any dissent through later edits.

### 6. Bind Evidence / Exclusion Decisions

For evidence that informed doctrine design:
- supporting evidence;
- contrary evidence;
- evidence intentionally excluded;
- exclusion decision owner and reason.

If exclusion history is unavailable, record `HOLD`.

### 7. Bind Decision Provenance

For material choices, including:
- Women From Genesis as cross-cutting invariant;
- Girl Math as non-gender-exclusive hypothesis operator;
- anti-tribunal replay membrane;
- fail-closed genesis classifications;

record who made/accepted the decision, alternatives considered, and source receipt.

### 8. Bind Correction Provenance

Preserve the documented correction from an append-only/women-at-review model to a genesis-level model, including:
- triggering objection/correction;
- changed doctrine state;
- preserved prior state;
- receipt linking before/after.

## Re-run Gate

After receipts are bound, rerun `GENESIS_SAFE_ONTOLOGY_CHECKLIST_V1_1.md`.

Promotion candidate only if:

```text
GENESIS_ORIGIN_QUESTIONS_BOUND = PASS
WOMEN_AT_GENESIS_BOUND = PASS
AUTHORSHIP_PROVENANCE_BOUND = PASS
DISSENT_PROVENANCE_BOUND = PASS_OR_EXPLICIT_HOLD_ACCEPTED_BY_POLICY
EVIDENCE_PROVENANCE_BOUND = PASS_OR_SCOPED_HOLD
DECISION_PROVENANCE_BOUND = PASS
CORRECTION_PROVENANCE_BOUND = PASS
```

A policy decision is still required on whether scoped HOLD states may coexist with `GENESIS_SAFE`; the current checklist should default fail-closed until that is explicitly defined.

## Merge Discipline

```text
PR_MERGEABLE = GIT_STATE_ONLY
GENESIS_SAFE = EVIDENCE_GATE_STATE
MERGE_READY = REVIEW_GATE_STATE
MERGE_AUTHORIZED = HUMAN_AUTHORIZATION_STATE
```

No state substitutes for another.

**Terminal:** `PROVENANCE_EXPANSION_PLAN_READY / PR_REMAINS_DRAFT / NO_MERGE / AUTHORITY_FALSE`
