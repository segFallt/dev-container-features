#!/bin/bash
set -e

# Import test library (provided by devcontainers/action)
# shellcheck source=/dev/null
source dev-container-features-test-lib

check "java 17 is installed" bash -c "java -version 2>&1 | grep -q '17'"
check "graphviz dot is on PATH" bash -c "command -v dot"
check "plantuml.jar exists" bash -c "test -f /plantuml/plantuml.jar"
check "plantuml runs" bash -c "java -jar /plantuml/plantuml.jar -version"
check "node is on PATH" bash -c "command -v node"
check "npm is on PATH" bash -c "command -v npm"
check "mmdc is on PATH" bash -c "command -v mmdc"
check "mmdc --version works" bash -c "mmdc --version"
check "puppeteer config exists" bash -c "test -f /plantuml/puppeteer-config.json"
check "puppeteer config has no-sandbox" bash -c "grep -q 'no-sandbox' /plantuml/puppeteer-config.json"
check "include library _global/style dir exists" bash -c "test -d /plantuml/include-library/_global/style"

reportResults
