#!/usr/bin/env bash
set -eo pipefail

cd lib/rpc-tests

# defaults — you can override by exporting before calling this script:
EXEC_TESTS_EXEC_TEST_PATH=${EXEC_TEST_PATH:-./tests/cancun/eip5656_mcopy/test_mcopy.py}

echo "▶ Running rpc-tests against http://localhost:3050"

npm run test-gobi rpc/eth
