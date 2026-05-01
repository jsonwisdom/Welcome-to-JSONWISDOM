# Repo Reboot — 2026-05-01

## Status

This document resets the repo-audit state after the Anchor 001 alignment cascade and the discovery of exposed PGP private-key material in `jsonwisdom/Jasons-1st-repository`.

The system drifted from normal repo labeling into an operational security incident.

This reboot freezes the audit posture and restores a clean order of operations.

## Canonical Truth Source

`jsonwisdom/Welcome-to-JSONWISDOM` remains the canonical Anchor 001 source of truth.

| Field | Value |
|---|---|
| Canonical Repo | `jsonwisdom/Welcome-to-JSONWISDOM` |
| Anchor 001 Commit | `13004719dd0c34f765ca95dfe8566b6feb2bf6cf` |
| Merkle Root (SHA-256) | `ff55160908ff41d23f7af0df8873ef7a0dcf8163d1a308f58941e87b5a95bad9` |
| Leaf Keccak-256 | `0xb7e55f9e1f4f27cd96f38d74e6510e184a14772ef3f9f628d5acc68531dd185d` |
| EAS Schema UID | `0x3bab210b4da3faff084e146075caf9168efb5c9c87f18509bca2c07d7f2e49c` |
| EAS Attestation UID | `0x18b5b00c62c648df2ccf4a746645493fa2a0b0dcda6697052d8c3a3d1586c142` |
| ENS | `DEFERRED` |

## Completed Alignment Work

The following repos were audited and labeled or aligned to prevent ghost anchors:

| Repo | Result |
|---|---|
| `jsonwisdom/AL` | Legacy operational repo aligned; old Anchor #1 marked superseded |
| `jsonwisdom/receipts-engine-v1` | Verifier surface aligned; ENS Looking Glass marked optional/legacy |
| `jsonwisdom/base-live` | Placeholder namespace labeled; no live deployment claimed |
| `jsonwisdom/public-proof` | Coordinate proof storage labeled; independent from Anchor 001 |
| `jsonwisdom/ENS` | Placeholder namespace labeled; ENS deferred documented |
| `jsonwisdom/RMT` | Reputation Merkle Tree prototype bounded; demo key labeled test-only |
| `jsonwisdom/prooflayer-repo` | ZTWS deployment scaffold labeled; no live registry claimed |
| `jsonwisdom/COMPUTERWISDOM` | Operational control plane bounded; security boundary added |
| `jsonwisdom/Server` | Archive-only repo labeled; extraction scan required |
| `jsonwisdom/mn-ago-entropy-ledger` | Accountability dataset labeled; not randomness infrastructure |
| `jsonwisdom/system-risk-detector` | Placeholder monitor labeled; no active risk state claimed |

## Critical Incident

`jsonwisdom/Jasons-1st-repository` is a critical incident candidate.

Observed facts:

- Public repo
- Default branch named `Jasonsprivatekeyblock`
- Additional branch named `Key2`
- Local terminal confirmed `.asc` files containing `BEGIN PGP PRIVATE KEY BLOCK`

This is not a documentation drift issue.

This is exposed private-key material until proven otherwise.

## Immediate Priority Order

1. Stop repo-audit cascade.
2. Do not paste key material into chat or commits.
3. Identify the affected PGP key IDs and fingerprints using local GPG tooling only.
4. Revoke exposed keys if passphrases or revocation certificates are available.
5. If revocation is blocked, mark keys permanently compromised and never use them again.
6. Privatize or delete exposed branches/repo after the revocation decision is recorded.
7. Run cross-repo file-pattern scans for `.asc`, `.gpg`, `.pem`, `.key`, `.env`, `wallet`, `keystore`, `secret`.
8. Resume normal repo alignment only after key exposure is contained.

## Frozen Rule

No further repo alignment patches should be made until the exposed-key incident is resolved or formally marked as unrecoverable.

## Boundary Rule

Anchor 001 remains valid and separate.

The exposed PGP keys do not alter the GitHub + EAS Anchor 001 proof path unless those keys were used to sign Anchor 001 artifacts, which has not been established here.

Rule: no ghost anchor, no ghost cleanup, no fake revocation.
