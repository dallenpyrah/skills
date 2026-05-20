---
name: docs
description: Update documentation for changed behavior, APIs, config, operations, migrations, or architectural contracts. Reads current diff and evidence artifacts, writes only necessary docs, and hands naturally to /pr.
---

# /docs

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Make durable public or operator knowledge match the code.

## Inputs

Current diff, commits, issue/PR, `.context/work.md`, `.context/test.md`, architecture artifacts, or user request.

## Reads

Changed behavior, existing docs, README/config references, issue/PR context, and `.context/` evidence.

## Writes

- documentation changes only
- doc commit when the workflow expects commits
- `.context/docs.md`
- `.context/session-state.md`

## Process

1. Identify behavior, API, config, migration, operation, or architectural contract changes.
2. Search existing docs before adding new docs.
3. Update the narrowest correct doc surface.
4. Do not document internals that are not user/operator contracts.
5. Run relevant docs/static checks when available.
6. Update session state.

## Operator Output

Return whether docs changed, up to three evidence bullets, remaining risk, and next action. Suggest `/pr`.

## Stop Conditions

Stop if docs would expose unverified behavior or the code/test state is too unclear to document honestly.
