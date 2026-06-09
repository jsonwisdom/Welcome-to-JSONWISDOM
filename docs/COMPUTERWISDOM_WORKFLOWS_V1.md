# COMPUTERWISDOM WORKFLOWS V1

**Date:** 2026-06-09  
**Status:** RECORDED  
**Authority:** COMPUTERWISDOM_CONTROL_PLANE  
**DocID:** CW-WORKFLOW-001

## Preamble

This document establishes the canonical execution chain for COMPUTERWISDOM operations.

No action is valid unless it traverses the lifecycle defined below or is explicitly marked as a failed, blocked, or draft operation.

## Execution Chain

Each operation must proceed through these five phases sequentially.

| Phase | Action | Purpose |
| :--- | :--- | :--- |
| **01. CHECK** | Diagnostic | Analyze inputs and environment; assert preconditions. |
| **02. TRIGGER** | Activation | Initiate operation; switch state from `IDLE` to `ACTIVE`. |
| **03. VERIFY** | Proof | Validate output against invariants; check receipts, references, or cryptographic checksums. |
| **04. RECORD** | Ledger | Anchor result to repository, chain, or audit log. |
| **05. PUBLISH** | Output | Signal completion; generate public-facing artifact when appropriate. |

## Operational Rules

1. **No Skip Rule:** Phases cannot be bypassed.
2. **Atomic Failure:** If any required phase fails, the workflow halts and emits `FAILED`, `BLOCKED`, or `ROLLBACK_REQUIRED`.
3. **Traceability:** Every completed execution must be traceable to a specific Commit SHA, Tx Hash, receipt, or recorded artifact.
4. **Boundary Preservation:** Drafts, observations, and claims may not promote themselves into verified outputs.
5. **Receipt Requirement:** `VERIFY` and `RECORD` must produce or reference a durable receipt before `PUBLISH` is allowed.

## Canonical Flow

```text
CHECK
  ↓
TRIGGER
  ↓
VERIFY
  ↓
RECORD
  ↓
PUBLISH
```

## Failure Flow

```text
CHECK/TRIGGER/VERIFY/RECORD/PUBLISH
  ↓
FAILURE_DETECTED
  ↓
HALT
  ↓
RECORD_FAILURE
  ↓
REPAIR_OR_ROLLBACK
```

## State Table

| State | Meaning |
|---|---|
| `IDLE` | No operation active. |
| `CHECKING` | Preconditions are being evaluated. |
| `ACTIVE` | Triggered operation is running. |
| `VERIFYING` | Outputs are being tested against invariants. |
| `RECORDED` | Result has been anchored to a durable record. |
| `PUBLISHED` | Public-facing output has been generated. |
| `BLOCKED` | Required input, authority, or dependency is missing. |
| `FAILED` | Operation completed incorrectly or invariant check failed. |
| `ROLLBACK_REQUIRED` | Prior state must be restored or corrected. |

## Constitutional State

| Metric | State |
|---|---|
| MANIFESTO | RECORDED |
| SKILLS_REGISTRY | RECORDED |
| WORKFLOWS_V1 | RECORDED |
| EXECUTION_PLANE | DEFINED |

## Boundary

This workflow specification defines execution architecture.

It does not itself execute deployments, verify contracts, create attestations, or publish external authority.
