# JQG-50 Phase III Audit Matrix

This tool performs a local, read-only scan of a Git revision range and emits:

`JQG-50_PHASE_III_AUDIT_MATRIX.csv`

Columns:

- `commit`
- `max_state`
- `gap_class` (`void`, `contradictory`, `partial`, `clean`)
- `exit_reason`

## Safety boundary

This is not production injection and does not disable the Phase II runner's `--synthetic-only` gate.

The tool:

- reads local Git objects only
- invokes local `git` commands with prompting disabled
- performs no network operations
- performs no repository writes
- never promotes any row above `L-2`
- treats `clean` as a marker classification requiring human review, not authority

## Deterministic command

```bash
go build -trimpath -ldflags='-s -w -buildid=' -o jqg50-history-audit ./phase3/audit-matrix
./jqg50-history-audit \
  --repo . \
  --range 'HEAD~50..HEAD' \
  --output JQG-50_PHASE_III_AUDIT_MATRIX.csv
```

## Classification notes

- `void`: explicit unverified content or SHA-256 of empty bytes
- `contradictory`: a newly observed root claim conflicts with a prior root claim in traversal order
- `clean`: explicit replay, GitHub verification, and test-execution markers are all true with no matching false markers
- `partial`: all other cases, including references without a complete receipt set

These are deterministic repository-text classifications, not independent findings about external truth.
