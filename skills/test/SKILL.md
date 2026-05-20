---
name: test
description: Harden and run tests for the current implementation using issue, architecture, diff, or user request as evidence. Writes test evidence to .context/test.md and hands naturally to /docs.
---

# /test

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Prove the changed behavior and add only tests that would catch real failure modes.

## Inputs

Current diff, commits, user request, issue, `.context/work.md`, architecture/review artifacts, or any subset of those.

## Reads

Changed files, existing tests, package scripts, issue/PR context, `.context/` artifacts, and relevant docs.

## Writes

- test changes when coverage is missing
- test commits when the workflow expects commits
- `.context/test.md`
- `.context/session-state.md`

## Process

1. Derive expected behavior from available contract and actual diff.
2. Identify failure modes that current tests would miss.
3. Add focused tests only when they improve confidence.
4. Run the tightest verification loop available.
5. Record commands, results, failures, and unverified claims in `.context/test.md`.
6. Update session state.

## Operator Output

Return the verification decision, up to three evidence bullets with commands/results, remaining risk, and next action. Suggest `/docs` when behavior/config/API changed; otherwise suggest `/pr`.

## Stop Conditions

Stop if tests expose a production bug, the implementation contradicts the contract, or the environment cannot run the required proof.
