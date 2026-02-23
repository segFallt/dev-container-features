#!/bin/bash
set -e

# Feature options (injected by dev container CLI)
VERSION="${VERSION:-latest}"
INSTALLDEFAULTPERMISSIONS="${INSTALLDEFAULTPERMISSIONS:-true}"
INSTALLSYSTEMDEPS="${INSTALLSYSTEMDEPS:-false}"
NODEVERSION="${NODEVERSION:-none}"
INSTALLDOCKERINDOCKER="${INSTALLDOCKERINDOCKER:-true}"

echo "Installing Claude Code feature..."
echo "  Version: ${VERSION}"
echo "  Install default permissions: ${INSTALLDEFAULTPERMISSIONS}"
echo "  Install system deps: ${INSTALLSYSTEMDEPS}"
echo "  Node.js version: ${NODEVERSION}"
echo "  Install Docker-in-Docker: ${INSTALLDOCKERINDOCKER}"

# ---------- Helper ----------
apt_get_update_if_needed() {
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ 2>/dev/null | wc -l)" = "0" ]; then
        apt-get update
    fi
}

# ---------- 1. Install curl (required) ----------
if ! command -v curl &>/dev/null; then
    echo "Installing curl..."
    apt_get_update_if_needed
    apt-get install -y --no-install-recommends curl
fi

# ---------- 2. Install Node.js (if requested) ----------
if [ "${NODEVERSION}" != "none" ]; then
    echo "Installing Node.js ${NODEVERSION}..."
    apt_get_update_if_needed
    apt-get install -y --no-install-recommends ca-certificates gnupg2
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
        | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

    NODE_MAJOR="${NODEVERSION}"
    if [ "${NODEVERSION}" = "lts" ]; then
        NODE_MAJOR="22"
    fi

    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
        > /etc/apt/sources.list.d/nodesource.list
    apt-get update
    apt-get install -y --no-install-recommends nodejs
fi

# ---------- 3. Install system dependencies (if requested) ----------
if [ "${INSTALLSYSTEMDEPS}" = "true" ]; then
    echo "Installing system dependencies..."
    apt_get_update_if_needed
    apt-get install -y --no-install-recommends \
        iptables \
        ipset \
        iproute2 \
        dnsutils
fi

# ---------- Clean up apt cache ----------
rm -rf /var/lib/apt/lists/*

# ---------- 4. Install Claude Code CLI ----------
echo "Installing Claude Code CLI..."
INSTALL_CMD="curl -fsSL https://claude.ai/install.sh | bash"
if [ "${VERSION}" != "latest" ]; then
    INSTALL_CMD="curl -fsSL https://claude.ai/install.sh | bash -s -- --version ${VERSION}"
fi

# The installer must run as the non-root remote user since it installs to $HOME
su - "${_REMOTE_USER}" -c "${INSTALL_CMD}"

# ---------- 5. Write default permissions file (if requested) ----------
if [ "${INSTALLDEFAULTPERMISSIONS}" = "true" ]; then
    echo "Writing default permissions to ${_REMOTE_USER_HOME}/.claude/settings.local.json..."
    CLAUDE_DIR="${_REMOTE_USER_HOME}/.claude"
    mkdir -p "${CLAUDE_DIR}"
    cat > "${CLAUDE_DIR}/settings.local.json" <<'PERMS'
{
  "permissions": {
    "allow": [
      "Bash(cat:*)",
      "Bash(docker run:*)",
      "Bash(docker exec:*)",
      "Bash(find:*)"
    ],
    "deny": [],
    "ask": []
  }
}
PERMS
    chown -R "${_REMOTE_USER}:${_REMOTE_USER}" "${CLAUDE_DIR}"
fi

echo "Claude Code feature installation complete."
