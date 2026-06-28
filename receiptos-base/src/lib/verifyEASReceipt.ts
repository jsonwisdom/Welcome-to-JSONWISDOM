import type { ReceiptPacket } from "./verifyReceipt";

export type EASReceiptCheck = {
  uid_match: boolean;
  not_revoked: boolean;
  recipient_matches_observer: boolean;
};

export function verifyEASReceipt(
  receipt: ReceiptPacket,
  attestation: any
): EASReceiptCheck {
  return {
    uid_match:
      Boolean(receipt.eas_uid) &&
      attestation.uid?.toLowerCase() === receipt.eas_uid?.toLowerCase(),

    not_revoked:
      !attestation.revocationTime ||
      attestation.revocationTime === BigInt(0) ||
      attestation.revocationTime.toString() === "0",

    recipient_matches_observer:
      attestation.recipient?.toLowerCase() === receipt.observer.toLowerCase(),
  };
}
