---
name: plan-milestones
description: Turn a rough idea, feasibility writeup or project proposal into a milestone plan with checkable "Done when" criteria, flagged human-intervention blockers, and a resume recipe for later sessions. Use when the user asks to plan a multi-step build, break work into milestones, or write a project plan doc.
---

# plan-milestones

A plan is only useful if a future session (yours or another agent's) can resume it cold. Write for that reader, not for the one writing it.

## 0. Clarify first

The user usually starts with a rough idea, not a spec. Before structuring anything, bounce it back: surface the ambiguities, edge cases and open decisions you can see (scope boundaries, which option among real tradeoffs, what's explicitly out), and ask about the ones that would change the plan's shape — not every detail, just what's load-bearing. Prefer a short batch of concrete questions (or options to react to) over asking one at a time. Keep going until the idea is solid enough to commit to milestones; don't treat the first answer as final if it opens a new question.

Only move to writing once the goal, scope and key decisions are settled enough that a stranger reading the doc wouldn't have to guess.

## 1. Research before deciding

When the user names a specific tool, library, platform or technique, don't take its fit on faith (yours or theirs) — research it before it becomes a Decision. Check its actual current capabilities, version, known limitations and gotchas (docs, changelog, issue tracker), not what you remember about it. Dispatch this to an agent/fork when it's non-trivial, so the research doesn't crowd out the planning itself.

This feeds two sections below: real findings go in **Facts gathered**, and the resulting choice (plus the tradeoff that made it) goes in **Decisions**. If research reveals the named tool doesn't actually fit, surface that to the user rather than quietly planning around it.

## Structure

Write the plan as a single markdown file at `plans/<project>.md` (create `plans/` if needed; use a different path only if the user names one or the repo already keeps plans elsewhere) with these sections, in order:

1. **Header** — what's being built, status, source material, target repo, what's explicitly out of scope.
2. **Progress table** — one row per milestone: name, status (`not started` / `done`), commit hash once done. This is the single source of truth for where things stand. Updating it is necessarily a separate edit after the milestone's commit (a commit can't contain its own hash) — `run-milestone` handles this; expect the plan file to show as dirty between a milestone's commit and the next one.
3. **Resuming in a new session** — numbered steps: read the progress table and the last finished milestone's Notes, check `git log`/`git status` for interrupted work (a plan-file-only diff updating the previous milestone's hash is expected, not an interruption), find and close leftover agent sessions, then continue from the first not-done milestone.
4. **Facts gathered so far** — anything researched that would otherwise be re-researched: API shapes, constraints, external system quirks. Save future sessions from redoing discovery.
5. **Decisions** — choices made and why, especially ones with a real tradeoff. Not implementation detail — the "why this and not that."
6. **Execution workflow** — how each milestone gets implemented, reviewed and committed (point this at the `run-milestone` skill rather than re-describing it).
7. **Milestones** — numbered `M1`, `M2`, … in both headers and the progress table; `run-milestone` and `walkthrough-diff` key off this numbering. Each one has a checklist, a "Done when" (concrete, checkable — commands or observable behavior, not vibes), and a **complexity** estimate (see below). If a milestone can't start without something only the user can provide (credentials, a one-time external setup step, a decision the plan couldn't settle in advance), flag it as a **blocker** in that milestone's header, naming what's needed. Order milestones so a blocked one sits as late as its real dependencies allow — `run-milestone` stops at the first blocked milestone it reaches, in order, not by scanning ahead for one that isn't.

## What a milestone is

A milestone is one increment of working, shippable functionality — not a phase of work (not "write the schema," "write the tests," "write the UI" as separate milestones for the same feature). Each one lands as a single commit, so size it to what a human can actually review and test in that one commit: small enough to hold in your head, big enough to be a complete, working slice. If a milestone can't state a "Done when," or can't be reviewed in one pass, it's too vague or too big — split it or sharpen it.

Success has to be measurable without judgment calls — a command that passes or fails, a behavior you can click through and see. If "done" would need a conversation to agree on, the milestone is too vague; sharpen it or split it.

## Complexity

Put a `Complexity: low | medium | high` line, with a one-line reason, in each milestone's header. `run-milestone` uses it to decide whether to implement inline or dispatch an implementer, and whether a separate reviewer agent is worth it.

- **low** — small, familiar, mechanical: a few files, existing patterns, no tricky logic. Easy to hold in one head.
- **medium** — a real slice of work: several files or one new module, some new-to-this-codebase tech, but no subtle correctness risk.
- **high** — any of: many files or modules, unfamiliar or external integration, subtle logic (concurrency, money, security, parsing, migrations), or notable ambiguity left in the requirements.

Judge by risk of getting it wrong, not by line count. If a milestone is high mainly because it's big, split it instead.

## Rules

- Milestones should be independently committable and independently verifiable.
- Don't pre-write implementation detail the implementer should decide — the plan states the goal and constraints, not the code.
- Leave a `Notes (M<N>):` placeholder under each milestone; `run-milestone` fills it in as milestones complete. Don't write it yourself.
