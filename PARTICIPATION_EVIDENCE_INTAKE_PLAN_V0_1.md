# Participation Evidence Intake Plan v0.1

**Parent doctrine:** `EPISTEMIC_DEVELOPMENT_ARCHITECTURE_V1_1.md`  
**Parent checklist:** `GENESIS_SAFE_ONTOLOGY_CHECKLIST_V1_1.md`  
**PR:** #24  
**Classification:** participation-evidence intake / provenance binding  
**Legal authority created:** FALSE  
**Merge authorization created:** FALSE

## 1. Purpose

This plan governs how candidate participation records are discovered, classified, attributed, time-bound, reviewed, sealed, and admitted into the Genesis-Safe evaluation of PR #24.

It is not a doctrine-expansion surface. It is an evidence-intake state machine.

```text
BIND_WHAT_EXISTS
HOLD_WHAT_DOES_NOT
DO_NOT_RETROFIT_PARTICIPATION
DO_NOT_INFER_CONSENT
DO_NOT_INFER_AUTHORSHIP_FROM_GIT_METADATA
```

## 2. Strict ordered sequence

Every candidate record must pass through the following sequence in this exact order:

```text
1  SOURCE_DISCOVERY
2  SOURCE_CLASSIFICATION
3  CONSENT / ATTRIBUTION CHECK
4  TIMESTAMP BINDING
5  CONTRIBUTION BINDING
6  GENESIS-TIMING TEST
7  DISSENT / ALTERNATIVE BINDING
8  DECISION-PROVENANCE BINDING
9  PARTICIPANT REVIEW
10 RECEIPT SEAL
11 CHECKLIST RERUN
```

### Ordering invariant

No later step may execute until every prior step has a terminal disposition for that candidate record.

```text
STEP_N_TERMINAL_REQUIRED_BEFORE_STEP_N_PLUS_1 = TRUE
OUT_OF_ORDER_BINDING = REJECT
```

A candidate may stop at any step when its state becomes terminal for that stage.

## 3. Candidate-record state enum

Each candidate record must have **exactly one** current disposition:

```text
BOUND
HOLD_SOURCE
HOLD_ATTRIBUTION
HOLD_CONSENT
HOLD_TIMING
CONFLICT
REJECT
```

No composite state is allowed.

```text
ONE_CANDIDATE = ONE_CURRENT_STATE
MULTIPLE_SIMULTANEOUS_STATES = INVALID
```

### State semantics

- `BOUND` — required evidence for the completed intake stage is receipt-bound and internally consistent.
- `HOLD_SOURCE` — the source cannot yet be located, fetched, or sufficiently identified.
- `HOLD_ATTRIBUTION` — the record exists but attribution to a person/identifier/contribution remains unresolved.
- `HOLD_CONSENT` — publication or use of identity/communication content lacks the required consent basis for the intended surface.
- `HOLD_TIMING` — the record exists but cannot yet be bound to the required time or genesis window.
- `CONFLICT` — valid records materially disagree and the disagreement is preserved unresolved.
- `REJECT` — the candidate is contradicted, outside scope, invalid for the claimed binding, or violates intake rules.

## 4. Candidate record schema

Each candidate record should preserve, at minimum:

```text
candidate_id
source_type
source_locator
source_hash_or_immutable_id
source_observed_at
proposed_participant_identifier
attribution_basis
consent_state
claimed_contribution
contribution_stage
contribution_timestamp_or_window
genesis_window_relation
dissent_or_alternative_pointer
decision_provenance_pointer
participant_review_state
receipt_seal_pointer
current_intake_step
current_state
limits
```

Fields that are unknown remain explicitly unknown. Blank does not mean negative.

```text
UNKNOWN != NO
BLANK != NONE_EXISTED
UNOBSERVED != ABSENT
```

## 5. Step rules

### Step 1 — SOURCE_DISCOVERY

Goal: locate the candidate source without interpreting participation.

Allowed sources may include, where lawfully and appropriately accessible:

- GitHub commits, PRs, issues, comments, reviews, files, or artifacts;
- Google Drive documents or revision history;
- messages supplied by participants;
- signed statements or attestations;
- timestamped notes, design artifacts, or meeting records;
- other records with sufficient provenance.

Terminal possibilities:

```text
source found and sufficiently identified → BOUND
source not yet found / inaccessible        → HOLD_SOURCE
source outside scope / invalid             → REJECT
```

### Step 2 — SOURCE_CLASSIFICATION

Classify the source before using it:

```text
PRIMARY_PARTICIPANT_RECORD
CONTEMPORANEOUS_PROJECT_RECORD
LATER_RECOLLECTION
DERIVED_SUMMARY
MACHINE_METADATA
THIRD_PARTY_RECORD
```

