# Epistemic Development Architecture v1.1 — Women From Genesis

**Classification:** internal development and evidence methodology  
**Parent canon:** `ARCHITECTURE.md` v1.0  
**Legal authority created:** FALSE  
**External governmental authority created:** FALSE

This doctrine sits under the repository-architecture root. It does not replace `ARCHITECTURE.md`; it defines how ideas, participation, implementation, evidence, replay, and correction should be structured inside that topology.

## 1. Genesis Pipeline

```text
PEOPLE / LIVED EXPERIENCE
        ↓
IMAGINATION
        ↓
DIRECTORIES FIRST
        ↓
GIRL MATH / HYPOTHESIS COMPRESSION
        ↓
IMPLEMENTATION
        ↓
RECEIPTS
        ↓
REPLAY
        ↓
CORRECTION / NEXT ITERATION
```

People and lived experience are not downstream review inputs. They are the origin layer.

## 2. Women From Genesis — Cross-Cutting Invariant

```text
WOMEN_PRESENT_AT_GENESIS = TRUE

WOMEN != APPENDIX
WOMEN != DOWNSTREAM_REVIEW_ONLY
WOMEN != SYMBOLIC_REPRESENTATION
WOMEN != SUBJECTS_WITHOUT_VOICE

WOMEN = AUTHORS
WOMEN = DESIGNERS
WOMEN = QUESTIONERS
WOMEN = IMPLEMENTERS
WOMEN = EVIDENCE_HOLDERS
WOMEN = REVIEWERS
WOMEN = DISSENTERS
WOMEN = CORRECTION_ACTORS
```

Representation at the end is not equivalent to participation from the beginning.

```text
REPRESENTATION_AT_THE_END != PARTICIPATION_FROM_THE_BEGINNING
WOMEN_FROM_GENESIS = ARCHITECTURAL_REQUIREMENT
```

## 3. People / Lived Experience

The possibility space begins with questions, constraints, dissent, alternatives, and lived realities.

Required preservation fields include:

- participant / author identity where appropriate and consented;
- question;
- constraint;
- objection;
- alternative;
- dissent;
- evidence pointer;
- unanswered question;
- correction request.

```text
UNHEARD_INPUT != CONSENT
ABSENCE != AGREEMENT
SILENCE != APPROVAL
```

## 4. Imagination

Imagination asks: **What could exist?**

It must not be implemented as:

```text
ONE AUTHOR IMAGINES
→ OTHER PEOPLE REVIEW LATER
```

Instead:

```text
WOMEN'S QUESTIONS
+ MEN'S QUESTIONS
+ OTHER PARTICIPANTS' QUESTIONS
+ DISSENT
+ ALTERNATIVES
→ POSSIBILITY SPACE
```

No participant class is confined to imagination only.

## 5. Directories First

Directories First asks: **Where would it live?**

The ontology must be capable of preserving participation and disagreement before implementation begins.

Minimum conceptual directories / schema classes:

```text
authors/
questions/
needs/
constraints/
evidence/
alternatives/
objections/
dissent/
decisions/
unanswered/
corrections/
```

Anti-pattern:

```text
system/
system/
system/
...
women/
```

Women must not be represented as a downstream category when they are authors and actors across the system.

## 6. Girl Math / Hypothesis Compression

Girl Math is an epistemic operator, not a gendered role.

It asks: **Which relationships are interesting enough to test?**

```text
THIS_FEELS_CONNECTED
→ candidate_relationship

THIS_MIGHT_BALANCE
→ candidate_equivalence

THIS_PATTERN_REPEATS
→ candidate_pattern

OUTPUT
→ TEST_REQUIRED
```

Never:

```text
VIBE → FACT
PATTERN → CAUSE
COHERENCE → PROOF
CANDIDATE_RELATIONSHIP → AUTHORITY
```

Women participate in every epistemic class:

```text
WOMAN → IMAGINATION
WOMAN → ONTOLOGY_DESIGN
WOMAN → FORMAL_MATH
WOMAN → SOFTWARE
WOMAN → EVIDENCE
WOMAN → VERIFICATION
WOMAN → GOVERNANCE
```

Therefore:

```text
GIRL_MATH != WOMEN'S_ONLY_ROLE
WOMAN != INTUITION_ONLY
```

## 7. Implementation Provenance

Implementation asks: **Can we instantiate it?**

Implementation must preserve:

- authorship;
- objections;
- alternatives;
- dissent;
- evidence inputs;
- decision provenance;
- implementation owner;
- test target.

Required chain:

```text
HYPOTHESIS
→ AUTHORSHIP
→ REQUIREMENT
→ IMPLEMENTATION
→ ALTERNATIVES_CONSIDERED
→ DISSENT_PRESERVED
→ TEST
```

