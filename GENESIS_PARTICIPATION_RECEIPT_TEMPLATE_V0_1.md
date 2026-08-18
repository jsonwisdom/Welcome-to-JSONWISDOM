# Genesis Participation Receipt Template v0.1

**Purpose:** Bind participation provenance for a doctrine before it can move from `HOLD_PARTICIPATION_PROVENANCE` toward `GENESIS_SAFE`.

**Parent doctrine:** `EPISTEMIC_DEVELOPMENT_ARCHITECTURE_V1_1.md`

**Authority created:** FALSE

This template records who actually participated, what they contributed, what objections or alternatives were raised, and what evidence supports those claims. It must not be used to infer participation, consent, authorship, dissent, exclusion, or approval that is not receipt-bound.

```text
DECLARED_PARTICIPATION != RECEIPT_BOUND_PARTICIPATION
SILENCE != CONSENT
ABSENCE_OF_DISSENT_RECEIPT != NO_DISSENT
MISSING_PROVENANCE != EXCLUSION_PROVEN
```

## A. Doctrine Identity

- Doctrine name:
- Repository:
- Branch / PR:
- Exact head SHA:
- Genesis period start:
- Genesis period end:
- Receipt author:
- Receipt creation timestamp:

## B. Origin Questions

For each origin question, record:

- Question ID:
- Exact question:
- Originator name or consented identifier:
- Role / relation to doctrine:
- Timestamp or bounded period:
- Source receipt URL / commit / document / message:
- Source hash or immutable identifier where available:
- Was this present before ontology/schema creation? `YES / NO / HOLD`

## C. Participation Ledger

For each participant:

- Participant name or consented identifier:
- Gender/self-identification only if relevant and consented:
- Participation stage(s): `GENESIS / IMAGINATION / ONTOLOGY / IMPLEMENTATION / EVIDENCE / REPLAY / CORRECTION`
- Contribution type: `QUESTION / AUTHORSHIP / DESIGN / IMPLEMENTATION / EVIDENCE / REVIEW / DISSENT / CORRECTION / OTHER`
- Exact contribution summary:
- Receipt pointer(s):
- Timestamp(s):
- Was contribution present before ontology/schema creation? `YES / NO / HOLD`
- Was contribution materially used? `YES / NO / PARTIAL / HOLD`
- If not used, was rejection/reason preserved? `YES / NO / HOLD`

## D. Women-From-Genesis Gate

This section must be supported by participant receipts, not doctrine text alone.

- Women present during genesis period? `YES / NO / HOLD`
- Receipt-bound women participants:
- Their genesis-stage contributions:
- Their authorship/design/questioning roles:
- Their evidence/review/dissent/correction roles, if any:
- Source receipts proving timing before ontology/schema creation:

Deterministic rule:

```text
WOMEN_PRESENT_AT_GENESIS = PASS
ONLY IF
AT_LEAST_ONE_RECEIPT_BOUND_WOMAN_PARTICIPANT
+ GENESIS_STAGE_CONTRIBUTION_BOUND
+ TIMING_BEFORE_OR_DURING_ONTOLOGY_CREATION_BOUND
```

This minimum proves presence, not representativeness or sufficiency of participation.

## E. Dissent / Alternative Ledger

For every material objection or alternative:

- Dissent / alternative ID:
- Raised by:
- Exact objection / alternative:
- Receipt pointer:
- Timestamp:
- Response / disposition:
- Decision owner:
- Was the original dissent preserved after revision? `YES / NO / HOLD`
- If rejected, reason receipt:

```text
NO_DISSENT_RECORDED != NO_DISSENT_EXISTED
DISSENT_PRESERVED != DISSENT_ACCEPTED
```

## F. Evidence / Exclusion Ledger

- Supporting evidence used:
- Contrary evidence used:
- Evidence offered but excluded:
- Who made each exclusion decision:
- Reason for exclusion:
- Receipt pointer:
- Unresolved evidence conflicts:

```text
EVIDENCE_EXCLUDED != EVIDENCE_FALSE
EVIDENCE_INCLUDED != EVIDENCE_CONCLUSIVE
```

## G. Decision Provenance

For each material doctrine decision:

- Decision ID:
- Decision:
- Decision owner:
- Inputs considered:
- Alternatives considered:
- Dissent considered:
- Reason:
- Receipt pointer:
- Revision that first contains decision:

## H. Correction Provenance

- Correction request ID:
- Requester:
- Requested change:
- Evidence supporting correction:
- Response:
- Decision owner:
- Changed state / no-change state:
- Original dissent preserved? `YES / NO / HOLD`
- New receipt pointer:

## I. Genesis-Safe Evaluation

Evaluate the receipt, not the aspiration:

```text
GENESIS_ORIGIN_QUESTIONS_BOUND = PASS / HOLD
WOMEN_AT_GENESIS_BOUND = PASS / HOLD / FAIL_UPSTREAM_INCLUSION
AUTHORSHIP_PROVENANCE_BOUND = PASS / HOLD
DISSENT_PROVENANCE_BOUND = PASS / HOLD / FAIL_DISSENT_PRESERVATION
EVIDENCE_PROVENANCE_BOUND = PASS / HOLD
DECISION_PROVENANCE_BOUND = PASS / HOLD / FAIL_PROVENANCE
CORRECTION_PROVENANCE_BOUND = PASS / HOLD
```

Final disposition:

```text
GENESIS_SAFE
HOLD
FAIL_UPSTREAM_INCLUSION
FAIL_AGENCY
FAIL_DISSENT_PRESERVATION
FAIL_PROVENANCE
```

## J. Promotion Discipline

```text
MERGEABLE != MERGE_READY
MERGE_READY != MERGE_AUTHORIZED
MERGEABLE != MERGE_AUTHORIZED
```

A completed participation receipt may support `MERGE_READY`; it does not authorize merge.

## K. Signature / Attestation

- Receipt prepared by:
- Date:
- Participants who reviewed their own attributed entries:
- Corrections requested by participants:
- Unresolved attribution disputes:

**Terminal:** `TEMPLATE_ONLY / NO_PARTICIPATION_CLAIMS_CREATED / AUTHORITY_FALSE`
