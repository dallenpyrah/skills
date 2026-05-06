---
name: merge
description: "Final merge gate after /learn. Verifies clean tree, open PR, up-to-date pushed head, passing required checks, reviewability, learning committed, and head SHA matches before merging through GitHub with the safe strategy. Deletes the branch, checks out base, fast-forwards. Use when the user types /merge, when the PR is reviewed and learned-from and ready to land, or when a previously failed merge gate needs to be retried. Writes 29-merge.md and closes the workflow."
---

# /merge

The only normal-workflow skill allowed to land a PR. Verifies every gate, then merges through GitHub with head-SHA protection.

## When this fires

- The user types `/merge`
- `/learn` is complete and pushed
- The PR is ready to land

## Position in the workflow

Previous: `/learn`. Next: end of run. See `/compound-workflow`.

`/merge` is the only normal-workflow skill that lands trunk. `/incident` may also land trunk under explicit production-pressure confirmation; no other skill should.

## Preconditions

- The PR is open and the branch is the PR's head
- The working tree is clean (`git status` shows no changes)
- Required checks pass on the head SHA
- All review threads either resolved or explicitly accepted with citation
- The learning file from `/learn` is committed and pushed

## Stance

Refuse to merge if any gate is unsatisfied. The gate output names the exact blocker — the user can act on it without guessing. Never merge by direct local commits to trunk. Never use destructive operations as a shortcut.

## Gates

Run in parallel. Each gate either passes or names the blocker.

### 1. Clean tree
- `git status` shows no unstaged or untracked changes
- No stash entries that should have been part of this run

### 2. Branch identity
- Current branch matches the PR head
- `git rev-parse HEAD` matches `gh pr view <number> --json headRefOid`

### 3. Up-to-date
- The PR head is at the latest pushed commit
- The base branch is fetched; the merge will not produce surprises

### 4. CI green
- `gh pr checks <number>` shows all required checks passing on the head SHA
- No required check is queued or running

### 5. Reviewability
- Required reviewers approved (or repo policy permits self-merge)
- No active "request changes" reviews
- Threads resolved or explicitly accepted with citation in `/address`

### 6. Learning committed
- A `docs/learnings/<date>-<slug>.md` file referenced in `<run-dir>/28-learn.md` exists at HEAD
- The file is on the remote head

### 7. Head SHA pinning
- The merge will be performed against a specific SHA, not the symbolic head
- Any push between gate evaluation and merge invalidates the gate

## Procedure

### 1. Run gates
Print a gate table:

| Gate | Status | Evidence / blocker |
|---|---|---|

### 2. If all pass
- Merge via `gh pr merge <number> --<strategy>` where `<strategy>` is the repo's safe strategy (`--squash`, `--merge`, `--rebase`)
- Pin to the head SHA: `gh pr merge <number> --squash --match-head-commit <SHA>`
- After merge, delete the branch: `gh pr merge ... --delete-branch` or `git push origin :<branch>` after confirming the remote
- Locally, switch to the base branch and fast-forward: `git checkout <base> && git pull --ff-only`

### 3. If any gate fails
- Do not merge
- Print the blocker(s)
- Hand off to the responsible skill (`/address` for review issues, `/verify` for failing checks, `/learn` for missing learning, `/work` for tree state)

## Required output

Write `<run-dir>/29-merge.md`:

### 1. Gate table
Final state of every gate.

### 2. Merge result
- Merge SHA
- PR closed and `Closes #<issue>` resolved
- Branch deleted (remote and local)
- Base branch fast-forwarded locally

### 3. Run summary
- Total artifacts written
- Issues filed (implementation + Boy Scout)
- Learnings committed

### 4. Handoff
Block per `/artifact-protocol` with `to: end` (workflow complete).

## Rules

- All gates must pass; no soft gates.
- Merge through GitHub, never by direct local commit to trunk.
- Pin the head SHA to prevent racing pushes.
- Delete the branch after merge.
- Fast-forward, never reset.
- Do not bypass hooks or required checks.
- If a gate fails, name the blocker and hand off.

## Anti-patterns

- "It's just a small fix" → bypass review.
- Force-merge to skip a flaky check (root-cause it).
- Local commit to base branch.
- Merging a PR whose learning has not been pushed.
- Deleting a branch that still has unmerged work.

## Composition

References: `/learn`, `/address`, `/verify`, `/compound-workflow`, `/artifact-protocol`. Tooling: `gh pr merge`, `gh pr checks`, `git`.

## Final response

When merged, end with exactly:

> Run merged and closed. Compound-engineering chain complete.

When blocked, end with exactly:

> Merge blocked. See gate table for the next action.
