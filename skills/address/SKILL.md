---
name: address
description: Triage and address PR review comments. Uses available issue/architecture/context when present, keeps evidence in .context/address.md, and does not require prior workflow phases.
---

# /address

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Resolve review feedback while protecting the contract and avoiding approval spam.

## Inputs

Current PR comments, user-provided review comments, issue/architecture when present, current diff, `.context/` artifacts, or repo evidence.

## Reads

PR review threads/comments, changed files, tests, issue/PR body, `.context/` artifacts, CI state, and relevant repo rules.

## Writes

- code/test/doc changes as needed
- commits and pushes when operating on a PR
- silent thread resolution for addressed comments when supported
- `.context/address.md`
- `.context/session-state.md`

## Process

1. Triage each comment as `Address`, `Push back`, or `Escalate`.
2. Cite the concrete contract/principle/evidence for every pushback.
3. For `Address`, make the smallest correct change and verify it.
4. For `Escalate`, record the unresolved design/product question and suggest `/interview`, `/architect`, or `/review` as appropriate.
5. Watch CI after push when available.
6. Store full triage, evidence, changes, and unresolved comments in `.context/address.md`.
7. Update session state.

## Operator Output

Return the triage decision, up to three evidence bullets including verification/CI, remaining risk, and next action. Do not paste long comment threads into chat.

## Stop Conditions

Stop if a comment exposes a real unresolved tradeoff, CI fails for an unclear reason, or GitHub actions/auth prevent safe updates.
