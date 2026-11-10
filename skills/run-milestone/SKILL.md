---
name: run-milestone
description: Run a plan's milestones (see plan-milestones) end to end, one at a time — implement (inline or via a dispatched agent, chosen by the milestone's complexity), review (with an independent reviewer agent when the complexity warrants), fix what's worth fixing, verify, and commit — continuing automatically into subsequent milestones (unless the user asked for just one) until the plan is done or it hits one flagged with a blocker needing the user. Use when the user asks to run/implement/dispatch a milestone, or to continue a plan from where it left off.
---

# run-milestone

You are the orchestrator and the only one who commits. Depending on the milestone's complexity (see "Staffing"), you either implement it yourself or dispatch agents to.

## 0. Resume check

Use the plan the user names. If they don't, look in `plans/` (or wherever the repo keeps plans): one file is the plan; several, ask which.

If this plan has been worked on before, follow its "Resuming in a new session" section (see `plan-milestones`). One addition to that recipe: a plan-file-only diff updating the previous milestone's commit hash is expected, not an interruption — fold it into whatever you commit next.

## Staffing

Read the milestone's `Complexity:` line (treat a missing one as medium) and choose per milestone. Defaults:

| Complexity | Implementer | Reviewer |
|---|---|---|
| low | you, inline | none: your own `prove` plus a read of the diff |
| medium | dispatched agent | none: your own `prove` plus a read of the diff against the `ponytail-review` rubric |
| high | dispatched agent | fresh reviewer agent |

These are defaults, not rules: upgrade (e.g. dispatch a reviewer for a medium milestone touching security-sensitive code) when your read of the actual work says the estimate was low, and note any override and why in `Notes`. Don't downgrade a high milestone. Where the steps below say "the implementer" or "the reviewer agent" and that role is you, do it yourself and skip the dispatch and brief.

## Dispatching agents

Implementer and reviewer each need their own agent with no shared context, and you need to be able to read back what it produced and send it follow-ups (findings, fixes) while it's still the same agent/session — not a fresh one that's lost the thread. How you dispatch them depends on what's available, in this order:

1. **A pane/session control skill, if one is loaded** (e.g. a `kero` skill when running inside Kero, or any other agent-control-pane skill this environment provides) — check the available skills list first. These make the agent visible in its own pane so the user can watch or step in, which is preferable when available. Read its output by reading the pane; send follow-ups by typing into it.
2. **A subagent tool** (e.g. the `Agent` tool with a fresh, non-fork subagent type), used when no pane-control skill is available. Read its result from the final report; send follow-ups by resuming the same subagent (not a new one).

Whichever method you use, each dispatched agent must start fresh (no memory of your own reasoning) and needs the full brief below — it can't infer context the way a fork would.

To close a leftover session found during the resume check: a pane skill's own close/list command; a subagent has nothing to close, unless it's still running and the tooling offers a way to stop it.

## 1. Implement

If staffing says inline, implement it yourself following the rules and finish steps below (verify, tick checkboxes, fill `Notes`), then go to review. Otherwise dispatch a fresh agent (per "Dispatching agents" above) in the target repo, running autonomously.

Send it a brief covering:
- The plan file path and which milestone section to read, plus the Notes of earlier milestones.
- Any skills it should load before writing code (project-specific tooling skills, if any).
- Rules: keep it simple, no unrequested abstractions/deps; work on the current branch; **don't commit**; long-running processes (dev server, etc.) run in their own pane/session if the environment supports one, closed when done; if blocked by missing credentials or external input, stub it and note it — stop and ask only if the decision changes scope.
- What to do when finished: verify every "Done when" item itself, tick checkboxes, fill in the existing `Notes (M<N>):` placeholder under the milestone (decisions/deviations/deferred items, the exact verification commands run), then reply with a short summary.

Wait for it to finish or ask for input before moving on. If it asks for input that isn't a scope-changing decision: answer it yourself from the plan's Facts/Decisions if they settle it; otherwise stop the loop and ask the user — don't guess and don't leave it hanging.

If something got stubbed (missing credential/external input) and that leaves a "Done when" item unprovable, that's still a commit, not a blocker: the milestone ships with the stub, the unprovable item stays unchecked, and `Notes` records what's stubbed and what unblocks it later.

## 2. Review

Two reviews happen here, and both feed the same fix round — don't relay them separately.

- **You, the orchestrator, check requirements yourself** — use `prove`: don't take the implementer's "Done when" checkmarks on faith, re-run the checks (or exercise the behavior) and see for yourself whether the milestone actually does what the plan asked. This is about fit to the requirement, not code quality.
- **A fresh reviewer agent**, only when staffing calls for one; otherwise read the diff yourself against the same checks below. The reviewer (per "Dispatching agents" above, no shared context — same principle as `peer-review`) gets the milestone's goal, its section of the plan, and the scope: `git status`/`git diff` plus new files. It doesn't edit anything. It checks:
  - Over-engineering (reuse `ponytail-review`'s rubric if available).
  - Correctness bugs.
  - Every checklist item and "Done when" it can independently verify.

It reports a numbered list: severity, `file:line`, problem, fix. "No findings" is a valid report.

## 3. Triage and fix

Combine your own requirement findings with the reviewer's into one list, then triage it per `peer-review` step 4 — fix now vs. skip, each with a reason — but skip `peer-review`'s user-confirmation step, since this loop runs unsupervised. Relay only the fix-now items to the implementer session in one pass (or fix them yourself if you implemented inline); record skipped ones (and why) in the milestone's `Notes`.

At most 2 review-and-fix rounds. Anything still open after that goes into `Notes` as a known gap, or to the user if it's a real blocker — don't loop indefinitely chasing a clean review.

## 4. Gate and commit

Once review is clean, or the 2 rounds are used up and remaining gaps are logged: run `tidy-up` on the milestone's diff (relay it to the implementer if there is one, rather than editing yourself), then re-run `prove`'s checks against the settled state — but only if anything changed since your last `prove` in step 2; skip the repeat if round 1 was already clean and fix-free.

Before committing, also reread the milestone's `Notes (M<N>):` entry: it was written before the fix rounds, so prune anything the fixes made stale (a deviation that got fixed, a deferred item that got done) and cut anything low-value (restating the checklist, excess narration). Keep what a future resuming session would actually need.

Once checks and notes are settled, make one commit on the current branch (don't push unless asked). Follow the repo's existing commit message convention (check `git log` and any `AGENTS.md`/`CLAUDE.md` rules). Then update the plan's progress table with the commit hash (this edit lands as a plan-file-only diff ahead of the next milestone's commit — expected, see `plan-milestones`). Close any dispatched agents/sessions.

## 5. Continue or stop

Before dispatching each milestone (including the first), check whether it's flagged with a **blocker** — something it can't start without the user (missing credentials, a one-time external setup step, an undecided product choice). If so, stop and report, naming what's needed to unblock it; don't dispatch it anyway. This is a first-blocked-milestone-in-order check, not a dependency scan — the plan should already order milestones so blocked ones sit as late as their real dependencies allow.

If the user asked for one specific milestone (or said "just this one"), stop after committing it, even if the next one has no blocker. Otherwise, after committing, loop back to step 1 for the next not-done milestone (no need to redo the full step 0 resume check — you already know the state) and keep going until the plan is complete or you hit a blocker.

Once the user actually resolves a blocker (provides the credential, makes the call, does the setup step), clear it from the plan doc and continue from that milestone. Don't invent blockers for milestones that don't need one — the point is to run unsupervised as far as the plan's real dependencies allow, not to add caution checkpoints.
