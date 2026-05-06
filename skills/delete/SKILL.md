---
name: delete
description: "Mandatory deletion pass after /refactor, before /test-plan. Finds obsolete, duplicated, misleading, unreachable, unused, speculative, or harmful code/docs/tests/config/API paths and defines safe removal or issue candidates. Use when the user types /delete, when adding a feature should expose obsolete affordances, or when a leftover path is being cargo-culted. Writes 17-delete.md and hands off to /test-plan."
---

# /delete

Deletion is a design activity. Every leftover obsolete path is an affordance future contributors and agents will use. Adding a feature is the right time to remove what it replaces.

## When this fires

- The user types `/delete`
- A new feature is replacing an old code path, doc, example, or flag
- A leftover helper or compat shim is being cargo-culted into hot paths
- A reviewer asks "what does this change replace?"

## Position in the workflow

Previous: `/refactor`. Next: `/test-plan`. See `/compound-workflow`.

This phase is **required** in every run, not optional. If nothing is deletable, write a "not applicable" artifact with the searches that were run and the evidence that confirms nothing exists. Silence is not an answer.

## Preconditions

- The architecture, refactor, and feature scope are concrete
- The repo is searchable (`rg`, `ast-grep`, `gh code-search` available)

## Stance

Apply the deletion field guide from `/core-field-guides`. Apply `/game-theory`: a leftover is an affordance; the next contributor will use it because it is cheap. Make the bad path impossible (delete), loud (deprecate with a runtime warning), or recoverable (mark, isolate, schedule removal).

## Search procedure

For each candidate type, run the corresponding searches and cite results:

1. **Dead code** — exports with no callers (`rg "export "`, then check importers; `ts-prune` / `knip` if available)
2. **Duplicate paths** — two implementations of the same concept (`/dedupe` artifact)
3. **Stale docs** — docs that mention removed or deprecated APIs (`rg "<deprecated-name>" docs/`)
4. **Misleading examples** — examples that demonstrate the old way (`rg "<old-pattern>" examples/`)
5. **Compatibility shims** — `compat/`, `legacy/`, `deprecated/`, `oldX`, `XV1`
6. **Old flags / configs** — feature flags whose behavior is now default (`rg "FEATURE_" .` then check rollout state)
7. **Unused tests** — tests for removed code (often pass trivially)
8. **Agent-hostile examples** — examples that future agents will copy into the wrong context
9. **Old types / errors / schemas** — superseded but still re-exported
10. **Old CI / scripts / Make targets** — referencing removed paths

## Required output

Write `<run-dir>/17-delete.md`:

### 1. Inventory
Table per candidate:

| Path | Kind | Last touched | Callers / referrers | Recommendation |
|---|---|---|---|---|

Recommendation ∈ { delete, deprecate-with-warning, hide-from-public-surface, schedule-removal, keep-with-justification }.

### 2. Deletion plan
For each `delete`:

- usage proof (rg / IDE / test pass without it)
- compatibility proof (no consumer depends on observable behavior — Hyrum's Law check)
- migration path for any remaining consumer
- the smallest commit that deletes it cleanly

### 3. Deprecation plan
For each `deprecate-with-warning`:

- runtime warning text (instructs the fix)
- removal date / version
- doc updates
- follow-up issue to remove on schedule

### 4. Stale doc removal
Docs and examples to update or delete, with concrete edits.

### 5. Issues captured
Out-of-scope deletions queued per `/issue-capture`. Each candidate has a "risk if ignored" entry naming the bad equilibrium.

### 6. Verification
How the deletion is proved safe:

- type-check passes
- test suite passes
- agent-relevant searches turn up no remaining references
- any external consumer notified

### 7. Handoff
Block per `/artifact-protocol`, pointing at `/test-plan`.

## Rules

- Deletion is required; "not applicable" needs evidence.
- Every deletion has a usage proof and a compatibility proof.
- Stale docs / examples / tests are deleted alongside the code they describe.
- Deprecations have a removal date.
- Hidden compat shims still count as affordances.
- "We might need it later" is not a justification.

## Anti-patterns

- Renaming dead code instead of deleting it.
- Leaving "// TODO: remove after migration" comments without a follow-up issue.
- Hiding a path from docs but keeping it exported.
- Deleting code without deleting its tests.
- Skipping the search step ("I can't think of anything to delete").

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Deletion), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Hyrum's Law, Fowler, Tidy First).

## Final response

End with exactly:

> Deletion pass complete. Continue to `/test-plan`.
