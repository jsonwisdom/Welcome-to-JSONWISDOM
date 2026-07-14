# Node 8 Root Directory Contract

## Status

- Node label: `NODE_8`
- Contract version: `v0.1.0`
- Repository: `jsonwisdom/Welcome-to-JSONWISDOM`
- Directory root: `node8/`
- Canonical parent candidate: `5cb05e1b0600340e9e5ee85af638b064323b73ba`
- Authority: `false`
- Maximum state: `L-2`
- Universal equivalence claimed: `false`
- Canonical binding: `pending`
- Tag binding: `pending`

## Jurisdiction

`node8/` is a repository-local namespace for proposed manifests, receipts, and replay material that bind explicitly to the Phase IV invariance work rooted at commit `5cb05e1b0600340e9e5ee85af638b064323b73ba`.

This contract does not create governmental, legal, financial, organizational, on-chain, or external operational authority. It does not bind xAI, Zora, Base, any token market, or any third party.

## Admission Order

Content may enter this namespace only in this order:

1. Directory contract.
2. Declared scope and evidence boundaries.
3. Replay material with observable identifiers.
4. Verification readback.
5. Canonical manifest or tag binding.

No later step may be inferred from an earlier one.

## Phase IV Boundary

Permitted Phase IV references must preserve these limits:

- `MAX_STATE = L-2`
- `AUTHORITY = FALSE`
- `UNIVERSAL_EQUIVALENCE = NOT_CLAIMED`
- fixture-scoped results remain fixture-scoped
- repository evidence does not independently establish external truth
- workflow success requires observed run status
- a tag is not canonical until its ref and target are read back

## Required Replay Fields

Every proposed canonical entry under `node8/` must identify:

- repository
- path
- source commit
- content digest
- relevant workflow run identifiers
- observed run conclusions
- limitations
- canonicalization status

Missing fields must remain explicitly marked `UNOBSERVED`, `UNPROVEN`, or `PENDING`.

## Current Root State

- Directory contract: `DECLARED`
- Phase IV manifest: `ABSENT`
- On-chain directory: `ABSENT`
- Transaction binding: `ABSENT`
- External namespace binding: `ABSENT`
- Canonical Node 8 status: `UNBOUND`

## Promotion Rule

Node 8 may be called canonical only after:

1. this contract is merged and read back;
2. a replay-complete Phase IV manifest is added under this directory;
3. referenced workflow runs are verified;
4. the proposed canonical tag is created and read back at the intended commit.

Until then, `Node 8` remains a repository-local proposed namespace with no external authority.
