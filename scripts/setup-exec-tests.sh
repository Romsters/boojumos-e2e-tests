#!/usr/bin/env bash
set -euo pipefail
# ─── Initialize or update the submodules ───────────────
git submodule update --init --recursive
cd lib/execution-spec-tests
# ─── Install uv if not already installed ──────────────────────────────────
if ! command -v uv >/dev/null; then
  echo "📦 Installing uv via astral.sh..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.uv/bin:$PATH"
else
  echo "✔ uv already installed"
fi
# ─── Sync all extras for execution-spec-tests ─────────────────────────────
echo "🔄 Syncing tests and extras..."
uv sync --all-extras
# ─── Ensure correct solc version is available ────────────────────────────
echo "⚙️  Selecting solc 0.8.24 (install if missing)..."
uv run solc-select use 0.8.24 --always-install
# ─── Confirm that the test runner is available ───────────────────────────
echo "🔍 Verifying uv execute commands..."
uv run execute --help
uv run execute remote --help
echo "✅ execution-spec-tests environment is ready!"
