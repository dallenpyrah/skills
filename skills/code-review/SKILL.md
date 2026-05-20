---
name: code-review
description: Review the current PR for correctness, tests, maintainability, security, standards, and prior-findings risk. Keeps reviewer detail in .context/code-review.md and posts concise actionable GitHub review comments.
---

# /code-review

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Find actionable PR issues without dumping reviewer transcripts into chat.

## Inputs

Current PR, diff, issue/architecture when present, `.context/` artifacts, prior comments, or user-provided patch.

## Reads

PR metadata/diff/comments/checks, changed files, relevant tests, issue/PR body, `.context/` artifacts, prior learnings, and `REVIEWERS.md` as the reviewer lens reference.

## Writes

- GitHub review comments when operating on a PR
- `.context/code-review.md`
- `.context/session-state.md`

## Process

1. Build the review contract from strongest available evidence.
2. Review through six lenses: correctness, tests, maintainability, standards, security, prior findings.
3. Deduplicate and validate findings against actual diff lines.
4. Post blockers and majors; post minors only when actionable; keep nits grouped or omitted.
5. Store full reviewer notes, dropped findings, and validation details in `.context/code-review.md`.
6. Update session state.

## Operator Output

Return number of posted blockers/majors/minors, up to three evidence bullets, risk, and next action. Suggest `/address` when comments exist; suggest `/learn` if there are no findings and the PR is otherwise ready.

## Stop Conditions

Stop if no PR/diff can be found, GitHub line commentability cannot be verified, or review evidence is insufficient to post honestly.
