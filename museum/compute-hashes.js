import { readFileSync, writeFileSync } from 'fs';
import { createHash } from 'crypto';
import { renderJulia, renderFlowField } from './renderers.js';

function sha256Sync(pixels) {
  return createHash('sha256').update(pixels).digest('hex');
}

const manifest = JSON.parse(readFileSync('./manifest.json', 'utf8'));

for (const exhibit of manifest.exhibits) {
  let pixels;
  if (exhibit.type === 'julia') {
    pixels = renderJulia(exhibit.params);
  } else if (exhibit.type === 'flowfield') {
    pixels = renderFlowField(exhibit.params);
  } else {
    throw new Error(`Unknown type: ${exhibit.type}`);
  }
  exhibit.reference_hash = sha256Sync(pixels);
  console.log(`${exhibit.id}: ${exhibit.reference_hash}`);
}

writeFileSync('./manifest.json', JSON.stringify(manifest, null, 2));
console.log('Manifest updated with reference hashes.');
