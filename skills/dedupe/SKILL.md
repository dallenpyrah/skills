---
name: dedupe
description: "Search for existing sources of truth after /dependency, before /state-model. Finds duplicate concepts, modules, helpers, schemas, config, errors, state, docs, tests, examples, and conventions, then proposes consolidation or deletion. Use when the user types /dedupe, when a new module is about to be created, or when a duplicated concept is suspected. Writes 08-dedupe.md and hands off to /state-model."
---

# /dedupe

Before adding new code, prove that no existing source of truth already does the job. Duplication is the most common cause of long-term decay.

## When this fires

- The user types `/dedupe`
- A new module, helper, schema, error type, or config is about to be created
- A duplicated concept is suspected (two parsers, two error hierarchies, two config formats, two examples)
- A reviewer asks "is this already done somewhere?"

## Position in the workflow

Previous: `/dependency`. Next: `/state-model`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/07-dependency.md` named source-of-truth ownership
- The proposed new code (or area of new code) has a candidate name

## Stance

Apply `/first-principles` (what is irreducible vs derived) and `/game-theory` (the local shortcut is to copy-paste; the global cost is divergent behavior). Default to consolidation.

## Search procedure

For each new concept proposed, run:

1. **Exact-name search** — `rg "<Name>"`, `rg "<name>"`, `rg "<NAME>"`.
2. **Synonym search** — common renames, abbreviations, prefixed/suffixed forms.
3. **Responsibility search** — what the concept does (verbs from the contract).
4. **Type-shape search** — for code: `ast-grep -p '<shape>'` for the structure.
5. **Schema search** — JSON Schema, Zod, Effect Schema, Protobuf, OpenAPI definitions for similar shapes.
6. **Error search** — error class names, error codes, status enums.
7. **Doc search** — docs and learnings that already describe the behavior.
8. **Example / test search** — test names, fixtures, example folders.
9. **Convention search** — AGENTS / CLAUDE / README files with naming conventions.

Cite results. Empty searches are also evidence; record them.

## Required output

Write `<run-dir>/08-dedupe.md`:

### 1. Concept inventory under audit
Each new concept proposed by `/architect` or `/contract`, with the exact name, responsibility, and one-sentence purpose.

### 2. Existing sources of truth found
For each match:

- where it lives (file:line)
- what it does
- delta vs the new concept ("identical", "subset", "superset", "diverges in <ways>")
- recommendation: reuse / extend / merge / replace / coexist (with reason)

### 3. Duplicate sources of truth detected
Concepts that already have multiple owners. Each has:

- evidence (file paths)
- divergence (where they disagree)
- consolidation plan (which one wins, migration path)
- risk if consolidated incorrectly
- whether consolidation belongs in this run or in `/issue-capture`

### 4. Convention conflicts
Where AGENTS / CLAUDE / README / examples disagree. Each conflict named, with a proposal for which wins.

### 5. New code justified
For new concepts that survive the audit, the artifact records the one-sentence reason no existing source of truth fits.

### 6. Issue candidates
Duplicates that are real but out of scope, captured per `/issue-capture`.

### 7. Handoff
Block per `/artifact-protocol`, pointing at `/state-model`.

## Rules

- Search before create. Always.
- Consolidation is the default; coexistence requires a stated reason.
- Cite or do not claim.
- One-sentence justification for every new module / helper / schema / error type.
- Convention conflicts get resolved here, not later.

## Anti-patterns

- "I couldn't find it" without showing the searches.
- Adding `utils/<thing>` next to an existing `helpers/<thing>` because the search was lazy.
- Two error hierarchies for the same domain.
- A new schema that is 90% of an existing one with minor tweaks.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Boundaries, Refactoring, Deletion), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Tooling: `rg`, `ast-grep`, `gh code-search`, IDE symbol search.

## Final response

End with exactly:

> Dedupe complete. Continue to `/state-model`.
