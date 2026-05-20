---
name: scout
description: Ground an unfamiliar repo area, library, API, failure mode, or design question. Writes evidence to .context/scout.md and returns only constraints, risks, unknowns, and the next natural action.
---

# /scout

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Map facts that would change a later decision.

## Inputs

A concrete topic from the user, current repo context, an issue/PR, or the active uncertainty. If the topic is vague, inspect the repo first, then ask one clarifying question only if needed.

## Reads

Repo code/tests/docs, git history, installed package source/types, official docs or context7 for library/API behavior, gh_grep/reference repos for usage, exa for current external pages.

## Writes

- `.context/scout.md`
- `.context/session-state.md`

## Process

1. State the scout question in one sentence.
2. Gather only evidence that could change boundaries, failure model, state model, API shape, security, migration, or next questions.
3. Separate facts from assumptions.
4. Put source notes, snippets, raw findings, and rejected leads in `.context/scout.md`.
5. Update session state with constraints, unknowns, evidence path, and next action.

## Operator Output

Return: decision, up to three evidence bullets, risk/unknowns, and next action. Suggest `/interview` when intent needs pressure; suggest `/architect` when the problem and direction are already clear.

## Stop Conditions

Stop when new evidence is unlikely to change the next decision, or when one user decision blocks further grounding.
