---
name: debug
description: Standalone bug-investigation entry point. Reproduce the failure (require a failing test or trace), trace the root cause, implement the minimal fix, then consider whether the fix generalizes. Invokes /interview inline if root-cause hypotheses keep failing. Hands off to /pr.
---

# /debug

Bug work. This skill is an alternative entry point to the workflow — it skips `/interview` and `/architect` because the problem shape is usually "code does X, it should do Y" and the architecture usually doesn't change. Chains into `/pr` → `/code-review` → `/address` → `/learn` like any other branch.

## Phase 1 — Reproduce (non-negotiable)

Do not attempt a fix without a reproduction. "I think I know what's wrong" is not a reproduction.

Require one of:
- A failing test that exercises the bug.
- A minimal command that triggers the failure on demand with the failure output.
- A trace / log / error message with enough detail to identify the call path.

If the user has not provided a reproduction, ask for one. If it cannot be produced:
- Try to write a minimal failing test that targets the hypothesized behavior.
- If even that is impossible (e.g., the bug is in an external system or non-deterministic), tell the user this is not a bug-fix task — it is a research task — and stop. Offer to re-enter as `/interview` to scope the research.

Lock the reproduction in: commit the failing test first if feasible (as a separate commit with a `test: reproduce <bug>` message, skipped with `.skip` or `.failing` annotation so CI stays green).

## Phase 2 — Root-cause trace

Starting from the failure site, walk outward through the call graph. For each frame, state what it assumed and what was actually true. Ground library/API behavior with context7 or gh_grep if uncertain.

Maintain a short list of hypotheses. For each:
- State the hypothesis.
- State the experiment that would confirm or kill it.
- Run the experiment.

**Three-strike rule.** If you have three failed hypotheses, stop guessing. Your model of the bug is wrong. Invoke `/interview` inline: have the user walk you through what they know, what they've tried, and what they assume. Do not continue guessing.

Do not swallow errors. Every error observed during the trace is signal — quote it verbatim in your notes.

## Phase 3 — Fix

Make the minimal change that addresses the root cause. Not the surrounding cleanup. Not the tempting refactor. One focused fix.

Verify:
1. The failing test from Phase 1 now passes.
2. All other tests still pass.
3. The bug cannot be triggered by the original reproduction command.

Commit:

```
fix: <one-line summary>

<short paragraph explaining the root cause>
<short paragraph explaining why this fix addresses it>

Refs #<issue> (if an issue exists)
```

If no issue exists yet and the bug is worth tracking, consider running `/issue` for the architecture of the fix. For trivial fixes, skip the issue — the commit message is enough.

## Phase 4 — Generalize

Ask: is this fix preventing one instance of a class of bugs? Examples:
- "This null check should exist at every boundary of this type."
- "This race condition pattern is likely elsewhere."
- "This API misuse suggests our wrapper is shallow."

If yes, note the pattern in conversation. `/learn` will pick it up.

If the generalization implies a broader change, do NOT bundle it here. File a follow-up issue via `/issue`. Keep the bug fix small.

## Output

Print the fix commit SHA and a one-line summary. Then end with exactly this line and stop:

> Bug fixed. Run `/pr` to open the pull request.

## Rules

- **No fix without a reproduction.** Hardest rule; the one that makes this skill worth having.
- **Three-strike rule.** Three failed hypotheses means your model is wrong — invoke `/interview`, don't guess a fourth.
- **One fix per commit.** No drive-by cleanup. Drive-by cleanup hides the fix in the diff.
- **Swallowed errors are never okay.** Every error observed during the trace gets quoted in your notes.
