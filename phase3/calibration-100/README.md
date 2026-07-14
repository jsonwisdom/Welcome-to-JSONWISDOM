# Phase III Up-to-100-Commit Calibration

This vector requests a corrected Phase III audit over up to 100 commits at the bound canonical head. When fewer than 100 commits are reachable, the run must audit the complete available history and record saturation rather than inventing rows.

## Binding

- Canonical source head: `5ea6039073ee5f1f5e8047a8f075da9d99a9d16a`
- Requested maximum: `100` commits
- Minimum accepted depth: `50` commits
- Classifier: canonical source-aware implementation
- Maximum reported state: `L-2`

## Acceptance conditions

- matrix header is present
- emitted rows equal `min(100, reachable commits at the bound head)`
- at least 50 rows are emitted
- every row reports `max_state=L-2`
- distribution totals equal the emitted row count
- `HISTORY_SATURATED=TRUE` is recorded when fewer than 100 commits are reachable
- no expected VOID, contradictory, partial, or clean count is hard-coded
- findings remain observations and do not create authority
- all prior 50-commit matrices and replay artifacts remain unchanged

## Additive outputs

- `JQG-50_PHASE_III_AUDIT_MATRIX_100.csv`
- `JQG-50_PHASE_III_AUDIT_100_LOG.txt`
- `JQG-50_PHASE_III_100_DISTRIBUTION.txt`
- `JQG-50_PHASE_III_100_RUNNER.sha256`

A green run proves bounded execution over the full reachable history up to 100 commits. It does not prove a literal 100-commit test when the repository has fewer than 100 reachable commits, universal classifier correctness, append-only enforcement, or external governance authority.
