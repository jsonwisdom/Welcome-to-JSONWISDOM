# Genesis-Safe Ontology Checklist v1.1

**Classification:** deterministic internal promotion gate  
**Parent doctrine:** `EPISTEMIC_DEVELOPMENT_ARCHITECTURE_V1_1.md`  
**Legal authority created:** FALSE

This checklist is a promotion gate for new doctrines. It is not advisory and does not itself prove participation facts that are not receipt-bound.

## GENESIS

- Who originated the questions?
- Were women present before ontology/schema creation?
- Is authorship preserved?
- Is dissent preserved?

Required receipts may include authorship history, review records, issue/discussion provenance, decision notes, consented participant records, or equivalent source-bound evidence.

## ONTOLOGY

- Are women represented as actors rather than an appendix?
- Do questions, alternatives, and objections have first-class paths?
- Does missing participation remain visible?

## IMPLEMENTATION

- Does an author → requirement → implementation trace exist?
- Are alternatives considered retained?
- Is automation forbidden from manufacturing authority?

## EVIDENCE

- Is supporting evidence preserved?
- Is contrary evidence preserved?
- Are exclusions documented?
- Is decision provenance reconstructable?

## REPLAY

- `PASS != WORLD_TRUE`
- `CONFLICT` may remain unresolved.
- `HOLD` is allowed.
- Replay cannot become tribunal or verdict.

## CORRECTION

- Do women remain correction actors?
- Does original dissent survive revision?
- Do corrections create new receipts rather than overwrite history?

## Deterministic result states

```text
GENESIS_SAFE
HOLD
FAIL_UPSTREAM_INCLUSION
FAIL_AGENCY
FAIL_DISSENT_PRESERVATION
FAIL_PROVENANCE
```

### Classification rules

```text
GENESIS_SAFE = all required gates satisfied by bound evidence
HOLD = required evidence or provenance is incomplete
FAIL_UPSTREAM_INCLUSION = evidence shows participation begins downstream
FAIL_AGENCY = evidence shows women represented only as subjects
FAIL_DISSENT_PRESERVATION = evidence shows objection/dissent disappeared
FAIL_PROVENANCE = decision cannot be reconstructed
```

Absence of evidence must not be silently converted into a failure finding when the correct state is `HOLD`.

## Merge discipline

```text
MERGEABLE = Git mechanics permit integration
MERGE_READY = doctrine survived required review gates
MERGE_AUTHORIZED = human explicitly decided to promote it

MERGEABLE != MERGE_READY
MERGE_READY != MERGE_AUTHORIZED
MERGEABLE != MERGE_AUTHORIZED
```

## Self-application rule

PR #24 / Women From Genesis v1.1 is the first doctrine required to satisfy this checklist before promotion.

A doctrine may declare a participation invariant without proving that its own creation process satisfied that invariant.

```text
DECLARED_WOMEN_FROM_GENESIS
!=
RECEIPT_BOUND_WOMEN_FROM_GENESIS
```

No promotion may treat those states as interchangeable.
