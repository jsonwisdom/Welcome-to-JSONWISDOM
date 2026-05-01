import canonicalize from 'canonicalize';
import { readFileSync } from 'fs';

const rawData = readFileSync(0, 'utf8');

let json;
try {
  json = JSON.parse(rawData);
} catch (err) {
  process.stderr.write(`JCS-CANONICALIZE-PARSE-ERROR: ${err.message}\n`);
  process.exit(1);
}

const canonical = canonicalize(json);

if (canonical === undefined) {
  process.stderr.write('JCS-CANONICALIZE-FAILURE: input contains non-serializable values\n');
  process.exit(1);
}

process.stdout.write(canonical);
