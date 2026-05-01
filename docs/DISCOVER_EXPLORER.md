# JSONWisdom Discover Explorer

## Purpose

This document is the navigation layer for the JSONWisdom / Jay's Wisdom / Computer Wisdom repository system.

It helps readers discover what each layer is, where the canonical proof lives, and what must not be confused with Anchor 001.

## Current System State

```json
{
  "anchor_001": "VALID_UNCHANGED",
  "canonical_source": "jsonwisdom/Welcome-to-JSONWISDOM",
  "audit_cascade": "PAUSED",
  "priority": "PGP_KEY_EXPOSURE_CONTAINMENT",
  "rule": "NO_GHOST_CLEANUP"
}
```

The audit cascade remains paused until the exposed PGP key incident is declared either:

```text
RESOLVED
UNRECOVERABLE_BUT_SEALED
```

## Canonical Anchor 001

| Field | Value |
|---|---|
| Canonical Repo | `jsonwisdom/Welcome-to-JSONWISDOM` |
| Anchor 001 Commit | `13004719dd0c34f765ca95dfe8566b6feb2bf6cf` |
| Merkle Root (SHA-256) | `ff55160908ff41d23f7af0df8873ef7a0dcf8163d1a308f58941e87b5a95bad9` |
| Leaf Keccak-256 | `0xb7e55f9e1f4f27cd96f38d74e6510e184a14772ef3f9f628d5acc68531dd185d` |
| EAS Schema UID | `0x3bab210b4da3faff084e146075caf9168efb5c9c87f18509bca2c07d7f2e49c` |
| EAS Attestation UID | `0x18b5b00c62c648df2ccf4a746645493fa2a0b0dcda6697052d8c3a3d1586c142` |
| ENS | `DEFERRED` |

## System Layers

| Layer | Role |
|---|---|
| Jay's Wisdom | Philosophy / operator layer |
| Computer Wisdom | Machine-verification / operations layer |
| ALMS | Receipt / ledger memory layer |
| Welcome-to-JSONWISDOM | Canonical Anchor 001 source |

## Repo Map

| Repo | Current Role |
|---|---|
| `jsonwisdom/Welcome-to-JSONWISDOM` | Canonical source of truth |
| `jsonwisdom/AL` | Operational legacy repo, aligned |
| `jsonwisdom/receipts-engine-v1` | Public verifier surface, aligned |
| `jsonwisdom/base-live` | Placeholder namespace for future Base deployments |
| `jsonwisdom/public-proof` | Independent coordinate proof storage |
| `jsonwisdom/ENS` | Placeholder identity namespace, ENS deferred |
| `jsonwisdom/RMT` | Reputation Merkle Tree prototype, independent |
| `jsonwisdom/prooflayer-repo` | ZTWS deployment scaffold |
| `jsonwisdom/COMPUTERWISDOM` | Operational control plane |
| `jsonwisdom/Server` | Archive-only server repo, extraction scan required |
| `jsonwisdom/mn-ago-entropy-ledger` | Accountability receipts dataset |
| `jsonwisdom/system-risk-detector` | Future monitor placeholder |

## Exploration Rules

1. Start with `docs/STATUS.md`.
2. Read `docs/REPO_REBOOT_2026-05-01.md` before interpreting the audit cascade.
3. Treat Anchor 001 as canonical only in this repo.
4. Treat all other repos as operational, historical, independent, placeholder, or scaffold unless a committed boundary doc says otherwise.
5. Do not infer ENS completion. ENS is deferred for Anchor 001.
6. Do not infer deployment completion from placeholder manifests.
7. Do not infer key revocation unless revocation evidence is committed.
8. Do not resume the audit cascade while the incident state is frozen.

## Safe Reader Path

For a new reader:

```text
README.md
→ docs/STATUS.md
→ docs/REPO_REBOOT_2026-05-01.md
→ docs/DISCOVER_EXPLORER.md
→ docs/ANCHOR_001_* artifacts
```

## Boundary Rule

Discovery is not authorization.

This explorer helps readers navigate the system, but it does not unfreeze the audit cascade, revoke keys, complete ENS, or create new anchors.

Rule: no ghost anchor, no ghost cleanup, no fake revocation.
