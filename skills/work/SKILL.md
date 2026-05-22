---
name: work
description: "Implement the requested change on the current branch using the best available contract: issue, architecture, user request, or repo evidence. Does not require /architect or /review to have run. Hands naturally to /test."
---

# /work

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Make the smallest correct code change that satisfies the current contract.

## Inputs

User request, GitHub issue, `.context/architecture.md`, `.context/review.md`, `.context/session-state.md`, current branch state, or any subset of those.

## Reads

Repo code/tests/config, relevant `.context/` artifacts, issue/PR context when present, package source/docs when behavior matters.

## Writes

- code changes
- focused commits when the workflow expects commits
- `.context/work.md`
- `.context/session-state.md`

## Process

1. Identify the contract from strongest available source: explicit user request, issue, architecture, review, repo facts.
2. Check branch and dirty state; preserve unrelated user changes.
3. Ground external APIs before coding.
4. Implement the smallest change that protects the relevant invariant.
5. If implementation exposes wrong architecture, record it and either adjust the local plan or suggest `/architect`; do not silently drift.
6. Run the tightest local check that fits the change.
7. Update session state with changed files, verification, risk, and next action.

## Operator Output

Return what changed, up to three evidence bullets including verification, remaining risk, and next action. Suggest `/test` for test hardening; if verification already proves the change and no test gap remains, suggest `/docs` or `/pr` as appropriate.

## Stop Conditions

Stop if the contract is contradictory, a required user decision is missing, the current branch is unsafe to change, or verification reveals a deeper design problem.
