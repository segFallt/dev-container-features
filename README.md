# Dev Container Features

A collection of reusable [dev container features](https://containers.dev/implementors/features/) for common development workflows.

| Feature | Description |
|---------|-------------|
| [Claude Code](#claude-code) | Claude Code CLI for AI-assisted development |
| [Documentation as Code](#documentation-as-code) | PlantUML + Mermaid diagram-as-code environment |

---

## Claude Code

Installs the [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI for AI-assisted development.

### Usage

```json
{
    "features": {
        "ghcr.io/segFallt/dev-container-features/claude-code:1": {}
    }
}
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Version of Claude Code to install (e.g., `latest` or a specific version) |
| `installDefaultPermissions` | boolean | `true` | Install default `.claude/settings.local.json` with common permissions (`cat`, `docker run`, `docker exec`, `find`) |
| `installSystemDeps` | boolean | `false` | Install networking/system tools (`iptables`, `ipset`, `iproute2`, `dnsutils`) |
| `nodeVersion` | string | `none` | Node.js version to install (e.g., `20`, `22`, `lts`). Set to `none` to skip. |

### Examples

#### Minimal

```json
{
    "features": {
        "ghcr.io/segFallt/dev-container-features/claude-code:1": {}
    }
}
```

This installs the latest Claude Code CLI and writes default permissions. Node.js must already be available in the base image or via another feature. To use `docker run`/`docker exec` permissions, add `ghcr.io/devcontainers/features/docker-in-docker:2` as a companion feature.

#### With Node.js

```json
{
    "features": {
        "ghcr.io/segFallt/dev-container-features/claude-code:1": {
            "nodeVersion": "22"
        }
    }
}
```

#### Pinned version, no default permissions

```json
{
    "features": {
        "ghcr.io/segFallt/dev-container-features/claude-code:1": {
            "version": "1.0.5",
            "installDefaultPermissions": false
        }
    }
}
```

#### With Docker-in-Docker

Add `docker-in-docker` as a companion feature to make `docker run`/`docker exec` permissions immediately usable:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/docker-in-docker:2": {},
        "ghcr.io/segFallt/dev-container-features/claude-code:1": {}
    }
}
```

### What's Installed

- **Claude Code CLI** (`claude`) - the AI-assisted development tool
- **VS Code extension** - `anthropic.claude-code` is recommended via `customizations`
- **Default permissions** (optional) - `.claude/settings.local.json` with safe defaults for `cat`, `docker run`, `docker exec`, and `find`
- **System tools** (optional) - `iptables`, `ipset`, `iproute2`, `dnsutils`
- **Node.js** (optional) - required runtime for Claude Code if not already present

---

## Documentation as Code

Installs PlantUML, Mermaid CLI, and supporting tools for diagram-as-code documentation workflows.

### Usage

```json
{
    "features": {
        "ghcr.io/segFallt/dev-container-features/documentation-as-code:1": {}
    }
}
```

Node.js and npm must be available (either from the base image, the `node` feature, or by setting `nodeVersion`).

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `plantumlVersion` | string | `1.2025.7` | PlantUML JAR version to install |
| `mermaidVersion` | string | `latest` | `@mermaid-js/mermaid-cli` version to install. Set to `none` to skip. |
| `nodeVersion` | string | `none` | Node.js version to install (e.g., `20`, `22`, `lts`). Set to `none` to skip. |

### Examples

#### With Node.js feature (recommended)

```json
{
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "22"
        },
        "ghcr.io/segFallt/dev-container-features/documentation-as-code:1": {}
    }
}
```

#### Self-contained (built-in Node.js)

```json
{
    "features": {
        "ghcr.io/segFallt/dev-container-features/documentation-as-code:1": {
            "nodeVersion": "22"
        }
    }
}
```

#### Pinned versions

```json
{
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "22"
        },
        "ghcr.io/segFallt/dev-container-features/documentation-as-code:1": {
            "plantumlVersion": "1.2025.7",
            "mermaidVersion": "11.4.1"
        }
    }
}
```

### What's Installed

- **Java 17** (OpenJDK) - runtime for PlantUML
- **Graphviz** - graph layout engine used by PlantUML
- **PlantUML JAR** at `/plantuml/plantuml.jar`
- **Mermaid CLI** (`mmdc`) - renders Mermaid diagrams from the command line
- **Puppeteer config** at `/plantuml/puppeteer-config.json` - headless Chrome flags for `mmdc`
- **Chromium dependencies** - system libraries required by Puppeteer's bundled Chromium
- **VS Code extensions** - PlantUML, Mermaid preview/editing, and Markdown support
- **Node.js** (optional) - if not already provided by another feature

### Rendering Diagrams

#### Mermaid

Use the Puppeteer config when rendering with `mmdc`:

```bash
mmdc -p /plantuml/puppeteer-config.json -i input.mmd -o output.svg
```

#### PlantUML

```bash
java -jar /plantuml/plantuml.jar -tsvg input.puml
```

---

## Publishing

Features are published to GHCR (GitHub Container Registry) automatically on push to `main`. Consumers reference features using semantic versioning:

- `ghcr.io/segFallt/dev-container-features/<feature>:1` - latest v1.x.x
- `ghcr.io/segFallt/dev-container-features/<feature>:1.0` - latest v1.0.x
- `ghcr.io/segFallt/dev-container-features/<feature>:1.0.0` - exact version

The version in each `src/<feature>/devcontainer-feature.json` determines the published tag. Bump it to release a new version.
