# Phase IV Vector II — Traversal Invariance

## Status

- Vector: `TRAVERSAL_INVARIANCE`
- Phase III frozen graph: `f41c931b2834ef6914fa8560d4996f0eaf451ec9`
- Phase IV Vector I canonical commit: `eed3395243aed02aab25739f92104286b0bb4eb4`
- Frozen reachable commits: `98`
- Maximum classification state: `L-2`
- Authority: `false`

## Invariant

Given one frozen commit graph and one evidence-role policy, changing only the traversal entry form must not change the resulting audit matrix or normalized observations.

| Entry | Form | Expected target |
|---|---|---|
| A | Annotated tag | `jqg50-phase3-evidence-role-v1.0.0` → `f41c931b…` |
| B | Exact commit SHA | `f41c931b2834ef6914fa8560d4996f0eaf451ec9` |
| C | Local branch ref created by the workflow | `refs/heads/jqg50/traversal-frozen` → `f41c931b…` |

## Acceptance

- all three entries resolve to the frozen graph head
- each entry audits exactly 98 commits
- all three CSV matrices are byte-identical
- all three matrix SHA-256 values are equal
- `GAP_CLASS_*` counts are present and equal
- `EVIDENCE_ROLE_*` counts are present and equal
- review-context counters and policy mode are equal
- every row remains capped at `L-2`
- no classifier source is modified
- no historical matrix is modified
- topology equivalence is not claimed
- authority is not promoted

## Boundary

This fixture proves traversal-entry invariance only for an identical frozen graph and the same current evidence-role policy. It does not establish semantic equivalence between different commit graphs, rewritten histories, rebases, cherry-picks, or squashed histories.
