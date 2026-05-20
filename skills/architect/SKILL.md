---
name: architect
description: Derive the smallest correct architecture from user intent, repo facts, and available workflow evidence. Writes the full architecture to .context/architecture.md and returns only the decision, tradeoff, risk, and next action.
---

# /architect

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`, `../_shared/ascii-diagrams.md`.

## Purpose

Choose a mechanism that makes the correct move cheap, the dangerous move impossible or loud, and the repeated future move sustainable.

## Inputs

User prompt, repo facts, `.context/scout.md`, `.context/interview.md`, existing issues/PRs, or any subset of those. Missing prior artifacts are not blockers.

## Reads

Repo code/tests/docs, dependency source/docs when behavior matters, `./PRINCIPLES.md` for architectural pressure, and prior `.context/` artifacts when present.

## Writes

- `.context/architecture.md`
- `.context/session-state.md`

## Process

1. Reconstruct the problem from available evidence.
2. Ground missing repo/API facts before designing.
3. Name invariants, constraints, non-goals, players, bad local moves, and the core tradeoff.
4. Derive the smallest architecture that protects the invariant.
5. Use ASCII diagrams only when structure is clearer than prose.
6. Include concrete contracts in `.context/architecture.md`: public types, command shape, module boundary, or state union.
7. Record alternatives and principle checks in `.context/architecture.md`, not chat.
8. Update session state with the chosen architecture and next action.

## Operator Output

Return the architecture decision in one sentence, up to three evidence bullets, the central tradeoff/risk, the path to `.context/architecture.md`, and the next natural action. Suggest `/review` for pressure-testing; suggest `/issue` only when the risk is already low.

## Stop Conditions

Stop and ask 1-3 questions only when the architecture would otherwise encode an unchosen product or risk tradeoff.
