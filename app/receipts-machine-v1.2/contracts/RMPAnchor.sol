// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library SimpleMerkleProof {
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        bytes32 computed = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 p = proof[i];
            computed = computed <= p
                ? keccak256(abi.encodePacked(computed, p))
                : keccak256(abi.encodePacked(p, computed));
        }
        return computed == root;
    }
}

contract RMPAnchor {
    using SimpleMerkleProof for bytes32[];

    struct AnchorState {
        bytes32 rmpRoot;
        bytes32 payloadCommitmentRoot;
        bytes32 payloadHash;
        string cid;
        uint256 epoch;
        uint256 blockNumber;
        uint256 lastHeartbeat;
    }

    address public watcher;
    address public owner;
    address public pendingWatcher;
    uint256 public watcherReplacementEta;

    uint256 public constant MAX_SILENCE = 26 hours;
    uint256 public constant WATCHER_TIMELOCK = 48 hours;

    AnchorState public latestState;

    event StateInitialized(
        bytes32 indexed rmpRoot,
        bytes32 indexed payloadCommitmentRoot,
        bytes32 indexed payloadHash,
        string cid,
        uint256 epoch,
        uint256 blockNumber
    );

    event StateAdvanced(
        bytes32 indexed previousRmpRoot,
        bytes32 indexed newRmpRoot,
        bytes32 indexed payloadCommitmentRoot,
        bytes32 payloadHash,
        string cid,
        uint256 epoch,
        uint256 blockNumber
    );

    event Heartbeat(
        uint256 indexed epoch,
        bytes32 indexed expectedRmpRoot,
        bytes32 indexed computedRmpRoot,
        string cid,
        bool verified,
        uint256 blockNumber
    );

    event StateDivergence(
        uint256 indexed epoch,
        bytes32 indexed expectedRmpRoot,
        bytes32 indexed computedRmpRoot,
        bytes32 payloadHash,
        string cid,
        string reason,
        uint256 blockNumber
    );

    event WatcherReplacementScheduled(
        address indexed oldWatcher,
        address indexed newWatcher,
        uint256 eta
    );

    event WatcherReplaced(
        address indexed oldWatcher,
        address indexed newWatcher
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier onlyWatcher() {
        require(msg.sender == watcher, "not watcher");
        _;
    }

    constructor(
        address _watcher,
        bytes32 _genesisRmpRoot,
        bytes32 _genesisPayloadCommitmentRoot,
        bytes32 _genesisPayloadHash,
        string memory _genesisCID,
        uint256 _genesisEpoch
    ) {
        require(_watcher != address(0), "watcher=0");
        require(_genesisRmpRoot != bytes32(0), "genesis rmp root=0");
        require(_genesisPayloadHash != bytes32(0), "genesis payload hash=0");

        owner = msg.sender;
        watcher = _watcher;

        latestState = AnchorState({
            rmpRoot: _genesisRmpRoot,
            payloadCommitmentRoot: _genesisPayloadCommitmentRoot,
            payloadHash: _genesisPayloadHash,
            cid: _genesisCID,
            epoch: _genesisEpoch,
            blockNumber: block.number,
            lastHeartbeat: block.timestamp
        });

        emit StateInitialized(
            _genesisRmpRoot,
            _genesisPayloadCommitmentRoot,
            _genesisPayloadHash,
            _genesisCID,
            _genesisEpoch,
            block.number
        );
    }

    function isWatcherAlive() public view returns (bool) {
        return block.timestamp <= latestState.lastHeartbeat + MAX_SILENCE;
    }

    function scheduleWatcherReplacement(address _newWatcher) external onlyOwner {
        require(_newWatcher != address(0), "new watcher=0");
        pendingWatcher = _newWatcher;
        watcherReplacementEta = block.timestamp + WATCHER_TIMELOCK;
        emit WatcherReplacementScheduled(watcher, _newWatcher, watcherReplacementEta);
    }

    function executeWatcherReplacement() external onlyOwner {
        require(pendingWatcher != address(0), "no pending watcher");
        require(block.timestamp >= watcherReplacementEta, "timelock active");
        address old = watcher;
        watcher = pendingWatcher;
        pendingWatcher = address(0);
        watcherReplacementEta = 0;
        emit WatcherReplaced(old, watcher);
    }

    function heartbeat(
        uint256 epoch,
        bytes32 computedRmpRoot,
        string calldata cid,
        bool verified
    ) external onlyWatcher {
        latestState.lastHeartbeat = block.timestamp;
        emit Heartbeat(
            epoch,
            latestState.rmpRoot,
            computedRmpRoot,
            cid,
            verified,
            block.number
        );
    }

    function reportDivergence(
        uint256 epoch,
        bytes32 computedRmpRoot,
        bytes32 payloadHash,
        string calldata cid,
        string calldata reason
    ) external onlyWatcher {
        latestState.lastHeartbeat = block.timestamp;
        emit StateDivergence(
            epoch,
            latestState.rmpRoot,
            computedRmpRoot,
            payloadHash,
            cid,
            reason,
            block.number
        );
    }

    function updateStateWithProof(
        bytes32 prevRmpRoot,
        bytes32 newRmpRoot,
        bytes32 payloadCommitmentRoot,
        bytes calldata payloadBytes,
        bytes32[] calldata merkleProof,
        string calldata cid,
        uint256 epoch
    ) external onlyWatcher {
        latestState.lastHeartbeat = block.timestamp;
        require(prevRmpRoot == latestState.rmpRoot, "continuity break");
        require(newRmpRoot != bytes32(0), "new rmp root=0");
        require(epoch > latestState.epoch, "epoch not increasing");

        bytes32 payloadHash = keccak256(payloadBytes);

        if (payloadCommitmentRoot != bytes32(0)) {
            require(
                merkleProof.verify(payloadCommitmentRoot, payloadHash),
                "invalid payload proof"
            );
        } else {
            require(merkleProof.length == 0, "proof must be empty");
            require(payloadHash != bytes32(0), "payload hash=0");
        }

        bytes32 prev = latestState.rmpRoot;

        latestState = AnchorState({
            rmpRoot: newRmpRoot,
            payloadCommitmentRoot: payloadCommitmentRoot,
            payloadHash: payloadHash,
            cid: cid,
            epoch: epoch,
            blockNumber: block.number,
            lastHeartbeat: block.timestamp
        });

        emit StateAdvanced(
            prev,
            newRmpRoot,
            payloadCommitmentRoot,
            payloadHash,
            cid,
            epoch,
            block.number
        );
    }

    function getAnchorState() external view returns (AnchorState memory) {
        return latestState;
    }
}
