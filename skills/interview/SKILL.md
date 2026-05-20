---
name: interview
description: Clarify the problem, values, constraints, non-goals, failure modes, and intended direction with minimal high-value questions. Writes .context/interview.md and hands naturally to /architect when enough is known.
---

# /interview

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Turn uncertainty into a small set of locked decisions and open questions.

## Inputs

User prompt, current conversation, repo evidence, `.context/scout.md` when present, issue/PR context, or a review comment that exposed uncertainty.

## Reads

Repo evidence when a question is answerable by inspection. Do not ask the user for facts the repo can answer.

## Writes

- `.context/interview.md`
- `.context/session-state.md`

## Process

1. Identify the missing decision that blocks better work.
2. Explore repo facts first when applicable.
3. Ask 1-3 questions that reduce the most uncertainty.
4. Provide a recommended answer for each question when a default is reasonable.
5. Record locked decisions, rejected paths, values, constraints, non-goals, incentives, and remaining unknowns in `.context/interview.md`.
6. Update session state.

## Operator Output

If more input is needed, output the current phase, what is already locked, 1-3 questions, and why each matters. If enough is known, output `Core shape locked`, three evidence bullets, risk, and suggest `/architect`.

## Stop Conditions

Stop when the next architectural decision can be made responsibly, or when the user must choose between real tradeoffs.
