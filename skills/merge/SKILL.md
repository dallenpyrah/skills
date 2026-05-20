---
name: merge
description: Merge the current PR through GitHub after verifying branch state, reviewability, checks, and user/repo constraints. Writes merge evidence to .context/merge.md.
---

# /merge

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Land the PR without bypassing review or branch safety.

## Inputs

Current PR/branch, `.context/session-state.md`, CI state, review state, user instruction.

## Reads

Git status, PR metadata, checks, review decision, branch protection/merge state, `.context/` artifacts.

## Writes

- merged PR through GitHub
- branch cleanup when safe
- `.context/merge.md`
- `.context/session-state.md`

## Process

1. Verify clean relevant tree and correct PR/branch.
2. Verify pushed head, CI, review state, and mergeability.
3. Merge through GitHub using repo-safe strategy.
4. Delete branch and update base branch only when safe and expected.
5. Record merge URL/SHA/checks in `.context/merge.md`.
6. Update session state.

## Operator Output

Return merge decision, up to three evidence bullets, remaining risk, and next action. If merged, next action is complete.

## Stop Conditions

Stop if checks fail, review/merge state is unsafe, branch state is ambiguous, or the requested merge would bypass repo policy.
