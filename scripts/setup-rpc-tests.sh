#!/usr/bin/env bash
set -euo pipefail
# ─── Initialize or update the submodules ───────────────
git submodule update --init --recursive
cd lib/rpc-tests
npm install;
cp .env.gobi .env;
echo "✅ rpc-tests environment is ready!"
