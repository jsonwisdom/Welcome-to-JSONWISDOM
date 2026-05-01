#!/usr/bin/env bash
set -euo pipefail

TEST_FILE="tests/adversarial-whitespace.json"
HASH_SCRIPT="scripts/jcs-hash.sh"

pass=true

jq -c '.test_cases[]' "$TEST_FILE" | while read -r case; do
  id=$(echo "$case" | jq -r '.id')

  if echo "$case" | jq -e '.jcs_must_reject == true' > /dev/null; then
    input=$(echo "$case" | jq -r '.input')
    if echo "$input" | $HASH_SCRIPT > /dev/null 2>&1; then
      echo "FAIL $id — expected rejection"
      pass=false
    else
      echo "PASS $id"
    fi
    continue
  fi

  a=$(echo "$case" | jq -r '.input_a')
  b=$(echo "$case" | jq -r '.input_b')
  expect_equal=$(echo "$case" | jq -r '.same_under_jcs')

  hash_a=$(echo "$a" | $HASH_SCRIPT)
  hash_b=$(echo "$b" | $HASH_SCRIPT)

  if [ "$expect_equal" = "true" ]; then
    if [ "$hash_a" = "$hash_b" ]; then
      echo "PASS $id"
    else
      echo "FAIL $id — expected equal"
      pass=false
    fi
  else
    if [ "$hash_a" != "$hash_b" ]; then
      echo "PASS $id"
    else
      echo "FAIL $id — expected different"
      pass=false
    fi
  fi
done

if [ "$pass" = false ]; then
  exit 1
fi

exit 0
