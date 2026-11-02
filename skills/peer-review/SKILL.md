---
name: peer-review
description: Get an independent review of the current changes (or a given scope) from a fresh subagent, then fix what's worth fixing. Use before a commit/PR, or when the user asks for a review, second opinion, or peer review.
---

# peer-review

An independent agent catches what you're blind to in your own work — it hasn't seen your reasoning, only the result.

## 1. Frame the goal

State plainly, in your own words, what this change is trying to accomplish (the goal the user gave, not a re-description of the diff). The reviewer needs this to judge fitness, not just correctness.

## 2. Scope

Default: the current diff/changes. Use a different scope only if the user names one (a file, directory, PR, or branch).

## 3. Dispatch the review

Launch a **fresh** subagent (not a fork — it must have no prior exposure to your own reasoning) with the Agent tool.
- Model: `opus`, unless the user specifies another.
- Give it full context since it starts blank: the stated goal, the scope, relevant file paths, and what to check (correctness, fit to the goal, simplicity/over-engineering, missed edge cases). Ask it to report concrete findings, not a vibe check.

## 4. Triage feedback

Not everything a reviewer raises is worth acting on. For each finding, decide and briefly note why:
- Fix now — real bug, clear simplification, or misses the stated goal.
- Skip — stylistic preference, out of scope, or disagreed with (say why).

## 5. Confirm, then fix

Present your triage to the user — fix-now list and skip list, each with your reasoning — and wait for confirmation before changing anything. Adjust based on their call; they may want something you'd skip, or skip something you'd fix.

## 6. Fix and report

Apply only the confirmed fixes. Report back: the goal, what the reviewer flagged, what you fixed, what you skipped and why.
