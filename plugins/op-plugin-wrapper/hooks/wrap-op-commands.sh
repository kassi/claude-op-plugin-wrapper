#!/usr/bin/env bash
# PreToolUse hook to wrap CLI commands with 'op plugin run --'
# Reads JSON from stdin, checks if command needs wrapping, outputs modified command if needed
# Fails-open: exits 0 on any error so Bash tool calls are never blocked by this hook

# Locate python3 via PATH (not hardcoded to /usr/bin/python3 which may not exist)
python3_bin=$(command -v python3 2>/dev/null)
if [[ -z "$python3_bin" ]]; then
    exit 0
fi

# Read JSON input from stdin
input=$(cat)

# Extract the command from tool_input.command (fail-open if parsing fails)
command=$(printf '%s' "$input" | "$python3_bin" -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_input', {}).get('command', ''))
except Exception:
    pass
" 2>/dev/null) || exit 0

# If no command found, pass through
if [[ -z "$command" ]]; then
    exit 0
fi

# Skip wrapping for compound shell commands — metacharacters would change semantics
# (pipes, redirects, separators, command substitution, subshells)
if echo "$command" | grep -qE '[|&;<>`()]|\$\('; then
    exit 0
fi

# Check if already wrapped with 'op plugin run --' (handles leading whitespace)
if [[ "$command" =~ ^[[:space:]]*op[[:space:]]+plugin[[:space:]]+run[[:space:]]+-- ]]; then
    exit 0
fi

# Check if 'op' is available; skip wrapping if not installed
if ! command -v op >/dev/null 2>&1; then
    exit 0
fi

# Get the config file path
config_file="${CLAUDE_PLUGIN_ROOT}/config/op-commands.json"

# If config file doesn't exist, pass through
if [[ ! -f "$config_file" ]]; then
    exit 0
fi

# Read the list of commands to wrap
# Config path is passed via env var to avoid injecting it into Python source code
op_commands=$(CONFIG_FILE="$config_file" "$python3_bin" -c "
import json, os
try:
    with open(os.environ['CONFIG_FILE']) as f:
        cmds = json.load(f).get('commands', [])
    print(' '.join(cmds))
except Exception:
    pass
" 2>/dev/null) || exit 0

# If no commands configured, pass through
if [[ -z "$op_commands" ]]; then
    exit 0
fi

# Extract the first effective command word, skipping leading KEY=VALUE env assignments
first_word=$(echo "$command" | awk '{
    for (i = 1; i <= NF; i++) {
        if ($i !~ /^[A-Za-z_][A-Za-z0-9_]*=/) { print $i; exit }
    }
}')

# Check if the first word matches any configured op plugin command
needs_wrap=false
for op_cmd in $op_commands; do
    if [[ "$first_word" == "$op_cmd" ]]; then
        needs_wrap=true
        break
    fi
done

# If needs wrapping, output the modified command
if [[ "$needs_wrap" == "true" ]]; then
    wrapped_command="op plugin run -- $command"
    # Use environment variable to safely pass command with special characters
    WRAPPED_CMD="$wrapped_command" "$python3_bin" -c "
import json, os
print(json.dumps({'updatedInput': {'command': os.environ['WRAPPED_CMD']}}))
" 2>/dev/null || exit 0
fi
