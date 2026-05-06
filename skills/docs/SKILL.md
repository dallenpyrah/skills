---
name: docs
description: "Update documentation after /verify, before /example. Applies the Diátaxis structure (tutorials, how-to, reference, explanation), updates README/quickstart/guides/reference/architecture/troubleshooting/migration/errors/config, and aligns AGENTS / CLAUDE files. Use when the user types /docs, when behavior or interfaces changed, or when stale docs are blocking agent or developer onboarding. Writes 23-docs.md and hands off to /example."
---

# /docs

Documentation is the agent and developer interface. This phase updates it deliberately so the next contributor (human or agent) finds the canonical path first.

## When this fires

- The user types `/docs`
- Behavior, interfaces, or configuration changed in `/work`
- Stale docs are blocking onboarding or being cargo-culted by agents
- `/learn` flagged a doc gap from a prior run

## Position in the workflow

Previous: `/verify`. Next: `/example`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/22-verify.md` reports the change behaves as designed
- The repo has a docs directory or README convention to update

## Stance

Apply Diátaxis: tutorials teach, how-to solves a task, reference describes, explanation justifies. Each doc has one purpose; mixing them is the most common doc smell. Apply `/core-field-guides` AX/DX: the canonical example must lead; private internals must not appear in examples; errors must instruct the recovery.

## Diátaxis quadrants (apply only those in scope)

### Tutorials (learning-oriented)
- Goal: take a beginner from zero to a working example
- Stable, success-guaranteed, narrative
- Update when: a tutorial referenced an interface you changed

### How-to (task-oriented)
- Goal: accomplish a specific task
- Recipe, no narrative
- Update when: a task pattern changed or a new task surface was added

### Reference (information-oriented)
- Goal: precise, exhaustive description of an interface
- Generated where possible (TypeDoc, OpenAPI, schema)
- Update when: any public surface changed

### Explanation (understanding-oriented)
- Goal: justify design decisions, name trade-offs
- Update when: an architecture decision, invariant, or trade-off was named in the run

## Required updates

For each item below, the artifact records what changed and why (or "no change" with evidence).

- README — front door, links, status
- Quickstart — happy-path setup that runs on a fresh machine
- Guides (how-to) — task recipes that touch the changed surface
- Reference — generated or hand-written, must match the actual API
- Architecture notes — the decision and trade-off from `/architect`
- Troubleshooting — common errors and the fix, sourced from `/interface` error model
- Migration — required when `/contract` named a compatibility break
- Error catalog — every typed error, when it fires, and how to recover
- Config reference — every config field, validation authority, default, env var
- AGENTS / CLAUDE files — repo-local agent instructions if conventions changed

## Required output

Write `<run-dir>/23-docs.md`:

### 1. Doc change matrix
| Doc | Quadrant | Change | Why |
|---|---|---|---|

### 2. Canonical examples
Confirm each public surface from `/interface` has one canonical usage example, and it is the one shown in the docs. (The full example pass happens in `/example`.)

### 3. Stale-doc removal
Docs deleted because they described removed behavior, or replaced because they described old behavior. Sourced from `/delete`.

### 4. AGENTS alignment
If conventions changed, AGENTS / CLAUDE files updated. Cite the diff.

### 5. Doc tests / linters
- Link checks, signature checks, codeblock-execution checks where supported
- Result of each

### 6. Open issues
Doc gaps captured per `/issue-capture`.

### 7. Handoff
Block per `/artifact-protocol`, pointing at `/example`.

## Rules

- Each doc has one Diátaxis purpose.
- Reference docs match the actual interface (generated where possible).
- Errors in the catalog instruct the recovery.
- Configuration fields name their validation authority.
- AGENTS files do not contradict tests or canonical examples.
- Stale docs are deleted, not left "for context".

## Anti-patterns

- "API reference" sections that are out of date.
- Tutorial that imports private modules.
- README claims that the verification could not prove.
- Multiple competing how-tos for the same task.
- Removing a feature without removing its doc.

## Composition

References: `/interface`, `/delete`, `/verify`, `/core-field-guides` (DX, AX), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Diátaxis).

## Final response

End with exactly:

> Docs updated. Continue to `/example`.
