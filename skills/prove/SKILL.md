---
name: prove
description: Prove that the current changes work as expected before declaring a task done. Use after making code changes, fixing a bug, or implementing a feature, whenever the user asks to verify, prove, confirm, or check that something works, or before reporting a task complete.
---

# prove

Verify the current changes actually work. Don't just say it's done — show it.

## 1. Plan

Before running anything, write down (briefly, not a doc):
- What changed (diff/files touched) and what behavior it should produce.
- Test methods available in this repo, in priority order: existing test suite, linter/type-checker, build/compile step.
- If those don't cover the change (e.g. UI behavior, API response shape, visual output), plan manual verification: a real request (curl/http client), a script exercising the code path, a browser check, or a screenshot.
- Concrete test cases: the golden path and the edge cases the change touches.

## 2. Execute

- Run repo-specific tooling first (`package.json` scripts, `Makefile`, `cargo test`, `pytest`, etc. — check what the repo actually has, don't assume).
- Run linter/type-checker if present.
- Run build if present.
- If any of the above don't exist or don't exercise the actual change, perform manual verification: make the real request, drive the browser, take a screenshot, run the script — whatever actually exercises the changed behavior.
- Capture actual output/errors, not assumptions.

## 3. Report

Report back to the user:
- What was run (commands/tools used).
- Pass/fail per check, with real output for failures.
- Anything not verifiable and why (e.g. no test infra, manual step needed from the user).
- Don't claim success on checks you didn't actually run.
