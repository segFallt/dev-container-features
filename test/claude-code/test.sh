#!/bin/bash
set -e

# Import test library (provided by devcontainers/action)
# shellcheck source=/dev/null
source dev-container-features-test-lib

check "claude is installed" bash -c "command -v claude"
check "claude --version works" bash -c "claude --version"
check "permissions file exists" bash -c "test -f $HOME/.claude/settings.local.json"
check "docker is installed" bash -c "command -v docker"
check "docker daemon is running" bash -c "docker info"

reportResults
