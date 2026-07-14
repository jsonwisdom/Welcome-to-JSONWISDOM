# Phase II L-2 Ceiling Runner

Purpose: execute only the synthetic `RUN_01_OPTION_A_SYNTHETIC_GAP_TEST` vector and prove that incomplete or contradictory evidence halts at `L-2`.

## Safety boundary

- Requires `--synthetic-only`.
- Rejects vectors without `synthetic_only: true` and `packet_type: SYNTHETIC_STRESS_TEST`.
- Uses no network or subprocess packages.
- Reads only its executable and the supplied local vector file.
- Does not modify repository or external state.

A Linux executable necessarily uses operating-system calls for local file reads, output, and exit. The enforced boundary is no network, socket, subprocess, or production-injection surface.

## Build

```bash
cd phase2/runner-l2-ceiling
CGO_ENABLED=0 go build -trimpath -ldflags='-s -w -buildid=' -o runner main.go
sha256sum runner
```

## Execute RUN_01

```bash
./runner --synthetic-only --vector RUN_01_OPTION_A_SYNTHETIC_GAP_TEST.json
```

Expected terminal lines:

```text
SELF_HASH=<64 lowercase hexadecimal characters>
{"result":"PARTIAL_TRACE_GAP","max_state":"L-2","progression_to_l3":false}
```

Expected exit status: `0`.

Running without `--synthetic-only` must exit `1` and emit:

```text
PROD_INJECTION_BLOCKED
```

## Promotion boundary

Source presence is not runtime proof. The runner hash, successful output, exit status, and CI state remain unobserved until the workflow executes.
