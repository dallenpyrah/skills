---
name: review
description: Pressure-test a proposed architecture, issue, PR intent, or inferred design. Writes detailed findings to .context/review.md and returns LOCKED or NOT LOCKED with blockers only.
---

# /review

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Catch design errors before they become implementation cost.

## Inputs

`.context/architecture.md`, a GitHub issue, PR body, user proposal, or inferred design from current code. Missing architecture artifacts are not blockers; reconstruct the design from available context and label inferred claims.

## Reads

Architecture evidence, repo code/tests, dependency docs/source when referenced, git history and prior learnings when relevant.

## Writes

- `.context/review.md`
- `.context/session-state.md`

## Process

1. Identify the design under review and what evidence supports it.
2. Check invariants, source of truth, boundaries, effects/errors, state lifecycle, observability, migration, and local incentives.
3. Classify findings as `blocking`, `important`, or `minor`.
4. Put detailed findings, diffs, and reality-check notes in `.context/review.md`.
5. Decide `LOCKED` only when no blocking issue remains and important issues are fixed or accepted as explicit tradeoffs.
6. Update session state.

## Operator Output

Return `LOCKED` or `NOT LOCKED`, up to three evidence bullets, the highest remaining risk, the evidence path, and the next natural action. Do not restate the full architecture in chat.

## Stop Conditions

Stop when the lock decision is clear, or when a missing product/risk decision prevents judging the design.
