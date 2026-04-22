# Receipts Machine v1.2

Status: DEPLOYED (SHADOW MODE)

Anchor: 0x18fA0E773955d48C9FB9C84916cB7A0ebDb17A4D
Root:   0x34c7bd2850e04053a0db6a5cf61b38101f801d4f045f03c9c05fd676c636fca4
CID:    bafybeif6hgbjq27u3clnevui32bs7cv6moikw2fqfhlylt5qoej33p5bke

## Run
chmod +x shadow_watcher.sh
./shadow_watcher.sh

## Verify Onchain
cast call 0x18fA0E773955d48C9FB9C84916cB7A0ebDb17A4D "getAnchorState()((bytes32,bytes32,bytes32,string,uint256,uint256,uint256))" --rpc-url https://mainnet.base.org

ENS is optional. GitHub + IPFS + Base = truth stack.
