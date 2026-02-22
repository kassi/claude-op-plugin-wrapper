---
name: op-cli-integration
description: Use when running CLI commands that have 1Password plugins (gh, aws, terraform, openai, glab). Reminds to use op plugin run wrapper.
user-invocable: false
---

# 1Password CLI Integration

When running CLI commands with 1Password plugins installed, use `op plugin run -- <cmd>` instead of the bare command to enable automatic credential injection.

## How It Works

This plugin automatically wraps configured CLI commands with `op plugin run --` via a PreToolUse hook. You don't need to remember to add the wrapper manually.

## Configured Commands

The following commands have 1Password plugins and are automatically wrapped:
- `gh` (GitHub CLI)
- `aws` (AWS CLI)
- `terraform`
- `openai`
- `glab` (GitLab CLI)

## Automatic Wrapping

When you run a command like:
```bash
gh pr list
```

The plugin automatically transforms it to:
```bash
op plugin run -- gh pr list
```

## Syncing Commands

If you add new 1Password CLI plugins, run `/sync-op-plugins` to update the list of commands that should be wrapped.

## Manual Usage

If automatic wrapping isn't working, you can manually use the wrapper:
```bash
op plugin run -- gh pr list
```
