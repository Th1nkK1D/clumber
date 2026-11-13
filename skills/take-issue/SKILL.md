---
name: take-issue
description: Take a GitHub issue end to end — check its card status, assign the user if it's workable, reproduce it if it's a bug, implement it, prove it works, tidy up, then wait for the user's go-ahead before committing. Use when the user gives an issue URL/number and asks to work on, take, pick up, or implement it.
---

# take-issue

Given a GitHub issue (URL or number, in this repo unless the URL says otherwise), claim it and implement it. Use `gh` for all GitHub access.

## 1. Check the card

`gh issue view <issue> --comments --json number,title,body,state,assignees,labels,projectItems,closedByPullRequestsReferences` (plus the linked repo/URL if given).

Read the whole issue: the body and every comment (later comments often change or narrow the scope), and open any attached images to see them.

It's workable only if all hold:
- Open.
- Unassigned, or already assigned to the user (`gh api user -q .login`).
- Card status isn't in progress / in review / done, and no blocked/wontfix/duplicate label.
- No open PR already linked to it.
- The body and comments describe the work clearly enough to implement without guessing the scope.

If any fail, stop and report which one and why (one line each). Don't assign, don't start. If only the last one fails, ask the specific question that would unblock it.

## 2. Assign

`gh issue edit <issue> --add-assignee @me`. Don't change the card's status column or post comments unless asked.

## 3. Implement

Do the work on the current branch, following the repo's rules (`AGENTS.md`/`CLAUDE.md`). Stay within the issue's scope; note anything adjacent you noticed instead of fixing it.

If the issue is a bug, run the `reproduce` skill first, before changing anything, and keep the steps it produces so the fix can be proved against them.

## 4. Prove, then tidy up

Run the `prove` skill first and fix what it surfaces until it passes (for a bug, that includes re-running the reproduce steps). If the issue includes images (screenshots, mockups, expected-vs-actual), also verify visually: run the app, capture the result, and compare it against those images. Then run `tidy-up` on the changes; if it removed tests or touched code (not just comments), re-run the checks once more.

## 5. Stop before committing

Don't commit or push. Report: the issue, what changed (a few lines), how it was proved, and anything left out or uncertain. Then wait for the user's confirmation to commit. When committing, the message references the issue as `(#<n>)` at the end of the subject, per GitHub convention (e.g. `Add dark mode toggle (#123)`), while still following the repo's other message conventions. Never use auto-closing keywords (`closes`/`fixes`) unless the user asks.
