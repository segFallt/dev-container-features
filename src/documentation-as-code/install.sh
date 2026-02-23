#!/bin/bash
set -e

# Feature options (injected by dev container CLI)
PLANTUMLVERSION="${PLANTUMLVERSION:-1.2025.7}"
MERMAIDVERSION="${MERMAIDVERSION:-latest}"
NODEVERSION="${NODEVERSION:-none}"
INCLUDELIBRARYBRANCH="${INCLUDELIBRARYBRANCH:-main}"
INSTALLINCLUDELIBRARY="${INSTALLINCLUDELIBRARY:-true}"

echo "Installing Documentation as Code feature..."
echo "  PlantUML version: ${PLANTUMLVERSION}"
echo "  Mermaid CLI version: ${MERMAIDVERSION}"
echo "  Node.js version: ${NODEVERSION}"
echo "  Include library branch: ${INCLUDELIBRARYBRANCH}"
echo "  Install include library: ${INSTALLINCLUDELIBRARY}"

# ---------- Helper ----------
apt_get_update_if_needed() {
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ 2>/dev/null | wc -l)" = "0" ]; then
        apt-get update
    fi
}

# ---------- 1. System dependencies ----------
echo "Installing system dependencies (Java 17, Graphviz, Chromium/Puppeteer libs)..."
apt_get_update_if_needed

# Determine the correct appindicator package name (older vs newer Ubuntu/Debian)
APPINDICATOR_PKG="libappindicator3-1"
if ! apt-cache show libappindicator3-1 &>/dev/null; then
    APPINDICATOR_PKG="libayatana-appindicator3-1"
fi

apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    graphviz \
    curl \
    git \
    ca-certificates \
    fonts-liberation \
    "${APPINDICATOR_PKG}" \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    wget \
    xdg-utils

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

# ---------- 3. Clean up APT cache ----------
rm -rf /var/lib/apt/lists/*

# ---------- 4. Download PlantUML JAR ----------
echo "Downloading PlantUML ${PLANTUMLVERSION}..."
mkdir -p /plantuml
curl -SLo /plantuml/plantuml.jar \
    "https://github.com/plantuml/plantuml/releases/download/v${PLANTUMLVERSION}/plantuml-gplv2-${PLANTUMLVERSION}.jar"
chmod +x /plantuml/plantuml.jar

# ---------- 5. Write Puppeteer config ----------
echo "Writing Puppeteer config..."
cat > /plantuml/puppeteer-config.json <<'EOF'
{
    "args": [
        "--no-sandbox",
        "--disable-setuid-sandbox",
        "--disable-dev-shm-usage",
        "--disable-gpu"
    ]
}
EOF

# ---------- 6. Clone include library (if requested) ----------
if [ "${INSTALLINCLUDELIBRARY}" = "true" ]; then
    echo "Cloning PlantUML include library (branch: ${INCLUDELIBRARYBRANCH})..."
    git clone --depth 1 --branch "${INCLUDELIBRARYBRANCH}" \
        https://github.com/segFallt/plantUML-components.git \
        /plantuml/include-library
    rm -rf /plantuml/include-library/.git
fi

# ---------- 7. Set ownership ----------
chown -R "${_REMOTE_USER}:${_REMOTE_USER}" /plantuml

# ---------- 8. Install Mermaid CLI ----------
if [ "${MERMAIDVERSION}" = "none" ]; then
    echo "Skipping Mermaid CLI install (mermaidVersion=none)."
elif ! command -v npm &>/dev/null; then
    echo "WARNING: npm not found. Skipping Mermaid CLI install. Set nodeVersion or use the node feature to provide Node.js."
else
    echo "Installing @mermaid-js/mermaid-cli..."
    if [ "${MERMAIDVERSION}" = "latest" ]; then
        MERMAID_PKG="@mermaid-js/mermaid-cli"
    else
        MERMAID_PKG="@mermaid-js/mermaid-cli@${MERMAIDVERSION}"
    fi
    su - "${_REMOTE_USER}" -c "npm install -g ${MERMAID_PKG}"
fi

echo "Documentation as Code feature installation complete."
