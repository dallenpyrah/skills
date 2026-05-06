---
name: learn
description: "Capture the post-mortem after /address, before /merge. Reads the issue, PR, review comments, run artifacts, git log, and final diff; extracts what worked, what changed, what created friction, what mechanisms improved code health, and what durable rule should change. Writes the learning to docs/learnings/<date>-<slug>.md, commits, pushes, and writes 28-learn.md. Hands off to /merge while the PR is still open."
---

# /learn

The workflow compounds because real friction becomes durable rules. This phase captures that translation.

## When this fires

- The user types `/learn`
- `/address` is complete and the PR is still open
- A retrospective is needed before merging

## Position in the workflow

Previous: `/address`. Next: `/merge`. See `/compound-workflow`.

## Preconditions

- The PR is open
- `<run-dir>/27-address.md` is in place
- `gh`, `git`, and write access to `docs/learnings/` are available

## Stance

A learning is durable if a future agent or contributor would change a decision because of it. Apply `/first-principles` (what was the irreducible cause) and `/game-theory` (what incentive created the friction; what mechanism would fix it).

A learning is **not**:

- a summary of what shipped (the PR body has that)
- a description of what was built (the diff has that)
- a praise piece (no one reads those)

A learning **is**:

- one observation
- one general principle
- the trigger condition that should make a future agent apply it

## Procedure

### 1. Read the run
- The implementation issue
- The PR body and discussion
- The full review (`/code-review`) and address pass (`/address`)
- `git log <base>..<head>` for the actual change shape
- `git diff <base>..<head>` for what materially changed

### 2. Extract candidates
Walk the run and surface:

- **What worked** — design or process choices that paid off; what triggered them
- **What changed mid-run** — design revisions, scope cuts, contract amendments, with the cause
- **Friction sources** — review comments, CI failures, rework, missing evidence; for each, the smallest mechanism that would have prevented it
- **Game-theoretic findings** — incentives the run exposed (good or bad)
- **Codification candidates** — rules, doc updates, tests, lints, AGENTS amendments, skill amendments, follow-up issues

### 3. Write `docs/learnings/<yyyy-mm-dd>-<slug>.md`
Body:

```markdown
# <title>

## Observation
<what happened, in one or two sentences>

## Evidence
<commands, files, review URLs, screenshots, failures>

## General principle
<what future agents should learn>

## Trigger condition
<when this lesson applies>

## Limits / counterexamples
<when not to apply it>

## Codification target
- one of: docs/learnings, AGENTS.md, skill amendment proposal, test fixture, lint/import rule, architecture doc, issue template, example, follow-up issue

## Proposed amendment or issue
<concrete next artifact>
```

If the run produced multiple distinct lessons, write one file per lesson.

### 4. Capture follow-up issues
For each codification candidate that needs work beyond writing the learning:

- file an issue per `/issue-capture`
- link it to the PR and the learning file

### 5. Commit and push
- Commit `docs/learnings/<file>.md` with a message that references the implementation issue
- Push to the PR branch (so reviewers see the learning before merge)

## Required output

Write `<run-dir>/28-learn.md`:

### 1. Learning files written
Path, title, codification target.

### 2. Follow-up issues filed
Per issue, link and codification target.

### 3. AGENTS / skill amendment proposals
If the lesson should change a global rule, the proposed diff.

### 4. Commit and push
SHA and branch state.

### 5. Handoff
Block per `/artifact-protocol`, pointing at `/merge`.

## Rules

- One learning per file; one principle per learning.
- Trigger condition is concrete enough that a future agent recognizes it.
- Codification target is named explicitly.
- Learning is committed and pushed before `/merge`.
- AGENTS / skill amendments are proposals, not silent edits.
- "We learned a lot" is not a learning.

## Anti-patterns

- Generic platitudes ("be careful with concurrency").
- Praise without principle.
- Codifying a one-off as a global rule.
- Skipping the learning when nothing felt new — there is always one mechanism worth naming.
- Writing the learning after merge (the PR loses the link).

## Composition

References: `/issue-capture`, `/artifact-protocol`, `/compound-workflow`, `/first-principles`, `/game-theory`. Tooling: `gh`, `git`.

## Final response

End with exactly:

> Learning recorded. Continue to `/merge`.
