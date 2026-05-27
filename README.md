# Welcome to JSONWISDOM

> Identity root, orientation layer, and canonical doorway for Jay Wisdom / JSONWisdom.

**Status:** Identity Root Active  
**Operator:** Jason Wisdom / Jay Wisdom  
**Handle:** JSONWisdom  
**Primary role:** Public source-of-truth doorway for connected projects, receipts, missions, and proof surfaces.

---

## What This Is

This repository is the front door for JSONWisdom.

It does not replace the operational control plane, the courthouse, or the proof engine. It points to them clearly so humans and machines can understand where each responsibility lives.

Core rule:

```text
Welcome-to-JSONWISDOM orients.
COMPUTERWISDOM operates.
AL records and governs.
receipts-engine-v1 verifies and displays proof surfaces.
```

---

## Repository Tree of Duties

| Repository | Mission | Mechanical Role |
|---|---|---|
| `Welcome-to-JSONWISDOM` | Identity root and public doorway | Explains the system and links outward |
| `COMPUTERWISDOM` | Operational control plane | Missions, coordination, replay prep, signer boundaries |
| `AL` | Registry of Record / courthouse | Governance records, schemas, receipts, audit trails, org-grade evidence |
| `receipts-engine-v1` | Proof and verifier surface | Deterministic proof display, hashing, Merkle/ledger patterns, replay UI |
| `public-proof` | Public proof publication surface | Human-facing receipts and public attestations |
| `jay-zora-portal` | Zora media ingestion portal | Zora metadata/artifact acquisition before interpretation |

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
Replay decides seal
```

---

## Operating Doctrine

- Missions must be explicit.
- Receipts must be replayable.
- Claims must preserve evidence boundaries.
- Interpretation must not promote itself into proof.
- Organization-grade records belong in `AL`.
- Operational work belongs in `COMPUTERWISDOM`.
- Public verification belongs in `receipts-engine-v1` or `public-proof`.

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

The living story becomes safe only after mission inputs are structured and receipts are generated.
