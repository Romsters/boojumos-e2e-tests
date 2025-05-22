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
