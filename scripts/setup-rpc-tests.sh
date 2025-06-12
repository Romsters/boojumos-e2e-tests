#!/usr/bin/env bash
set -euo pipefail
# ─── Initialize or update the submodules ───────────────
git submodule update --init --recursive
cd lib/rpc-tests
npm install;

# Load environment variables from .env file
if [ -f .env.gobi ]; then
  export $(grep -v '^#' .env.gobi | xargs)
else
  echo ".env.gobi file not found!"
  exit 1
fi

# Check if RPC_URL is set
if [ -z "$RPC_URL" ]; then
  echo "RPC_URL is not set in the .env.gobi file"
  exit 1
fi

# Make the JSON-RPC request to get the latest block
response=$(curl -s -X POST --data '{
  "jsonrpc":"2.0",
  "method":"eth_getBlockByNumber",
  "params":["latest", true],
  "id":1
}' -H "Content-Type: application/json" "$RPC_URL")

# Extract the block hash using jq
block_hash=$(echo "$response" | jq -r '.result.hash')
# Check if jq successfully retrieved the hash
if [ "$block_hash" == "null" ] || [ -z "$block_hash" ]; then
  echo "Failed to retrieve block hash."
  exit 1
fi
echo "Latest block hash: $block_hash"

first_tx_hash=$(echo "$response" | jq -r '.result.transactions[0].hash // empty')
# Validate transaction presence
if [ -z "$first_tx_hash" ]; then
  echo "No transactions found in the latest block. Aborting."
  exit 1
fi
echo "First transaction hash from latest block: $first_tx_hash"

# Update or add the BLOCK_HASH variable in the .env.gobi file
if grep -q "^BLOCK_HASH=" .env.gobi; then
  # Replace existing line
  sed -i.bak "s|^BLOCK_HASH=.*|BLOCK_HASH=$block_hash|" .env.gobi && rm .env.gobi.bak
else
  # Append new line
  echo "BLOCK_HASH=$block_hash" >> .env.gobi
fi

# Update or add the TX_HASH variable in the .env.gobi file
if grep -q "^TX_HASH=" .env.gobi; then
  # Replace existing line
  sed -i.bak '' "s|^TX_HASH=.*|TX_HASH=$first_tx_hash|" && rm .env.gobi.bak
else
  # Append new line
  echo "TX_HASH=$first_tx_hash" >> .env.gobi
fi

echo "✅ rpc-tests environment is ready!"
