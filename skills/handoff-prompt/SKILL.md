---
name: handoff-prompt
description: Write a copy-paste prompt that hands the current work off to a different agent (another tool, model, or fresh session) with all the context it needs. Use when the user wants to switch agents, move work elsewhere, or asks for a handoff prompt.
---

# handoff-prompt

Produce one self-contained prompt the user can paste into another agent so it continues the work without re-discovering anything. The receiving agent has zero memory of this session.

## Gather

Pull from the conversation and, where needed, the repo (`git status`, `git diff --stat`, `git log -5`). Don't ask the user for what you can look up.

## Prompt contents

Include only what the next agent can't cheaply get on its own:

- **Goal**: what the user is ultimately trying to achieve, in their terms.
- **State**: what's done, what's in progress, what's left. Name changed files by path.
- **Decisions**: choices made and why, plus approaches tried and rejected (so they aren't retried).
- **Constraints**: user preferences and project rules that apply (e.g. don't commit, no new deps, sandbox limits).
- **Gotchas**: failing tests, known bugs, commands that need special invocation, env quirks.
- **Next step**: the first concrete action the new agent should take.
- **Pointers**: key files, plan docs, or commands to run to get oriented. Point at them, don't paste their contents.

Leave out: narration of the session, anything derivable from reading the code, and secrets/credentials.

## Output

Write the prompt addressed to the next agent ("You are picking up..."), then:

1. Try to copy it to the clipboard by piping it on stdin (quoted heredoc, e.g. `wl-copy <<'EOF'`, so nothing gets expanded; no temp file) to the first tool that exists (`command -v` to check, in this order):
   - `wl-copy` (Wayland)
   - `xclip -selection clipboard`
   - `xsel --clipboard --input`
   - `kitten clipboard`
   - `termux-clipboard-set`
2. Always also print the prompt in a single fenced code block (use a `text` fence, and a longer outer fence if the prompt contains backticks), so the user can copy it by hand if no tool works or the clipboard isn't reachable (sandbox, SSH, no display).
3. End with one line saying whether it was copied (and with which tool) or not, plus a note if something material was uncertain or left out.
