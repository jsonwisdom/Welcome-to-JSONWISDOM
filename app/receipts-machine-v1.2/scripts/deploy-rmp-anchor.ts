import { ethers } from "hardhat";

async function main() {
  const watcher = process.env.INIT_WATCHER!;
  const genesisRmpRoot = process.env.GENESIS_RMP_ROOT!;
  const genesisPayloadCommitmentRoot =
    process.env.GENESIS_PAYLOAD_COMMITMENT_ROOT ||
    "0x0000000000000000000000000000000000000000000000000000000000000000";
  const genesisPayloadHash = process.env.GENESIS_PAYLOAD_HASH!;
  const genesisCID = process.env.GENESIS_CID!;
  const genesisEpoch = Number(process.env.GENESIS_EPOCH!);

  if (!watcher || !genesisRmpRoot || !genesisPayloadHash || !genesisCID || !genesisEpoch) {
    throw new Error("Missing required env vars");
  }

  const Factory = await ethers.getContractFactory("RMPAnchor");
  const contract = await Factory.deploy(
    watcher,
    genesisRmpRoot,
    genesisPayloadCommitmentRoot,
    genesisPayloadHash,
    genesisCID,
    genesisEpoch
  );

  await contract.waitForDeployment();
  const address = await contract.getAddress();

  console.log("RMPAnchor deployed:", address);
  console.log(
    JSON.stringify(
      {
        address,
        watcher,
        genesisRmpRoot,
        genesisPayloadCommitmentRoot,
        genesisPayloadHash,
        genesisCID,
        genesisEpoch,
        network: "Base"
      },
      null,
      2
    )
  );
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
