import { SchemaEncoder } from "@ethereum-attestation-service/eas-sdk";
import type { ReceiptPacket } from "./verifyReceipt";

export const RECEIPT_SCHEMA =
  "string receipt_id,address observer,string basename,string cid,string state_root,string git_commit,string tx_hash,string created_at,bool authority";

export function decodeEASReceiptData(data: `0x${string}`) {
  const encoder = new SchemaEncoder(RECEIPT_SCHEMA);
  const decoded = encoder.decodeData(data);

  return Object.fromEntries(
    decoded.map((field: any) => [field.name, field.value.value])
  );
}

export function verifyDecodedEASReceipt(
  receipt: ReceiptPacket,
  decoded: Record<string, any>
) {
  return {
    receipt_id_matches: decoded.receipt_id === receipt.receipt_id,
    observer_matches:
      decoded.observer?.toLowerCase() === receipt.observer.toLowerCase(),
    basename_matches: decoded.basename === receipt.basename,
    cid_matches: decoded.cid === receipt.cid,
    state_root_matches: decoded.state_root === receipt.state_root,
    git_commit_matches: decoded.git_commit === receipt.git_commit,
    tx_hash_matches: (decoded.tx_hash ?? "") === (receipt.tx_hash ?? ""),
    created_at_matches: decoded.created_at === receipt.created_at,
    authority_false: decoded.authority === false,
  };
}
