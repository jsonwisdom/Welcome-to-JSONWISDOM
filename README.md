# Welcome to JSONWISDOM

> Identity root, orientation layer, and canonical doorway for Jay Wisdom / JSONWisdom.

**Status:** Identity Root Active  
**Narrator:** JSONWisdom index  
**Handle:** JSONWisdom  
**Primary role:** Public source-of-truth doorway for connected projects, receipts, missions, witness surfaces, and proof-oriented render layers.

---

## What This Is

This repository is the front door for JSONWisdom.

It does not replace the operational control plane, the courthouse, the replay rail, the witness layer, or the proof-display surface. It narrates how the connected repositories relate so humans and machines can understand where each responsibility lives.

---

## System Project Arcs — Context Recovery Protocol

JSONWisdom must recover context before creating new context.

A person is not a prompt. A project is not a single conversation. A repository is not the whole system. A timestamp is not optional metadata.

Before an agent, assistant, customer-service layer, app, SDK, or automation responds to ongoing work, recover state in this order:

```text
PERSON
  -> TIME
  -> SYSTEM_PROJECT_ARC
  -> LAST_CHECKPOINT
  -> VERIFIED_EVIDENCE
  -> OPEN_DECISION
  -> NEXT_ACTION
```

### Recovery rules

```text
PERSON != LAST_MESSAGE
MEMORY != PROOF
CONVERSATION != CANON
CHECKPOINT != RESET
NEW_SESSION != NEW_PROJECT
REPO_POINTER != COMPLETE_CONTEXT
TIMESTAMP != DISPOSABLE_METADATA
```

A **System Project Arc** is the durable continuity object for one line of work. It connects the human, the chronology, the repositories, the versions, the receipts, the decisions, and the next unresolved edge without forcing the person to restate the project from zero.

Minimum arc shape:

```json
{
  "person": "Jay Wisdom / JSONWisdom",
  "arc_id": "stable-project-arc-id",
  "time": {
    "started_at": null,
    "last_checkpoint_at": null,
    "observed_at": null
  },
  "substrates": [],
  "repositories": [],
  "versions": [],
  "checkpoints": [],
  "receipts": [],
  "verified_evidence": [],
  "open_decisions": [],
  "next_action": null,
  "authority_created": false
}
```

### Agent / customer-service behavior

For continuing work, the default question is not "what do you want to build?"

The default recovery sequence is:

```text
Who is the person?
What were they working on?
What changed most recently?
What timestamp anchors that change?
Which repository / substrate / version carries it?
What evidence is verified?
What remains unresolved?
How can I help from that checkpoint?
```

If the durable record is incomplete, say what is missing. Do not fill gaps with narrative confidence. Do not silently restart the project. Do not collapse multiple project arcs into one because they share vocabulary.

### Continuity rule

```text
RECOVER -> VERIFY -> CONTINUE
not
RESET -> INFER -> REBUILD
```

Conversation memory may help orientation, but durable continuity should be recoverable from versioned artifacts, repository history, receipts, timestamps, and explicit checkpoints.

This protocol is organizational guidance only. It creates no legal, governmental, financial, identity, surveillance, or external institutional authority.

---

Canonical architecture:

[`ARCHITECTURE.md`](./ARCHITECTURE.md)

The architecture file is the repository-architecture root for duty topology and cross-surface drift reconciliation. It creates no statutory, judicial, governmental, or other external legal authority.

Core rule:

```text
Welcome-to-JSONWISDOM narrates and orients.
COMPUTERWISDOM coordinates operational intelligence.
AL records, governs, and preserves registry / courthouse / receipt machinery.
receiptos-base produces replay frames and public-docket rails.
receipts-engine-v1 verifies and displays proof surfaces.
JOY witnesses continuity, family-safe memory, and human meaning.
Render layers present records; they do not create proof.
```

Replay rail and verifier surface are sequential, not interchangeable:

```text
receiptos-base → replay / frame / docket
receipts-engine-v1 → public verifier / proof display
```

---

## Repository Tree of Duties

| Repository | Mission | Mechanical Role |
|---|---|---|
| `Welcome-to-JSONWISDOM` | Identity root and public doorway | Narrates the system and links outward |
| `COMPUTERWISDOM` | Operational control plane | Missions, coordination, replay prep, signer boundaries |
| `AL` | Registry of Record / courthouse | Governance records, schemas, receipts, audit trails, org-grade evidence |
| `receiptos-base` | Replay / frame / public-docket rail | Produces replay frames and docket-ready receipt context |
| `receipts-engine-v1` | Public verifier / proof-display surface | Deterministic verification and proof display of replayable frames |
| `JOY` | Witness and continuity layer | Family-safe replay, meaning preservation, protected continuity boundaries |
| `public-proof` | Public proof publication surface | Human-facing receipts and public attestations |
| `jay-zora-portal` | Zora media ingestion portal | Zora metadata/artifact acquisition before interpretation |

