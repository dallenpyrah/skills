---
name: learn
description: Capture one durable lesson from the completed workflow. Reads issue, PR, diff, review, and .context evidence; writes a concise learning file and hands naturally to /merge.
---

# /learn

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Preserve the mechanism worth repeating or avoiding.

## Inputs

Current PR, issue, commits, final diff, review comments, `.context/` artifacts, or user-provided workflow summary.

## Reads

Issue/PR bodies, comments, commits, diff, CI result, `.context/` evidence, prior learnings when relevant.

## Writes

- `docs/learnings/YYYY-MM-DD-<slug>.md`
- learning commit/push when operating on a PR branch
- `.context/learn.md`
- `.context/session-state.md`

## Process

1. Compare intended contract with what shipped.
2. Identify one non-obvious lesson about mechanism, incentives, boundary, failure mode, or process.
3. Write the shortest durable learning that future agents can apply.
4. Include an AGENTS/skill amendment candidate only when it generalizes.
5. Record supporting evidence in `.context/learn.md`.
6. Update session state.

## Operator Output

Return the learning file path, up to three evidence bullets, remaining risk, and next action. Suggest `/merge` when the PR is ready.

## Stop Conditions

Stop if the PR/workflow evidence is too incomplete to produce an honest lesson, or if the learning would merely restate the diff.
