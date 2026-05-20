---
name: issue
description: Open or draft a GitHub issue from available architecture, review, repo, and user context. Uses prior artifacts when present but can synthesize a durable contract directly from the current task.
---

# /issue

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`, `../_shared/ascii-diagrams.md`.

## Purpose

Create a durable implementation contract with enough context for `/work` to proceed without rereading chat.

## Inputs

`.context/architecture.md`, `.context/review.md`, current user request, repo evidence, or an existing issue/PR. Missing prior artifacts are not blockers.

## Reads

Available `.context/` artifacts, repo files/tests, prior issues when relevant, and `REFERENCE.md` only when issue structure needs examples.

## Writes

- GitHub issue, unless the user asked only for a draft
- `.context/issue.md`
- `.context/session-state.md`

## Process

1. Reconstruct the problem, outcome, constraints, non-goals, and acceptance criteria from available evidence.
2. If architecture is absent but the work is small, write a minimal issue from the user request and repo facts.
3. If architecture is absent and the work is risky, write the issue with explicit assumptions and suggest `/architect` or `/review` as the next confidence step.
4. Use ASCII diagrams only when they reduce ambiguity.
5. Keep the issue as a contract, not a transcript or task dump.
6. Update session state with issue URL/number and next action.

## Operator Output

Return the issue decision, issue URL/number or draft path, up to three evidence bullets, risk, and next action. Suggest `/work` when implementation can start; suggest `/review` when unresolved design risk remains.

## Stop Conditions

Stop if the issue would encode a product decision the user has not made, or if GitHub access/authentication fails.