No surface may recursively grant authority to another surface. Repository roles route work; they do not bootstrap legal authority.

---

## Narrator Boundary

The JSONWISDOM index speaks as a narrator, not as an operator.

```text
Narration may explain relationships.
Narration may point to repositories.
Narration may describe status labels.
Narration may not perform the work of another layer.
Narration may not promote a claim into proof.
```

Boundary:

```text
Index README != operator console
Index README != courthouse record
Index README != witness testimony
Index README != replay-engine output
Index README != verifier output
```

---

## Render Layer Notice

A render layer may be attached to `COMPUTERWISDOM`, `AL`, and `JOY` as a presentation surface for locked or clearly labeled records.

Allowed render posture:

```json
{
  "layer": "render",
  "truth_source": false,
  "authority": false,
  "rule": "receipts first, render second",
  "membrane": "HOLDS"
}
```

Render output may make records easier to read, share, export, or publish.

Render output must not silently promote:

```text
OBSERVATION -> CLAIM
CLAIM -> RECEIPT
RECEIPT -> VERIFIED_RECEIPT
UNKNOWN -> FACT
DISPUTED_RECORD -> RESOLVED_RECORD
```

Pretty output is not proof.

---

## Broadcast: Global Governance Role-Collapse Guard

The global governance role-collapse guard is recorded as evidence-only control-plane lineage.

```text
STATE: CONSTITUTIONALLY_CLOSED
MODE: EVIDENCE_ONLY
REQUIRES_FOR_ADJUDICATION: [REPLAY, AL_ADMISSION]
SEAL: 9bc1ac2025e111f6f30ab1f72611cf638fa4c5d5f95c7f8fbaa8de221d9327f2
```

Invariant:

```text
CURRENT_OFFICE_HOLDER != CANDIDATE != NOMINEE != SUCCESSOR_ELECT
```

Boundary:

```text
Evidence may mirror globally.
Authority may not.
```

This broadcast is an orientation notice only. It does not create final adjudication, state authority, or officeholder truth.

---

## Mission Registry

The mission registry is the structured map of Jay's projects.

Planned canonical file:

```text
MISSION_REGISTRY.json
```

Mirror target for organization-grade records:

```text
AL/registry/JSONWISDOM_ORG_MISSION_REGISTRY_V1.json
```

No mission becomes canonical merely because it is written here.

Promotion rule:

```text
Mission proposal -> structured mission file -> receipt -> AL registry mirror -> replay-verifiable record
```

---

## Authority Boundaries

```text
Identity page != proof
GitHub pointer != truth surface
Zora UI != verdict
ENS discovery != authority
EAS witness != global legitimacy
Render polish != verification
Replay success != legal finding
Verifier success != truth
```

No repository surface may recursively elevate another. Any claimed legal or institutional authority must come from an independently valid external standard appropriate to that claim.

---

## Operating Doctrine

- Missions must be explicit.
- Receipts must be replayable.
- Claims must preserve evidence boundaries.
- Interpretation must not promote itself into proof.
- Organization-grade records belong in `AL`.
- Operational work belongs in `COMPUTERWISDOM`.
- Replay/frame/docket work belongs in `receiptos-base`.
- Witness and continuity memory belongs in `JOY`.
- Public verification and proof display belongs in `receipts-engine-v1` or `public-proof`.
- Public presentation belongs in render layers only after state is labeled.
- Cross-surface topology drift must be reconciled against `ARCHITECTURE.md`.
- Continuing work must recover the correct System Project Arc before proposing new work.
- Time, version, substrate, checkpoint, and receipt metadata must not be discarded when recovering state.

---

## Current Next Build

Create structured mission files in:

```text
COMPUTERWISDOM/missions/
```

Then mirror accepted mission registry state into:

```text
AL/registry/
```

Then route replay/frame work through:

```text
receiptos-base/
```

Then verify and display replayable frames through:

```text
receipts-engine-v1/
```

Then narrate continuity and family-safe witness boundaries through:

```text
JOY/
```

The living story becomes safe only after mission inputs are structured, receipts are generated, replay state is preserved, verifier state is labeled, and rendered surfaces preserve the underlying evidence state.
