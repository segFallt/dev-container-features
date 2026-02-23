
# Claude Code (claude-code)

Installs the Claude Code CLI for AI-assisted development

## Example Usage

```json
"features": {
    "ghcr.io/segFallt/dev-container-features/claude-code:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version of Claude Code to install (e.g., 'latest' or a specific version) | string | latest |
| installDefaultPermissions | Install default .claude/settings.local.json with common permissions (cat, docker run, docker exec, find) | boolean | true |
| installSystemDeps | Install networking/system tools (iptables, ipset, iproute2, dnsutils) | boolean | false |
| nodeVersion | Node.js version to install (e.g., '20', '22', 'lts'). Set to 'none' to skip. | string | none |
| installDockerInDocker | Install Docker-in-Docker (ghcr.io/devcontainers/features/docker-in-docker:2) for container operations | boolean | true |

## Customizations

### VS Code Extensions

- `anthropic.claude-code`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/segFallt/dev-container-features/blob/main/src/claude-code/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
