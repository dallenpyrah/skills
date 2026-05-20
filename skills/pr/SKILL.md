---
name: pr
description: Open or update a pull request from the current branch with a minimal durable body. Reads available context, commits relevant changes if needed, pushes, watches checks, and hands naturally to /code-review.
---

# /pr

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`, `../_shared/ascii-diagrams.md`.

## Purpose

Create the review surface for the change.

## Inputs

Current branch, diff/commits, issue if present, `.context/` artifacts, or user request.

## Reads

Git status/log/diff, GitHub issue/PR state, CI configuration, `.context/session-state.md`, and relevant evidence artifacts.

## Writes

- PR body
- branch push
- `.context/pr.md`
- `.context/session-state.md`

## Process

1. Confirm the branch and relevant diff without renaming the branch.
2. Commit only PR-relevant changes when committing is part of the workflow.
3. Build a minimal PR body: summary, flow/contract only when useful, issue closure when present.
4. Push and open/update the PR.
5. Watch CI when configured.
6. Record PR URL, checks, and remaining risk in `.context/pr.md`.
7. Update session state.

## Operator Output

Return PR URL/state, up to three evidence bullets including CI result, risk, and next action. Suggest `/code-review` when the PR is reviewable.

## Stop Conditions

Stop if the tree has unrelated changes that cannot be separated, GitHub auth fails, push fails, or CI fails in a way that needs user action.
