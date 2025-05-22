#!/usr/bin/env bash
set -eo pipefail

cd lib/rpc-tests

# defaults — you can override by exporting before calling this script:
RPC_TESTS_EXEC_TEST_PATH=${EXEC_TEST_PATH:-rpc/eth}

echo "▶ Running rpc-tests against http://localhost:3050"

npm run test-gobi "${RPC_TESTS_EXEC_TEST_PATH}"