Classification never upgrades evidentiary weight by itself.

```text
SOURCE_CLASS != TRUTH
PRIMARY != CONCLUSIVE
MACHINE_METADATA != EPISTEMIC_AUTHORSHIP
```

### Step 3 — CONSENT / ATTRIBUTION CHECK

Bind attribution separately from publication consent.

Questions:

```text
WHO_OR_WHAT_DOES_THIS_RECORD_ACTUALLY_BIND?
IS_THE_IDENTIFIER_CONSENTED_FOR_THIS USE?
IS_PRIVATE_CONTENT_REQUIRED_OR_CAN_A MINIMIZED POINTER SUFFICE?
```

Outcomes:

```text
attribution unresolved → HOLD_ATTRIBUTION
publication/use consent unresolved where required → HOLD_CONSENT
attribution + privacy basis sufficient → BOUND
```

### Step 4 — TIMESTAMP BINDING

Bind time independently of memory or present-day endorsement.

Preferred anchors include immutable or provider-generated timestamps, signed records, document revisions, commit metadata used only for the event it actually records, or other source-bound timing evidence.

```text
MEMORY_ALONE != TIMESTAMP_RECEIPT
CURRENT_TIMESTAMP != HISTORICAL_EVENT_TIMESTAMP
COMMIT_TIME != ORIGIN_TIME_BY_DEFAULT
```

Unresolved timing → `HOLD_TIMING`.

### Step 5 — CONTRIBUTION BINDING

Bind the exact contribution, not a generalized participation claim.

```text
PARTICIPATED != AUTHORED_EVERYTHING
REVIEWED != ORIGINATED
IMPLEMENTED != DESIGNED_BY_DEFAULT
COMMITTED != SOLE_AUTHOR_BY_DEFAULT
```

Record the contribution as narrowly as the evidence supports.

### Step 6 — GENESIS-TIMING TEST

Compare the bound contribution time to the bounded genesis window.

Allowed classifications:

```text
BEFORE_ONTOLOGY
DURING_ONTOLOGY
AFTER_ONTOLOGY
GENESIS_RELATION_HOLD
```

For Women-From-Genesis presence:

```text
WOMEN_PRESENT_AT_GENESIS = PASS
ONLY IF
AT_LEAST_ONE_RECEIPT_BOUND_WOMAN_PARTICIPANT
+ GENESIS_STAGE_CONTRIBUTION_BOUND
+ TIMING_BEFORE_OR_DURING_ONTOLOGY_CREATION_BOUND
```

This proves presence only.

```text
PRESENCE != REPRESENTATIVENESS
PRESENCE != UNIVERSAL_CONSENT
PRESENCE != NO_EXCLUSION
```

### Step 7 — DISSENT / ALTERNATIVE BINDING

Bind material objections and alternatives independently of whether they were adopted.

```text
DISSENT_PRESERVED != DISSENT_ACCEPTED
NO_DISSENT_RECEIPT != NO_DISSENT_EXISTED
VOTE_RESULT != COMPLETE_OPINION_RECORD
```

If valid dissent records disagree, use `CONFLICT` rather than collapsing them.

### Step 8 — DECISION-PROVENANCE BINDING

For each material doctrine decision, bind:

```text
decision
owner / authorized decision-maker for repository process
inputs considered
alternatives considered
dissent considered
reason
first revision containing decision
receipt pointer
```

```text
GIT_AUTHOR != EPISTEMIC_ORIGINATOR_BY_DEFAULT
EDITOR != ORIGINATOR_BY_DEFAULT
UNKNOWN_AUTHOR != COLLECTIVE_AUTHORSHIP_PROVEN
```

### Step 9 — PARTICIPANT REVIEW

Where a record attributes a contribution to a person, give that participant a reasonable opportunity to review their own attributed entry before sealing when feasible and appropriate.

Participant review may produce:

```text
CONFIRMED
CORRECTED
DISPUTED
NO_RESPONSE
REVIEW_NOT_FEASIBLE
```

These are review outcomes, not consent substitutes.

```text
NO_RESPONSE != CONFIRMATION
LATER_REVIEW != ORIGIN_AUTHORSHIP
CURRENT_SUPPORT != GENESIS_PARTICIPATION
```

If participant review creates a material contradiction, candidate state becomes `CONFLICT` pending reconciliation.

### Step 10 — RECEIPT SEAL

A receipt seal freezes the bound record state and its limits; it does not create truth or authority.

Seal should preserve:

