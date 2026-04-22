#!/usr/bin/env python3
import json, hashlib, argparse, time

def compute(payload):
    prev = payload.get('prev_root','0x'+'0'*64)
    cur = bytes.fromhex(prev[2:]) if prev!='0x'+'0'*64 else b'\x00'*32
    for r in payload['records']:
        c = json.dumps(r,sort_keys=True,separators=(',',':')).encode()
        cur = hashlib.sha256(b'RMP1:'+cur+c).digest()
    return '0x'+cur.hex()

parser=argparse.ArgumentParser()
parser.add_argument('--prev-root',required=True)
parser.add_argument('--prev-payload',required=True)
parser.add_argument('--new-record',required=True)
parser.add_argument('--out',default='leaf_out.json')
args=parser.parse_args()

prev=json.load(open(args.prev_payload))
rec=json.loads(args.new_record)
payload={
  'prev_root':args.prev_root,
  'records':prev['records']+[rec],
  'metadata':{'version':'v1','epoch':int(time.time())}
}
root=compute(payload)
json.dump({'payload':payload,'root':root},open(args.out,'w'),indent=2)
print('root:',root)
