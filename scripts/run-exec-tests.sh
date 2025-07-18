#!/usr/bin/env bash
set -eo pipefail

set -x

cd lib/execution-spec-tests

# defaults — you can override by exporting before calling this script:
EXEC_TESTS_L2_RPC_URL=${L2_RPC_URL:-http://localhost:3053}
EXEC_TESTS_CHAIN_ID=${CHAIN_ID:-270}
EXEC_TESTS_PRIVATE_KEY=${PRIVATE_KEY:-0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110}
EXEC_TESTS_EXEC_TEST_PATH=${EXEC_TEST_PATH:-./tests/cancun/eip1153_tstore}

echo "▶ Running execution-spec-tests (Cancun fork) against ${EXEC_TESTS_L2_RPC_URL}"

uv run execute remote \
  --fork Cancun \
  --rpc-endpoint "${EXEC_TESTS_L2_RPC_URL}" \
  --rpc-chain-id "${EXEC_TESTS_CHAIN_ID}" \
  --rpc-seed-key${EXEC_TESTS_PRIVATE_KEY}" \
  --junitxml="junit-report.xml" \
  --json-report \
  -m "not slow" \
  -n auto \
  "${EXEC_TESTS_EXEC_TEST_PATH}"
