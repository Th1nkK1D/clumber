---
name: reproduce
description: Reproduce a reported bug before fixing it — set up an environment as close as possible to the one described, run the steps, and confirm the failure. Use when the user gives a bug report or issue and asks to reproduce, confirm, or investigate it, or before fixing a bug.
---

# reproduce

Given a bug report (issue, message, log, description), make the bug happen for real. Don't fix it.

## 1. Gather

Pull everything the report gives: steps, inputs, expected vs actual behavior, error text/logs, version or commit, OS/runtime/browser, config, flags, data, and any attached images. Read comments too, later ones often add or correct details. Note what's missing.

Also read the project itself for how it's built and run: `README`, `AGENTS.md`/`CLAUDE.md`, `CONTRIBUTING`, manifests and lockfiles, CI config (the tested version/OS matrix), `Dockerfile`/`.env.example`, and any dev-setup docs.

## 2. Set up

Match the reported environment as closely as you can: check out the reported version/commit (in a separate worktree or the scratchpad, not over the user's working tree), same dependency versions, config, flags, and input data. Build fixtures in the session scratchpad. Where you can't match something (other OS, hardware, private data), say so and use the nearest stand-in.

Fall back to the project's documented setup and defaults for whatever the report leaves out (if no version is given, use the one current when the issue was filed, or HEAD if unclear). List every such assumption so the report can state it.

## 3. Reproduce

Follow the reported steps exactly, then capture the real output: errors, logs, screenshots. If nothing happens, vary what the report left open (inputs, versions, config) one thing at a time. Don't edit source to make it fail.

## 4. Report

- **Reproduced:** numbered minimal reproduce steps, the environment used (including assumptions made where the report was silent), and the actual output, in a form that can be re-run to prove the fix later.
- **Not reproduced:** what you tried, how your environment differed from the report, and the specific questions or info that would unblock it. Don't claim a cause you haven't observed.

Report observations, not diagnosis or fixes. Don't post to the issue or change anything in the repo unless asked.
