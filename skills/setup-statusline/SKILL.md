---
name: setup-statusline
description: Install clumber's status line (model, context, 5h/7d rate limits, cost) into the user's Claude Code settings. Use when the user asks to set up, install, enable, or update the clumber status line.
---

# setup-statusline

Plugins can't enable a status line on install, so this copies the script to a stable path and points the user's settings at it. Run once per machine; re-run to pick up plugin updates.

## Steps

1. Check `command -v jq`. If missing, tell the user to install it and stop; the script needs it.
2. Read `~/.claude/settings.json`. If it already has a `statusLine` pointing somewhere other than `~/.claude/statusline.sh`, show it and ask before replacing it.
3. If `~/.claude/statusline.sh` exists and differs from the bundled script, ask before overwriting.
4. Copy `${CLAUDE_SKILL_DIR}/statusline.sh` to `~/.claude/statusline.sh` and `chmod +x` it.
5. Set this in `~/.claude/settings.json` with the Edit tool, keeping every other key:

   ```json
   "statusLine": { "type": "command", "command": "~/.claude/statusline.sh" }
   ```

6. Tell the user it appears on the next prompt or session start, and that it persists until they remove it.
