# ReceiptOS Base

Every claim gets a receipt. Every receipt can replay.

## Verify Kernel v0.1

Proof stack:

```text
Manual Verify = structure
IPFS Verify = replay source
EAS Decode Verify = public payload match
No decoded match = no authority
```

## Core Flow

```text
connect -> input CID/EAS/Tx -> fetch -> recompute -> decode EAS -> compare -> PASS/FAIL
```

## Doctrine

- IPFS proves replay source.
- EAS proves public timestamped attestation.
- ReceiptOS proves they match.
- Authority stays false unless the decoded receipt matches the replay packet.

## Files

- `src/lib/verifyReceipt.ts`
- `src/lib/fetchReceipt.ts`
- `src/lib/eas.ts`
- `src/lib/verifyEASReceipt.ts`
- `src/lib/decodeEASReceipt.ts`

## Base EAS

Base EAS contract:

```text
0x4200000000000000000000000000000000000021
```
