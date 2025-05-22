# E2E tests for BoojumOS

## Structure
The repo provides scripts to run 2 sets of tests:
1) [execution-spec-tests](https://github.com/Romsters/execution-spec-tests)
2) [rpc-tests](https://github.com/Romsters/rpc-tests)
These test projects are installed as git submodules. Check out these projects directly for more info.

## Setting up and running the tests
- `make run-exec-tests` - to run the `execution-spec-tests`. By default it runs only mcopy tests on Cancun fork. This can be configured via env vars.
- `make run-rpc-tests` - to run the `rpc-tests`. Only eth_* tests are executed.
