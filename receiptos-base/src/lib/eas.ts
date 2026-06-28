import { EAS } from "@ethereum-attestation-service/eas-sdk";

export const BASE_EAS_ADDRESS = "0x4200000000000000000000000000000000000021";

export async function fetchEASAttestation(uid: string, provider: any) {
  const eas = new EAS(BASE_EAS_ADDRESS);
  eas.connect(provider);

  return await eas.getAttestation(uid);
}
