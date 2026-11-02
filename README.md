# Clumber

Personal Claude Code plugin. Starts with skills, grows as needed.

## Skills

- [`prove`](skills/prove/SKILL.md) — verify changes actually work (tests/lint/build, or manual checks) before declaring a task done.
- [`tidy-up`](skills/tidy-up/SKILL.md) — clean up self-explanatory comments and low-value tests on the current changes.
- [`peer-review`](skills/peer-review/SKILL.md) — get an independent review from a fresh subagent, triage findings, fix what's worth fixing.
- [`plan-milestones`](skills/plan-milestones/SKILL.md) — turn a rough idea into a milestone plan doc with checkable "Done when" criteria and flagged blockers.
- [`run-milestone`](skills/run-milestone/SKILL.md) — run a plan's milestones end to end: implement, review, fix, verify, commit, repeat.
- [`walkthrough-diff`](skills/walkthrough-diff/SKILL.md) — open a diff in codiff's walkthrough mode for the user to read, including milestone-by-milestone.

## Install

```
/plugin install clumber@<marketplace-or-path>
```
