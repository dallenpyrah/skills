---
name: debug
description: Standalone bug-investigation entry point. Requires a reproduction, traces root cause with hypotheses and experiments, analyzes the bug from first principles and game theory, implements the minimal fix, verifies the original reproduction and regression test, then records whether the fix generalizes. Invokes /interview inline after three failed hypotheses. Hands off to /pr.
---

# /debug

Investigate and fix a bug.

This skill is an alternative workflow entry point. It skips `/interview` and `/architect` only when the problem shape is already: “the code does X, but it should do Y.”

Do not redesign the system unless the bug proves the architecture is wrong.

## Preconditions

- You are inside the target repository.
- The working tree is clean unless the user explicitly says the uncommitted changes are part of the bug context.
- If a PR already exists for the current branch, note it, but do not post a review.
- If the bug belongs to an existing issue, capture the issue number.
- If the user provides logs, traces, screenshots, or commands, preserve exact text. Do not paraphrase errors during the trace.

## Phase 0 — Classify

Before touching code, classify the task:

- **Bug fix:** observed behavior differs from expected behavior and can be reproduced.
- **Research:** behavior is unclear, external, intermittent, or not reproducible yet.
- **Architecture change:** the fix requires a new module boundary, state model, port, migration, or broader design.

If this is research, stop and recommend `/scout` or `/interview`.
If this is architecture, stop and recommend `/interview` → `/architect`.
If this is a bug fix, continue.

## Phase 1 — Reproduce

No fix without a reproduction.

Require at least one:

1. Failing test.
2. Minimal command that triggers the failure on demand.
3. Trace/log/error message with enough detail to identify the call path.
4. Deterministic local reproduction created by you from the reported behavior.

A valid reproduction must include exact command/test, exact failure output, expected behavior, actual behavior, relevant environment, and the smallest input known to trigger the bug.

If the user did not provide a reproduction, try to create one, search existing tests, write the smallest failing test or command, and stop if still impossible.

### Regression test rule

Prefer to create a regression test before the fix. You may commit a failing test first when branch policy allows, use expected-failure conventions only if the repo already uses them and CI remains green, or keep the failing test uncommitted until the fix. Do not pretend a skipped test proves the bug.

## Phase 2 — First-principles trace

Start at the failure site and walk outward through the call graph.

For each relevant frame or module, record:

```text
Frame/module:
Invariant:
Assumed:
Actually true:
Evidence:
```

Reduce the bug to broken invariant, incorrect assumption, missing boundary validation, invalid state, wrong source of truth, wrong dependency direction, unmodeled effect, hidden fallback, missing synchronization, or library/API misunderstanding.

## Phase 3 — Game-theoretic bug diagnosis

Ask what incentive or mechanism allowed the bug.

Record:

```markdown
## Game-theory diagnosis
- Player:
- Local incentive:
- Hidden information:
- Bad move made easy:
- Good move made expensive:
- Bad equilibrium:
- Mechanism needed:
```

Examples:

- Caller was incentivized to pass raw input because validation was far away.
- Maintainer was incentivized to add another boolean because lifecycle state had no state machine.
- Adapter author was incentivized to catch-and-continue because errors were not typed.
- Reviewer could not see the risk because tests mocked away the dangerous behavior.
- Future implementer duplicated knowledge because no single source of truth existed.

## Phase 4 — Hypotheses and experiments

Maintain a hypothesis ledger:

```markdown
| # | Hypothesis | Experiment | Result | Status |
|---|---|---|---|---|
| 1 | ... | ... | ... | confirmed/killed/open |
```

Rules:

- One hypothesis per experiment.
- Prefer experiments that can kill a hypothesis.
- Quote errors verbatim.
- Inspect source, tests, package code, or official docs when behavior is uncertain.
- Use `git bisect` when the bug is a regression and good/bad commits are known.
- Use logs/traces only to narrow the search; confirm with code or tests.

### Three-strike rule

After three killed hypotheses, stop guessing.

Invoke `/interview` inline and ask the user what they know, what changed recently, what they tried, what assumptions they hold, and what “correct” means.

Do not continue with a fourth guess until the model changes.

## Phase 5 — Fix

Make the smallest change that addresses the root cause.

Rules:

- One fix per commit.
- No drive-by cleanup.
- No opportunistic refactor.
- No unrelated formatting.
- No hidden fallback.
- No swallowed errors.
- No broad `try/catch`.
- If using Effect-owned code, use Effect primitives and typed errors.
- Recovery is allowed only when explicit, typed, observable, and tested.
- If the right fix is architectural, stop and hand off to `/interview` → `/architect`.

Before editing, state:

```markdown
## Root cause
<one paragraph>

## Minimal fix
<one paragraph>

## Mechanism change
<how this prevents the same local bad move>

## Why not broader
<one paragraph>
```

Then implement.

## Phase 6 — Verify

Run verification in this order:

1. Original reproduction fails before the fix or has already been proven to fail.
2. Regression test passes after the fix.
3. Original command/input no longer triggers the bug.
4. Relevant existing tests pass.
5. Error path introduced or touched by the fix is tested.
6. No lint/type errors for the changed surface.
7. No new silent fallback or swallowed error was introduced.
8. The bad local move is now impossible, expensive, or loud.

Record exact commands and outcomes.

If verification fails, return to Phase 2. Do not stack fixes blindly.

## Phase 7 — Commit

Commit only the bug fix and its regression test.

Commit message:

```text
fix: <one-line summary>

Root cause: <short paragraph explaining the wrong assumption or broken invariant>.

Fix: <short paragraph explaining why this change addresses the root cause>.

Mechanism: <short paragraph explaining how this makes recurrence harder or louder>.

Verification:
- <command> — <result>
- <command> — <result>

Refs #<issue>   # only when an issue exists
```

If a failing reproduction was committed separately, use `test: reproduce <bug>` first.

## Phase 8 — Generalize

Ask whether the root cause is one instance of a broader class: missing boundary validation, recurring race, invalid state representable, shallow wrapper hiding a bug, missing port, bad fallback/default, brittle mock, untested error path, library/API misuse, migration inconsistency, or local incentive misaligned with global correctness.

If yes, note the pattern, do not bundle the broader fix, create or recommend a follow-up issue through `/issue`, and leave durable learning for `/learn`.

## Output

Print:

```text
fix_commit=<sha>
summary=<one-line summary>
reproduction=<command or test>
verification=<commands run>
generalization=<none or short pattern>
mechanism_change=<how recurrence was made harder/louder>
```

Then end with exactly this line and stop:

> Bug fixed. Run `/pr` to open the pull request.

## Hard rules

- No fix without reproduction.
- Three failed hypotheses means stop and interview.
- One fix per commit.
- No drive-by cleanup.
- Swallowed errors are never okay.
- Exact errors must be quoted.
- Do not silently fall back.
- Do not use architecture work as a bug-fix shortcut.
- Fix the mechanism when the bug was caused by bad incentives.
