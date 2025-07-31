#!/usr/bin/env bash
set -euo pipefail

# ─── Configurable variables ─────────────
RPC_URL=${LOCAL_L1_RPC_URL:-http://localhost:8545}
L2_RPC_URL=${LOCAL_L2_RPC_URL:-http://localhost:3050}
# Assumes using default Rich account PK ending in 4110
FROM=${FROM:- 0x36615Cf349d7F6344891B1e7CA7C72883F5dc049}
PRIVATE_KEY=${PRIVATE_KEY:-0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110}

# ─── Fetch the current bridgehub address ─────────────
echo "ℹ️  querying zks_getBridgehubContract from ${L2_RPC_URL}…"
BRIDGE_HUB=$(
  curl -sH "Content-Type: application/json" \
       -X POST --data '{
         "jsonrpc":"2.0","id":1,
         "method":"zks_getBridgehubContract","params":[]
       }' "${L2_RPC_URL}" \
  | jq -r '.result'
)
if [[ -z "$BRIDGE_HUB" || "$BRIDGE_HUB" == "null" ]]; then
  echo "❌ failed to fetch bridge-hub address – got '$BRIDGE_HUB'"
  exit 1
fi
echo "→ using bridge-hub at $BRIDGE_HUB"

CHAIN_ID=${CHAIN_ID:-270}

# 30 ETH on L1 → L2
DEPOSIT_WEI=${DEPOSIT_WEI:-30000000000000000000}

# L2 tx parameters
L2_VALUE=${L2_VALUE:-0}
L2_CALLDATA=${L2_CALLDATA:-0x00}
L2_GAS_LIMIT=${L2_GAS_LIMIT:-1000000}
PUBDATA_LIMIT=${PUBDATA_LIMIT:-800}

# Factory-deps – default to one dummy 32-byte blob
FACTORY_DEP=${FACTORY_DEP:-${PRIVATE_KEY}}
FACTORY_DEPS="[${FACTORY_DEP}]"

# L1 gas settings
GAS_LIMIT=${GAS_LIMIT:-10000000}
GAS_PRICE=${GAS_PRICE:-50000000}      # in wei
# ────────────────────────────────────────────────────────────────────

echo "→ Depositing $(bc -l <<<"scale=4; $DEPOSIT_WEI/1e18") ETH from $FROM to L2 (chain $CHAIN_ID)…"

# (chainId, mintValue, to, l2Value, l2Calldata, l2GasLimit, l2GasPerPubdata, factoryDeps, refundRecipient)
ARGS="($CHAIN_ID,$DEPOSIT_WEI,$FROM,$L2_VALUE,$L2_CALLDATA,$L2_GAS_LIMIT,$PUBDATA_LIMIT,$FACTORY_DEPS,$FROM)"

cast send \
  --rpc-url     "$RPC_URL" \
  --from        "$FROM" \
  --private-key "$PRIVATE_KEY" \
  "$BRIDGE_HUB" \
  'requestL2TransactionDirect((uint256,uint256,address,uint256,bytes,uint256,uint256,bytes[],address))' \
  "$ARGS" \
  --gas-limit "$GAS_LIMIT" \
  --gas-price "$GAS_PRICE" \
  --value     "$DEPOSIT_WEI"

echo ""
echo "✅ Tx submitted! You can check L2 balance with:"
echo "   cast balance ${FROM} --rpc-url ${L2_RPC_URL}"