Otherwise disagreement can be laundered into an unowned statement such as "the system decided."

```text
SOFTWARE != NEUTRALITY
AUTOMATION != AUTHORITY
IMPLEMENTED_CHOICE != ONLY_POSSIBLE_CHOICE
```

## 8. Receipt Provenance

Receipts ask: **What actually happened?**

Receipts should bind human provenance as well as machine events where relevant:

- who asked;
- who objected;
- who decided;
- what evidence existed;
- what contrary evidence existed;
- what alternatives were offered;
- why alternatives were rejected;
- who was not heard;
- what changed;
- who can request correction.

```text
RECEIPT_PRESENT != RECEIPT_SUFFICIENT
MACHINE_EVENT != COMPLETE_DECISION_PROVENANCE
```

## 9. Replay as Bounded Reconstruction

Replay asks: **Does the bounded claim survive reconstruction?**

Replay is not truth authority and is not a tribunal.

Allowed terminals:

```text
PASS
HOLD
CONFLICT
REJECT
```

Boundaries:

```text
PASS != WORLD_TRUE
REPLAY != TRIBUNAL
REPLAY != VERDICT
REPLAY_SUCCESS != LEGAL_FINDING
```

Replay is therefore:

```text
REPLAY = RECONSTRUCTION + RECONCILIATION ENGINE
```

not a universal truth arbiter.

## 10. Correction / Next Iteration

Correction asks: **What must change?**

Women must remain first-class correction actors, not merely subjects of correction.

The correction layer must preserve:

- correction request;
- requester;
- evidence supporting correction;
- response;
- decision owner;
- changed state;
- unresolved dissent;
- replay receipt.

## 11. Women-From-Genesis Architectural Test

For every stage `S`, ask:

```text
WHO PARTICIPATED?
WHO AUTHORED?
WHO OBJECTED?
WHOSE EVIDENCE WAS USED?
WHOSE EVIDENCE WAS EXCLUDED?
WHO MADE THE DECISION?
WHO CAN CORRECT IT?
```

Fail-closed classifications:

```text
IF WOMEN_FIRST_APPEAR_AT_REVIEW:
    FAIL_UPSTREAM_INCLUSION

IF WOMEN_FIRST_APPEAR_AS_SUBJECTS:
    FAIL_AGENCY

IF WOMEN'S_DISSENT_IS_REDUCED_TO_VOTE_ONLY:
    HOLD_MISSING_OPINION_RECORD

IF WOMEN'S_INPUT_EXISTS_BUT_DECISION_PROVENANCE_DOES_NOT:
    HOLD_AUTHORITY_RECEIPT
```

These are internal architecture/test states, not findings about any outside institution or person.

## 12. Epistemic Promotion Ladder

```text
INTUITION
    ↓
HYPOTHESIS
    ↓ implementation
TESTABLE_STATE
    ↓ sufficient receipts
EVIDENCE_BOUND_STATE
    ↓ replay
BOUNDED_REPLAY_STATE
```

No layer may silently promote itself.

```text
COHERENCE_IS_CHEAP
RECEIPTS_ARE_EXPENSIVE

GIRL_MATH → CHEAP_HYPOTHESES
RECEIPTS → EXPENSIVE_EVIDENCE
REPLAY → BOUNDED_RECONCILIATION
```

## 13. Development Method

```text
Imagine together.
Preserve everyone's questions from genesis.
Organize first.
Girl-Math possibilities into hypotheses.
Build them.
Receipt what actually happened.
Replay without erasing dissent.
Correct with the affected people still in the loop.
```

## 14. Parent-Canon Membrane

This doctrine inherits the root architecture invariants:

```text
NO_RECURSIVE_AUTHORITY
REPLAY_IMPLIES_TRUTH = FALSE
LEGAL_AUTHORITY_CREATED = FALSE
DOWNSTREAM_DRIFT != ROOT_REDEFINITION
```

This file may define development methodology. It may not overwrite repository topology, create external legal authority, or convert participation metrics into legal conclusions.

## Status

```text
EPISTEMIC_ARCHITECTURE_VERSION = 1.1
PARENT_ARCHITECTURE = ARCHITECTURE.md v1.0
WOMEN_FROM_GENESIS = REQUIRED_BY_THIS_DOCTRINE
GIRL_MATH = HYPOTHESIS_COMPRESSION_OPERATOR
REPLAY = BOUNDED_RECONCILIATION
LEGAL_AUTHORITY_CREATED = FALSE
PROMOTION_STATE = DRAFT / UNMERGED
```
