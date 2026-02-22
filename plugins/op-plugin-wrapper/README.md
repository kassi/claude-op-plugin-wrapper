# Claude Code 1Password Plugin Wrapper

Automatically wraps CLI commands with `op plugin run --` for 1Password credential injection in Claude Code.

## What It Does

When you have 1Password CLI plugins configured (like `gh`, `aws`, `terraform`), this plugin automatically wraps those commands with `op plugin run --` so credentials are injected without manual intervention.

**Before:** Claude runs `gh pr list`
**After:** Claude runs `op plugin run -- gh pr list`

## Installation

```bash
claude plugin marketplace add kassi/claude-plugins
claude plugin install op-plugin-wrapper@kassi-claude-plugins
```

No further configuration is needed. On first session start, the plugin automatically reads your `~/.config/op/plugins.sh` and creates `config/op-commands.json` with your installed 1Password plugins.

## Configuration

### Automatic Setup

On first session start, the plugin detects your 1Password plugins automatically from `~/.config/op/plugins.sh`. You don't need to do anything.

### Adding New Plugins

After adding a new 1Password CLI plugin, refresh the command list:

```
/sync-op-plugins
```

This reads `~/.config/op/plugins.sh` and updates `config/op-commands.json`.

## How It Works

1. **SessionStart Hook:** On session start, if `config/op-commands.json` doesn't exist, it is created automatically from `~/.config/op/plugins.sh`
2. **PreToolUse Hook:** Before any Bash command runs, the hook checks if the command starts with a configured CLI tool
3. **Automatic Wrapping:** If matched, the command is wrapped with `op plugin run --`
4. **Pass-through:** Commands already wrapped, not in the list, or containing shell metacharacters pass through unchanged

## Requirements

- [1Password CLI](https://developer.1password.com/docs/cli/) (`op`)
- 1Password CLI plugins configured in `~/.config/op/plugins.sh`
- Claude Code with plugin support

## File Structure

```
op-plugin-wrapper/
├── .claude-plugin/
│   └── plugin.json             # Plugin metadata
├── hooks/
│   ├── hooks.json              # Hook configuration
│   ├── session-start.sh        # SessionStart hook: auto-creates op-commands.json
│   └── wrap-op-commands.sh     # PreToolUse hook: wraps commands
├── skills/
│   ├── op-cli-integration/
│   │   └── SKILL.md            # Skill documentation
│   └── sync-op-plugins/
│       └── SKILL.md            # /sync-op-plugins command
├── config/                     # Gitignored — generated at runtime
└── README.md
```

## Troubleshooting

### Commands not being wrapped

1. Check that the command is in `config/op-commands.json` (auto-created on first session start)
2. Run `/sync-op-plugins` to re-sync from your 1Password config
3. Start a new Claude Code session

### config/op-commands.json not created

If the file wasn't created on session start, check that `~/.config/op/plugins.sh` exists and contains alias lines in the format:

```bash
alias gh="op plugin run -- gh"
```

Then run `/sync-op-plugins` to create it manually.

### Debug mode

Run Claude Code with debug logging to see hook execution:

```bash
claude --debug
```

## License

MIT
