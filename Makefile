# ── execution-spec-tests ───────────────────────────────────────────────
.PHONY: setup-exec-tests
setup-exec-tests:
	@echo "🔧 Setting up Ethereum execution-spec-tests..."
	@bash scripts/setup-exec-tests.sh

.PHONY: run-exec-tests
run-exec-tests: setup-exec-tests
	@echo
	@echo "🧪 Running execution-spec tests…"
	@bash scripts/run-exec-tests.sh

# ── rpc-tests ───────────────────────────────────────────────
.PHONY: setup-rpc-tests
setup-rpc-tests:
	@echo "🔧 Setting up Ethereum rpc-tests..."
	@bash scripts/setup-rpc-tests.sh

.PHONY: run-rpc-tests
run-rpc-tests: setup-rpc-tests
	@echo
	@echo "🧪 Running rpc tests…"
	@bash scripts/run-rpc-tests.sh
