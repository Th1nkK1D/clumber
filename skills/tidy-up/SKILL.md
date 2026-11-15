---
name: tidy-up
description: Clean up self-explanatory comments, shortcut/workaround code excused by comments, and low-value tests on the current changes (or a given scope). Use after finishing a change, before a commit/PR, or when the user asks to tidy up, clean up comments, or prune low-value tests.
---

# tidy-up

Remove clutter that doesn't earn its keep, in the current diff (default scope) or whatever scope the user names.

## Comments

Default to removing. The burden of proof is on keeping, and it applies equally to comments you just wrote: no author bias, no rationalising a comment into a "why".

Keep a comment only if it guards code that looks wrong or removable but is load-bearing, so a future reader would likely "clean it up" and break something (odd deep import, unusual workaround, ordering hack, a wrapper that looks redundant). Also keep required doc comments the project actually uses (JSDoc/docstrings, public API docs, license headers) — this is about dead weight, not documentation standards.

Remove, even when accurate:
- Comments that justify a decision or explain a tradeoff ("X because it's faster", "chosen so that Y", "keeps Z working"). That belongs in the commit or PR.
- Comments that restate what naming, paths, or config already say (e.g. "never deployed" on a git-ignored build-output folder).

```
// uses a Map for faster lookups          ← remove: justification
// keep this import deep: the barrel      ← keep: guards code that looks wrong
// re-export breaks the SSR build
```

## Comments used as an excuse

Review whether any comment is excusing a shortcut: an escape hatch, workaround, hack, or anti-pattern that was cheap to write now but will cost tech debt later. Typical tells: `TODO`/`FIXME`/`HACK`/`XXX`, "for now", "temporary", "workaround", "should really", "ignore this", lint/type suppressions (`eslint-disable`, `@ts-ignore`, `# type: ignore`, `noqa`) and `any`/blanket-catch/copy-paste with an apology attached. The comment doesn't make it acceptable.

Fix the code properly and drop the comment. If the proper fix is genuinely out of scope (large, risky, needs the user's call), don't leave it silently: flag it in the report with what the right fix would be. Keep a workaround only when it's for a bug or limit in code we don't own, and the comment says which and when it can go.

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
4. Apply the removals, and fix the shortcuts found under "Comments used as an excuse".
5. Report what was removed or fixed and why, shortcuts flagged but left (with the right fix), and anything you deliberately kept despite looking removable, one line each, naming the breakage it prevents. No long defences.
