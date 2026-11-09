# Clumber Agent Rules

Rules for working on this repo (the `clumber` plugin itself)

## Naming

- Skill directory names and frontmatter `name` are kebab-case, action-named (what it does: `tidy-up`, `peer-review`, `run-milestone`), never a bare tool name (`walkthrough-diff`, not `codiff`) and never run-together (`peer-review`, not `peerreview`).

## README

- When adding a new skill, add it to the `## Skills` list in `README.md` with a one-line summary of what it does.
- Order the list by workflow, not by when skills were added: entry points first (`take-issue`, `plan-milestones`), then the build/verify/review steps in the order you'd use them, then utilities (`handoff-prompt`). Place a new skill where it fits in that flow.

## Git

- Never commit on your own initiative; wait for explicit confirmation, even after finishing a change the user is clearly going to want committed.
- Commit messages are a single-line subject, no body.
- Don't push unless asked.
