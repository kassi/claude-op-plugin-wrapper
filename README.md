# Claude Code Plugins Marketplace

A collection of plugins for Claude Code that extend functionality with additional capabilities.

## Overview

This marketplace provides a curated set of plugins for Claude Code. Each plugin adds specific functionality and can be installed independently.

## Available Plugins

### 1. [op-plugin-wrapper](plugins/op-plugin-wrapper/)

Automatically wraps CLI commands with `op plugin run --` for 1Password credential injection in Claude Code.

**Features:**
- Automatic detection of 1Password CLI plugins
- Seamless command wrapping without manual intervention
- Support for multiple 1Password plugins (gh, aws, terraform, etc.)
- SessionStart and PreToolUse hooks for transparent integration

**Installation:**
```bash
claude plugin marketplace add kassi/personal-claude-plugins
claude plugin install op-plugin-wrapper@kassi-personal-claude-plugins
```

[View full documentation →](plugins/op-plugin-wrapper/README.md)

---

## Directory Structure

```
personal-claude-plugins/                 # Marketplace root
├── .claude-plugin/
│   └── marketplace.json                 # Marketplace catalog
├── README.md                            # This file
└── plugins/
    └── op-plugin-wrapper/               # Individual plugins
        ├── .claude-plugin/              # Plugin metadata
        ├── hooks/                       # Hook implementations
        ├── skills/                      # Claude Code skills
        ├── config/                      # Runtime configuration (gitignored)
        └── README.md                    # Plugin-specific documentation
```

## Adding New Plugins

To add a new plugin to this marketplace:

1. Create a new directory under `plugins/`
2. Structure it following the pattern of existing plugins
3. Add an entry to `.claude-plugin/marketplace.json` in the `plugins` array with:
   - `name`: Plugin identifier
   - `source`: Path to plugin (e.g., `"./plugins/new-plugin/`)
   - `description`: Brief description
   - `version`: Semantic version
   - `author`: Plugin author information
   - `license`: License type
   - Additional metadata as needed
4. Create a `README.md` in the plugin directory with documentation
5. Implement plugin functionality (hooks, skills, etc.)

## Installation

To install plugins from this marketplace:

```bash
# Add the marketplace
claude plugin marketplace add kassi/personal-claude-plugins

# Install a specific plugin
claude plugin install <plugin-name>@kassi-personal-claude-plugins
```

## License

Each plugin maintains its own license. See individual plugin directories for details.
