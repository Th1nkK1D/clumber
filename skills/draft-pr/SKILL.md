---
name: draft-pr
description: Prepare a pull request for the user to review and post — read the target project's contribution rules, fill what's missing, push the branch (to a fork if needed), then draft the PR title/body and a link to open it. Never creates the PR. Use when the user asks to prepare, draft, or open a PR, or to contribute a change upstream.
---

# draft-pr

Get the current branch ready to become a PR and hand the user a draft plus a link. **Never run `gh pr create` or post anything** — the user reviews and submits it themselves. Use `gh` for all GitHub access.

## 1. Read the contribution rules

In the target (upstream) repo, read whatever exists: `CONTRIBUTING*`, `.github/PULL_REQUEST_TEMPLATE*` (or `docs/`), `AGENTS.md`/`CLAUDE.md`, `README` contribution section, `.github/workflows` (what CI enforces), and recent merged PRs (`gh pr list --state merged --limit 5`) for title/body style. If the target is a repo the user has no clone of, read it via `gh api`/`gh repo view`.

Extract: branch naming, commit message format, required checks (lint/test/build), required sign-off (DCO/CLA), changelog/docs/test expectations, issue-linking convention, PR template sections, and target base branch.

## 2. Fill the gaps

Compare the branch against that list (`git log`/`git diff <base>...HEAD`) and fix what's missing: run the required checks, add the missing test/doc/changelog entry, fill the PR template. Leave fixes uncommitted and report them — don't commit unless the user says so. If commit messages or sign-off don't comply, say so and propose the exact fix (reword/amend) rather than rewriting history unasked.

If you're on the default branch, stop and ask for a branch name — a PR needs its own branch.

## 3. Push

Check access: `gh repo view <upstream> --json viewerPermission -q .viewerPermission`.

- WRITE/ADMIN/MAINTAIN: push the branch to the upstream remote: `git push -u <remote> <branch>`.
- Otherwise fork: `gh repo fork <upstream> --remote --remote-name fork --clone=false` (reuse an existing fork), then `git push -u fork <branch>`.

Never force-push, and never push to the default branch.

## 4. Screenshots

If the change is visible (UI, rendered output, CLI/TUI output) or the template/rules ask for them, prepare screenshots: run the app and capture before/after into the session scratchpad directory (use the `run` skill or agent-browser). Name files meaningfully and keep them all in one folder. Skip this for changes with nothing to see.

## 5. Draft

Fill the project's PR template (or a short summary / why / how it was tested if none), following the title conventions found in step 1. Reference issues the way the project does; no auto-closing keywords unless the user asks.

For each screenshot, put a placeholder in the body where it belongs, just the file name, e.g. `<!-- screenshot: before-login.png -->`. You can't upload images, so the user attaches each one in the PR editor.

Build the link: `https://github.com/<upstream>/compare/<base>...<head-owner>:<branch>?expand=1` (add URL-encoded `&title=`/`&body=` when short enough to fit).

Print the draft in the reply — don't write it to a file. Report: the title, the body (in a code block to copy), the link, the full absolute path of the screenshots folder to open for uploading, what you filled in step 2, and anything left for the user. Then stop.
