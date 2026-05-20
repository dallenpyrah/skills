---
name: improve-architecture
description: Explore a codebase for architecture improvements that reduce coupling, deepen modules, or improve testability. Produces a ranked shortlist in chat and detailed evidence in .context/improve-architecture.md.
---

# Improve Architecture

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Find the highest-leverage simplification opportunity, not a long catalog of complaints.

## Inputs

User goal, repo area, current pain point, PR/issue, or broad request to improve architecture.

## Reads

Repo code/tests, dependency graph by inspection/search, git history, prior learnings, `.context/` artifacts, and `REFERENCE.md` only when needed.

## Writes

- `.context/improve-architecture.md`
- `.context/session-state.md`
- optional issue draft or opened issue when requested

## Process

1. Explore where changes require too many files, tests require internals, state is duplicated, or boundaries leak.
2. Rank candidates by production risk reduced per line changed.
3. Keep detailed coupling evidence and rejected candidates in `.context/improve-architecture.md`.
4. Present only the top 1-3 opportunities in chat.
5. Suggest `/architect` or `/issue` for the chosen opportunity.
6. Update session state.

## Operator Output

Return the best opportunity, up to three evidence bullets, risk/tradeoff, and next action. No report dump.

## Stop Conditions

Stop if the repo area is too broad after initial inspection and one user decision is needed to focus the search.
