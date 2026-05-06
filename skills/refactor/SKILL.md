---
name: refactor
description: "Plan behavior-preserving structural cleanup after /observability, before /delete. Separates structure from behavior, reduces complexity, prepares seams for the new feature, and proves behavior is preserved. Use when the user types /refactor, when adding a feature would be cheaper after a structural cleanup, or when a smell is blocking the next change. Writes 16-refactor.md and hands off to /delete."
---

# /refactor

Refactoring is a behavior-preserving structural change with a stated cost reduction. This phase plans it.

## When this fires

- The user types `/refactor`
- The new feature would be substantially cheaper or safer after a structural cleanup
- A code smell (duplication, deep coupling, leaky abstraction) is blocking the next change
- A reviewer asks "tidy first, or feature first?"

## Position in the workflow

Previous: `/observability`. Next: `/delete`. See `/compound-workflow`.

## Preconditions

- Cross-cutting decisions from `/concurrency`, `/security`, `/performance`, `/observability` are in evidence
- The smell is concrete and citable (file paths, duplicated code, contended state)

## Stance

Apply the refactoring field guide from `/core-field-guides`. Tidy first only when it shrinks the cost or risk of the next change (Beck). Otherwise capture the cleanup as an issue and move on.

Always separate structure from behavior. Never bundle.

## Required output

Write `<run-dir>/16-refactor.md`:

### 1. Smell inventory
For each smell:

- name (one of: duplication, deep coupling, leaky abstraction, primitive obsession, status booleans, broad helper, manager / service, untyped error, dead code surface, agent-hostile example)
- evidence (file:line)
- cost it imposes on the next change (concrete, not "feels bad")
- whether refactoring now is cheaper than refactoring later

### 2. Refactor plan
For each smell to fix in this run:

- target structure (named, derivable from `/architect`)
- step sequence (small, behavior-preserving)
- safety proof (existing test coverage, characterization tests to add, type signatures, manual verification)
- rollback plan if a step breaks behavior

### 3. Out-of-scope smells
Smells that are real but not addressed in this run, captured per `/issue-capture`.

### 4. Sequencing
Refactor steps that must precede the new feature, vs steps that may follow. Sequence stated explicitly.

### 5. Behavior-preservation proof
For each refactor:

- characterization tests added (with names that route to `/test-plan`)
- types or schemas that pin behavior
- snapshot / golden tests where appropriate
- manual verification commands

### 6. Risk
What could break that the safety proof would miss. Mitigation strategy.

### 7. Open issues
Captured per `/issue-capture`.

### 8. Handoff
Block per `/artifact-protocol`, pointing at `/delete`.

## Rules

- Structure changes and behavior changes never share a commit.
- Every refactor states its smell and the cost it removes.
- Behavior preservation is proved, not assumed.
- Refactor for the next change, not for "cleanliness".
- Pattern compliance is not a smell on its own.

## Anti-patterns

- "Let's also clean up X while we're in here" without a sequencing argument.
- Refactor with no characterization tests and no type changes.
- Renames presented as refactors when behavior changes.
- Replacing one shallow abstraction with another.
- Refactoring code that is about to be deleted.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Refactoring, Deletion), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Fowler, Beck Tidy First, Ousterhout deep modules).

## Final response

End with exactly:

> Refactor plan ready. Continue to `/delete`.
