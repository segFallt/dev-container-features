
# Documentation as Code (documentation-as-code)

Installs PlantUML, Mermaid CLI, and supporting tools for diagram-as-code documentation workflows

## Example Usage

```json
"features": {
    "ghcr.io/segFallt/dev-container-features/documentation-as-code:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| plantumlVersion | PlantUML JAR version to install | string | 1.2025.7 |
| mermaidVersion | @mermaid-js/mermaid-cli version to install. Set to 'none' to skip. | string | latest |
| nodeVersion | Node.js version to install (e.g., '20', '22', 'lts'). Set to 'none' to skip. | string | none |

## Customizations

### VS Code Extensions

- `yzhang.markdown-all-in-one`
- `jebbs.plantuml`
- `d8aware.vscode-mermaid-extension`
- `vstirbu.vscode-mermaid-preview`
- `bierner.markdown-mermaid`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/segFallt/dev-container-features/blob/main/src/documentation-as-code/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
