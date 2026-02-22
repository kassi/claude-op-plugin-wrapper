#!/usr/bin/env bash
# SessionStart hook: create op-commands.json from ~/.config/op/plugins.sh on first use
# Fails-open — exits 0 on any error so the session is never blocked

config_file="${CLAUDE_PLUGIN_ROOT}/config/op-commands.json"

# Already initialized — nothing to do
if [[ -f "$config_file" ]]; then
    exit 0
fi

# Locate python3 via PATH
python3_bin=$(command -v python3 2>/dev/null)
if [[ -z "$python3_bin" ]]; then
    exit 0
fi

plugins_sh="$HOME/.config/op/plugins.sh"

# Write op-commands.json from plugins.sh (empty array if plugins.sh is absent)
PLUGINS_SH="$plugins_sh" CONFIG_FILE="$config_file" "$python3_bin" -c "
import json, os, re

plugins_sh = os.environ.get('PLUGINS_SH', '')
config_file = os.environ['CONFIG_FILE']

cmds = []
try:
    with open(plugins_sh) as f:
        content = f.read()
    cmds = re.findall(r'^alias (\w+)=\"op plugin run -- \1\"', content, re.MULTILINE)
except Exception:
    pass

os.makedirs(os.path.dirname(config_file), exist_ok=True)
with open(config_file, 'w') as f:
    json.dump({'commands': cmds}, f, indent=2)
    f.write('\n')
" 2>/dev/null || exit 0
