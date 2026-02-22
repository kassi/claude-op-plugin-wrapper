---
name: sync-op-plugins
description: Sync 1Password CLI plugins from plugins.sh
disable-model-invocation: true
allowed-tools: Read, Write, Bash(grep:*)
---

# Sync 1Password CLI Plugins

Read `~/.config/op/plugins.sh` and update the plugin's command list.

> **Note:** On first session start, this sync runs automatically. Use this skill manually after adding new 1Password CLI plugins.

## Steps

1. Read the file `~/.config/op/plugins.sh`
2. Extract command names from alias lines matching the pattern `alias <cmd>="op plugin run -- <cmd>"`
3. Update `${CLAUDE_PLUGIN_ROOT}/config/op-commands.json` with the extracted command list
4. Report what commands are now configured for automatic wrapping

## Example

If plugins.sh contains:
```bash
alias gh="op plugin run -- gh"
alias aws="op plugin run -- aws"
```

Then op-commands.json should be updated to:
```json
{
  "commands": ["gh", "aws"]
}
```

## Usage

Run `/sync-op-plugins` after adding new 1Password CLI plugins to refresh the list of commands that should be automatically wrapped with `op plugin run --`.
