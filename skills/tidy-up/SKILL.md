---
name: tidy-up
description: Clean up self-explanatory comments and low-value tests on the current changes (or a given scope). Use after finishing a change, before a commit/PR, or when the user asks to tidy up, clean up comments, or prune low-value tests.
---

# tidy-up

Remove clutter that doesn't earn its keep, in the current diff (default scope) or whatever scope the user names.

## Comments

Delete a comment if removing it wouldn't confuse a future reader — i.e. it just restates what well-named code already says.

Keep a comment only if it carries something the code can't: a non-obvious *why* (hidden constraint, subtle invariant, workaround for a specific bug), a surprising behavior, or required doc format (JSDoc/docstring the project actually uses). When in doubt, keep requested/required doc comments (public API docs, license headers) — this is about dead weight, not documentation standards.

## Tests

Prune tests that cost more than they're worth long-term:
- Tests that just re-assert the implementation (change the code, change the test, no real coverage).
- Duplicate cases covering the same path as another test, with no new edge case.
- Tests for trivial code (one-line getters, straight pass-throughs) that can't realistically break.
- Flaky or disabled/skipped tests nobody has fixed — flag these; don't silently delete without saying so.

Keep tests that would actually catch a regression: edge cases, bug-fix regressions, anything covering non-obvious logic (branches, loops, parsing, money/security paths).

## Process

1. Scope: the current diff, unless the user names a different scope.
2. Scan for comments and tests in that scope.
3. For each candidate removal, be able to state in one line why it's low value (restates code / duplicate coverage / untestable-to-break).
4. Apply the removals.
5. Report what was removed and why, and anything you deliberately kept despite looking removable (and why).
