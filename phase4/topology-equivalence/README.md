# Phase IV Vector III — Fixture-Scoped Topology Equivalence

## Status

- Vector: `TOPOLOGY_EQUIVALENCE`
- Canonical parent: `cfbfd678e1f93391455347fbef5560cd5da1e434`
- Shared fixture base: `JQG50_SHARED_FIXTURE_BASE_V1`
- Source binding: canonical Phase IV evidence-role policy
- Authority: `false`

## Invariant

Two physically different ephemeral commit graphs may be considered topology-equivalent only when their final deterministic semantic projections are identical under the same policy.

## Required divergence

- Graph A contains two fixture commits.
- Graph B contains one fixture commit.
- Commit sets differ.
- Parent-edge sets differ.
- Raw history matrices differ in row count and SHA-256.

## Required equivalence

- Final artifact paths and content digests match.
- Canonical evidence-role values match.
- Gap classes, exit reasons, policy mode, policy version, and maximum state match.
- Final tree digests match.
- Normalized state-projection SHA-256 values match.

## Projection boundary

The state projector removes graph-specific identity by never accepting commit SHAs, parent SHAs, timestamps, ref names, or traversal entries as projection fields. It strictly accepts only the declared semantic schema, rejects unknown fields, rejects duplicate normalized paths, sorts artifacts deterministically, and hashes canonical JSON bytes.

## Limitations

This fixture proves equivalence only for the two generated ephemeral histories and the declared state-projection schema. It does not prove universal equivalence across rebases, merges, cherry-picks, arbitrary repositories, or future policy versions. It does not mutate canonical history, modify the Phase III classifier, rewrite historical matrices, create downstream authority, or exceed `L-2`.
