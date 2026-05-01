# Hash Bridge: SHA-256 ↔ Keccak-256

## Principle

Off-chain Merkle tree uses **SHA-256** (standard, auditable).
On-chain RMPAnchor uses **Keccak-256** (EVM native, gas-efficient).

Binding: both hashes are computed over **identical RFC 8785 JCS canonical bytes**.

## Flow

```
JSON record
  → JSON.parse()
  → JCS canonicalize (RFC 8785)
  → same canonical bytes
    ├── sha256() → Merkle leaf (off-chain tree)
    └── keccak256() → anchor leaf (on-chain RMPAnchor)
```

## Commands

```bash
./scripts/jcs-hash.sh receipt.json       # SHA-256 leaf
./scripts/keccak-leaf.sh receipt.json    # Keccak-256 leaf
./scripts/emit-dual-leaf.sh receipt.json # Both, as JSON
```

## Verification

Both hashes must differ but be co-derivable from the same canonical bytes.