```text
candidate_id
source hash / immutable pointer
attribution basis
consent/privacy posture
timestamp basis
contribution scope
genesis relation
dissent/alternative state
decision provenance state
participant review outcome
final candidate state
limits
seal timestamp
```

```text
RECEIPT_SEAL != VERDICT
RECEIPT_SEAL != LEGAL_AUTHORITY
RECEIPT_SEAL != UNIVERSAL_TRUTH
```

### Step 11 — CHECKLIST RERUN

Only sealed candidate receipts may be used to rerun the Genesis-Safe Ontology Checklist.

The rerun must recompute rather than inherit:

```text
GENESIS_ORIGIN_QUESTIONS_BOUND
WOMEN_AT_GENESIS_BOUND
AUTHORSHIP_PROVENANCE_BOUND
DISSENT_PROVENANCE_BOUND
EVIDENCE_PROVENANCE_BOUND
DECISION_PROVENANCE_BOUND
CORRECTION_PROVENANCE_BOUND
```

Final doctrine disposition remains one of:

```text
GENESIS_SAFE
HOLD
FAIL_UPSTREAM_INCLUSION
FAIL_AGENCY
FAIL_DISSENT_PRESERVATION
FAIL_PROVENANCE
```

## 6. Non-retroactivity invariants — hard

```text
CURRENT_SUPPORT          != GENESIS_PARTICIPATION
LATER_REVIEW             != ORIGIN_AUTHORSHIP
RETROSPECTIVE_AGREEMENT  != PRIOR_CONSENT
MEMORY_ALONE             != TIMESTAMP_RECEIPT
```

Historical evidence remains historical.

A later endorsement, review, correction, or agreement may create a **new** receipt. It may not rewrite the genesis window or silently alter an older receipt.

```text
NEW_RECEIPT != OLD_RECEIPT_REWRITTEN
CORRECTION = APPEND / SUPERSEDE_WITH_TRACE
CORRECTION != DELETE_HISTORY
```

## 7. Privacy surface

Evidence of participation is required. Publication of gender, private communications, or unnecessary identity detail is not.

A consented identifier plus sufficiently bound contribution and timestamp is adequate where that combination satisfies the binding rules.

Privacy rules:

```text
MINIMIZE_IDENTITY_DISCLOSURE = TRUE
PRIVATE_COMMUNICATION_CONTENT = DO_NOT_PUBLISH_UNLESS_NECESSARY_AND_AUTHORIZED
GENDER_DISCLOSURE = OPTIONAL / RELEVANCE_AND_CONSENT_BOUND
CONSENTED_IDENTIFIER = PREFERRED_WHERE_FULL_IDENTITY_NOT_REQUIRED
PUBLIC_RECEIPT = MINIMUM_NECESSARY_PROVENANCE
PRIVATE_SOURCE_POINTER MAY_SUPPORT_PUBLIC_MINIMIZED_RECEIPT
```

Privacy minimization must not be misread as absence of provenance.

```text
MINIMIZED_PUBLIC_IDENTITY != UNATTRIBUTED
PRIVATE_SOURCE != INVALID_SOURCE
CONSENT_TO_REVIEW != CONSENT_TO_PUBLICATION
```

## 8. PR #24 application posture

At the creation of this plan, PR #24 remains evidence-gated.

```text
PR_24 = OPEN / DRAFT / UNMERGED
MERGE_READY = FALSE
MERGE_AUTHORIZED = FALSE
```

The prior head `e62a8b4d9007ab77a872f35b00abb1bc51dc8f6a` is the pre-intake-plan checkpoint. Adding this plan advances the draft branch but does not change the doctrine's epistemic disposition.

Required progression remains:

```text
HOLD
→ EVIDENCE_INTAKE
→ RECEIPT_BINDING
→ PARTICIPANT_REVIEW
→ RECEIPT_SEAL
→ CHECKLIST_RERUN
→ NEW_DISPOSITION
```

No movement out of draft and no merge may occur merely because this plan exists.

## 9. Closing invariant

```text
ARCHITECTURE_PHASE = CLOSED
EVIDENCE_PHASE = OPEN
INTAKE_PLAN_PRESENT != RECEIPTS_BOUND
RECEIPTS_BOUND != GENESIS_SAFE_BY_DEFAULT
GENESIS_SAFE_REQUIRES_CHECKLIST_RERUN
MERGEABLE != MERGE_READY
MERGE_READY != MERGE_AUTHORIZED
LEGAL_AUTHORITY_CREATED = FALSE
```

**Terminal:** `PARTICIPATION_EVIDENCE_INTAKE_PLAN_BOUND / RECEIPTS_NOT_YET_BOUND / PR24_HOLD`
