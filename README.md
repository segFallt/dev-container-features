# Claude Code Dev Container Feature

A [dev container feature](https://containers.dev/implementors/features/) that installs the [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI for AI-assisted development.

## Usage

Add this feature to your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/segFallt/dev-container-features/claude-code:1": {}
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Version of Claude Code to install (e.g., `latest` or a specific version) |
| `installDefaultPermissions` | boolean | `true` | Install default `.claude/settings.local.json` with common permissions (`cat`, `docker run`, `docker exec`, `find`) |
| `installSystemDeps` | boolean | `false` | Install networking/system tools (`iptables`, `ipset`, `iproute2`, `dnsutils`) |
| `nodeVersion` | string | `none` | Node.js version to install (e.g., `20`, `22`, `lts`). Set to `none` to skip. |

## Examples

### Minimal

```json
{
    "features": {
        "ghcr.io/segFallt/dev-container-features/claude-code:1": {}
    }
}
```

This installs the latest Claude Code CLI and writes default permissions. Node.js must already be available in the base image or via another feature.

### With Node.js

```json
{
    "features": {
        "ghcr.io/segFallt/dev-container-features/claude-code:1": {
            "nodeVersion": "22"
        }
    }
}
```

### With system dependencies

```json
{
    "features": {
        "ghcr.io/segFallt/dev-container-features/claude-code:1": {
            "installSystemDeps": true
        }
    }
}
```

### Pinned version, no default permissions

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

## What's Installed

- **Claude Code CLI** (`claude`) - the AI-assisted development tool
- **VS Code extension** - `anthropic.claude-code` is recommended via `customizations`
- **Default permissions** (optional) - `.claude/settings.local.json` with safe defaults for `cat`, `docker run`, `docker exec`, and `find`
- **System tools** (optional) - `iptables`, `ipset`, `iproute2`, `dnsutils`
- **Node.js** (optional) - required runtime for Claude Code if not already present

## Publishing

This feature is published to GHCR (GitHub Container Registry) automatically on push to `main`. Consumers reference features using semantic versioning:

- `ghcr.io/segFallt/dev-container-features/claude-code:1` - latest v1.x.x
- `ghcr.io/segFallt/dev-container-features/claude-code:1.0` - latest v1.0.x
- `ghcr.io/segFallt/dev-container-features/claude-code:1.0.0` - exact version

The version in `src/claude-code/devcontainer-feature.json` determines the published tag. Bump it to release a new version.
