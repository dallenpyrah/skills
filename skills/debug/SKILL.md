---
name: debug
description: Reproduce, root-cause, and fix a bug with the smallest verified change. Writes investigation evidence to .context/debug.md and hands naturally to /test.
---

# /debug

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Replace guessing with a reproduction, causal model, fix, and proof.

## Inputs

Bug report, failing command/test, stack trace, user description, current diff, issue/PR, or production symptom.

## Reads

Repo code/tests/logs, package source/docs when relevant, git history, current branch state, `.context/` artifacts when present.

## Writes

- reproduction notes
- code/test changes when fixing
- `.context/debug.md`
- `.context/session-state.md`

## Process

1. Reproduce or create the tightest observable failing path.
2. Form hypotheses and test them with commands/code inspection.
3. After three failed hypotheses, stop and reframe the problem before trying another fix.
4. Fix the root cause with the smallest change.
5. Add or adjust the test that would have caught the bug when practical.
6. Verify the original reproduction and regression path.
7. Record evidence, failed hypotheses, fix, and generalization in `.context/debug.md`.
8. Update session state.

## Operator Output

Return root cause/fix decision, up to three evidence bullets including reproduction and verification, remaining risk, and next action. Suggest `/test` when broader test audit is useful; otherwise suggest `/docs` or `/pr`.

## Stop Conditions

Stop if the bug cannot be reproduced, the reproduction contradicts the report, the fix requires an unchosen product decision, or verification cannot run.
