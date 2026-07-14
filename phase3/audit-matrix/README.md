# JQG-50 Phase III Audit Matrix

This read-only observation instrument scans up to 50 local Git commits and emits `JQG-50_PHASE_III_AUDIT_MATRIX.csv` with:

- `commit`
- `max_state`
- `gap_class` (`void`, `contradictory`, `partial`, `clean`)
- `exit_reason`

## Safety boundary

- local Git history only
- no network imports
- no repository writes
- no automatic promotion above `L-2`
- findings are observations, not CI failures
- `clean` remains review-gated and conveys no authority

## Exit contract

- `0`: audit completed and CSV written
- `1`: parser or output failure
- `2`: Git traversal or environment failure

## Deterministic execution

```bash
go build -trimpath -ldflags='-s -w -buildid=' -o jqg50-history-audit ./phase3/audit-matrix/main.go
./jqg50-history-audit \
  --repo . \
  --ref HEAD \
  --max-count 50 \
  --output JQG-50_PHASE_III_AUDIT_MATRIX.csv
```
