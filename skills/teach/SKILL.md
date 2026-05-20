---
name: teach
description: Teach a concept, solution, or pattern one layer at a time with grounded examples. Uses the attention contract and avoids dumping full derivations unless requested.
---

# /teach

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Make one concept usable without overwhelming the learner.

## Inputs

Named concept, recent architecture/fix/design, repo code, library/API question, or user request to learn.

## Reads

Actual repo code for repo topics, official docs/context7/package source for library/API behavior, and `.context/` artifacts when teaching a recent workflow result.

## Writes

- `.context/teach.md` when the explanation depends on evidence or should persist
- `.context/session-state.md` for substantial teaching sessions

## Process

1. Identify the one concept being taught.
2. Ground facts before explaining repo/API behavior.
3. Teach the first useful layer only: problem, simple model, concrete example, where it fails.
4. Ask at most three check questions or offer the next layer.
5. Put extended notes or source details in `.context/teach.md` when needed.

## Operator Output

Use compact teaching prose, not the workflow `Decision` template unless a decision is being taught. Include one concrete example and the next learning step.

## Stop Conditions

Stop if the topic is ambiguous and cannot be inferred, or if deeper layers require user choice.
