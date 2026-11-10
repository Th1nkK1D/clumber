# Clumber

Personal Claude Code plugin. Starts with skills, grows as needed.

## Skills

- [`take-issue`](skills/take-issue/SKILL.md) — take a GitHub issue: check its card, assign you, implement, prove, tidy up, then wait for your go-ahead to commit.
- [`plan-milestones`](skills/plan-milestones/SKILL.md) — turn a rough idea into a milestone plan doc with checkable "Done when" criteria, complexity estimates and flagged blockers.
- [`run-milestone`](skills/run-milestone/SKILL.md) — run a plan's milestones end to end: implement (inline or via an agent, by complexity), review, fix, verify, commit, repeat.
- [`prove`](skills/prove/SKILL.md) — verify changes actually work (tests/lint/build, or manual checks) before declaring a task done.
- [`tidy-up`](skills/tidy-up/SKILL.md) — clean up self-explanatory comments and low-value tests on the current changes.
- [`peer-review`](skills/peer-review/SKILL.md) — get an independent review from a fresh subagent, triage findings, fix what's worth fixing.
- [`walkthrough-diff`](skills/walkthrough-diff/SKILL.md) — open a diff in codiff's walkthrough mode for the user to read, including milestone-by-milestone.
- [`handoff-prompt`](skills/handoff-prompt/SKILL.md) — write a copy-paste prompt that hands the current work to another agent with all needed context.

## Install

```
/plugin install clumber@<marketplace-or-path>
```
