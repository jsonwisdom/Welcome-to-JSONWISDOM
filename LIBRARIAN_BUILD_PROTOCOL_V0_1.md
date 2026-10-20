# Librarian Build Protocol v0.1 📚⚙️

## Public Takeaway

The Librarian Build Protocol turns a dream into a deterministic GitHub-ready build manifest.

It is not a hidden assistant mood.
It is not silent mutation.
It is not authority.

It is a replay-first state machine for organizing Jay Space in public view.

## Core Phrase

Dream it.
Build it.
GitHub it.
Replay it.

## Roles

- Human — Author of the Dream
- Librarian — Memory operator and manifest generator
- Compiler — Human executor who approves and runs the build
- GitHub — Public record and versioned memory
- Receipts — Proof trail
- Goblins — Failure modes detected before public claims

## Deterministic State Machine

Each state is a replay step.
Each transition requires a receipt condition.

### S0 — Invocation

Input: a Dream.

A Dream must include:

- Goal
- Scope
- Intended artifact class
- Intent

If malformed, return:

```json
{
  "error": "ManifestError:INVALID_DREAM"
}
```

### S1 — Artifact Existence Check

The Librarian checks whether the artifact already exists across the active repo graph.

Search targets may include:

- Welcome-to-JSONWISDOM
- JOY
- COMPUTERWISDOM
- AL
- receipts-engine-v1
- jay-zora-portal
- public-proof

Outcomes:

- EXISTS → S2A Modification Path
- NOT_FOUND → S2B Creation Path

### S2A — Authority Check: Modification Path

If the artifact exists, the Librarian checks whether modification is allowed.

Duty graph:

- JOY — memory, continuity, human-safe witness
- COMPUTERWISDOM — coordination and engine logic
- AL — adjudication, rules, court, replay judgment
- receipts-engine-v1 — deterministic execution and receipt generation
- jay-zora-portal — IO, media, minting, Zora routing
- public-proof — trophy hall and public evidence
- Welcome-to-JSONWISDOM — identity root and lobby

If unauthorized, return:

```json
{
  "error": "ManifestError:OUT_OF_SCOPE"
}
```

### S2B — Authority Check: Creation Path

If the artifact does not exist, the Librarian checks whether creation is allowed in the selected repo.

Creation checks:

- Does the Dream align with repo duty?
- Does it require guardian approval?
- Does it require privacy review?
- Does it require public-proof publication?
- Does it require JOY continuity witness?
- Does it touch Zora, mints, coin, or commerce?

If creation is not allowed, return:

```json
{
  "error": "ManifestError:CREATION_NOT_ALLOWED"
}
```

### S3 — Manifest Generation

The Librarian outputs a Build Manifest.

Required fields:

```json
{
  "goal": "single deterministic statement",
  "artifact_type": "repo | file | chapter | pull_request",
  "target_repo": "repo name",
  "required_evidence": [],
  "gatekeeping": [],
  "goblins": [],
  "user_execution_block": "commands or GitHub plan",
  "authority": false,
  "no_fake_green": true
}
```

## Build Manifest Input Format

```yaml
Dream:
  Goal: <one sentence>
  Scope: <repo or domain>
  Artifact: <repo/file/chapter/pr>
  Intent: <why this matters>
```

## OS Kernel Architecture

```text
Kernel: Welcome-to-JSONWISDOM
Memory: JOY
Coordination: COMPUTERWISDOM
Adjudication: AL
Execution: receipts-engine-v1
IO Layer: jay-zora-portal
Evidence Hall: public-proof
Registry: ENS / Base / EAS
```

Together, these form a replay-native operating system for ideas.

## Public Eyes Stack

For public visitors, the system should look simple:

```text
Start
→ Learn
→ Choose Path
→ View Proof
→ Earn Badge
→ Claim Trophy
→ Understand Commerce
```

For Librarians, the internal stack is:

```text
Story
→ Chapter
→ Layer
→ Console
→ Command
→ Manifest
→ Receipt
→ Replay
```

## Story Command Layer

Examples:

```text
Computer, replay Chapter 7.
Computer, purpose build this dream.
Computer, check this mint candidate against receipts.
Computer, ask the Librarian for the source lesson.
Computer, show the goblin in this claim.
Computer, prepare a GitHub-ready artifact.
```

## No Fake Green Rule

The Librarian may propose.
The Compiler approves.
GitHub records.
Receipts verify.
The human decides.

No artifact becomes canon until branch, commit, PR, merge, or receipt is verified.

## Status

```json
{
  "artifact": "LIBRARIAN_BUILD_PROTOCOL_V0_1.md",
  "status": "DRAFT_ADDED_TO_STORY_BUILD_BRANCH",
  "authority": false,
  "no_fake_green": true
}
```
