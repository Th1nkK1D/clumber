---
name: walkthrough-diff
description: Open a diff in codiff's walkthrough mode for the user to read — current uncommitted changes by default, or a branch/commit/milestone the user names. Use when the user asks to walk through, show, or open a diff/review in codiff, or to review a milestone's commit this way.
---

# walkthrough-diff

`codiff -w` is a GUI app and is for the *user* to read — a narrated walkthrough, not a tool for you to parse. Launch it in the background (or its own pane, per the user's environment rules, if one is available) so it doesn't block your turn, then hand control back; don't try to consume its output yourself, and don't wait on it synchronously.

## Summarize first

Before opening codiff, give the user a short summary of what you know about this change, pulled from whatever's cheaply at hand — don't go digging for it:
- What was asked: the instruction(s) that led to this diff, in your own words.
- The plan section, if one exists (`plan-milestones`): the milestone's goal and "Done when".
- Prior context already in hand: earlier `Notes` entries, a PR/commit description, anything already surfaced in this conversation.

Skip anything that isn't readily available — this is "what do I already know," not a research task.

## Scope

- **Default:** current uncommitted changes — `codiff -w`. Note: if the tree is clean, codiff falls back to walking through `HEAD` instead of showing nothing — if the user expected to see their own uncommitted work, check `git status` first.
- **Branch:** `codiff -w --branch <ref>` reviews the current branch against that target.
- **Commit:** `codiff -w --commit <ref>`.
- **Milestone(s):** if used alongside `plan-milestones`/`run-milestone`, "review milestone M<N>" means that milestone's commit. Take its hash from the plan's progress table, then `codiff -w --commit <that-hash>`. If the hash is no longer in history (`git cat-file -e <hash>` fails after an amend/rebase), find the commit in `git log` by matching its subject to the milestone, and fix the table.

## Iterating through milestones

If the user wants to go through milestones one by one (e.g. "walk me through each milestone"):

1. Resolve the next not-yet-reviewed milestone's commit (see Scope above), and open `codiff -w --commit <hash>`.
2. Wait for the user to finish reading and give feedback (or none).
3. If they raise something worth fixing:
   - Run `prove` on the fix before folding it in.
   - If it's still the tip commit: `git commit --amend`.
   - Otherwise, fold it in without rewriting every commit by hand: `git commit --fixup=<hash>`, then `GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash --autostash <hash>~1`. This rewrites the hash of that commit and every one after it, so afterwards update the progress table with the new hashes (`git log`). If the fix conflicts with a later milestone's changes to the same lines, stop the rebase and ask the user rather than resolving it yourself. If any of the commits being rewritten are already pushed, check `git status` for how far ahead/behind and confirm with the user before force-pushing.
   - Don't leave review fixes as a separate loose commit; the milestone's commit should reflect the reviewed, corrected state.
4. Move to the next milestone's commit and repeat until done or the user stops.
