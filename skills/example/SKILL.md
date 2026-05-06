---
name: example
description: "Create and validate canonical examples after /docs, before /pr. Ensures every public API, SDK, CLI, config, error, and framework workflow has executable happy-path and failure-path examples that future agents will copy verbatim. Use when the user types /example, when a public surface changed, or when an example is suspected to drift from the docs. Writes 24-example.md and hands off to /pr."
---

# /example

The canonical example is what the next agent or developer will copy. It must be the right one. This phase makes sure every public surface has one — and only one — canonical example, validated by execution.

## When this fires

- The user types `/example`
- A public API, SDK, CLI, config, error, or workflow changed in `/work`
- An old example demonstrates a now-deprecated path
- A reviewer asks "where is the canonical usage?"

## Position in the workflow

Previous: `/docs`. Next: `/pr`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/10-interface.md` defined the public surface
- `<run-dir>/23-docs.md` updated the docs
- An `examples/` (or equivalent) location is established or being established

## Stance

Apply `/game-theory`: future agents will copy whatever they see first. The canonical example must be the right shape, name the right invariants, use the public surface only, and demonstrate the recovery for each failure path. Anti-examples — wrong patterns left in the repo — are an attractor and must be deleted.

## Required examples

For each public surface, ensure the following exist and run:

### 1. Happy-path example
- Smallest call site that produces the contract's success state
- Imports public surface only
- Output is observable (printed, asserted, or screenshot-captured)

### 2. Failure-path example
- One example per typed error from `/interface`
- Demonstrates the recovery instruction the error carries
- Output shows the error and the fix being applied

### 3. Configuration example
- Each non-trivial config option with a one-line comment
- Validation failure shown with the recovery path

### 4. Integration example (when relevant)
- Smallest example that composes two or more public surfaces
- Demonstrates the canonical seam between them

### 5. Workflow example (for frameworks / SDKs)
- A real task, end to end, using only documented entry points

## Validation

Each example is **executed** as part of this phase:

- Codeblocks in docs run via doctest / mdx-test / a build script
- Standalone examples run via the project's example runner
- Output is captured into the artifact

Failures here block `/pr`. An example that does not run is not an example.

## Required output

Write `<run-dir>/24-example.md`:

### 1. Example inventory
| Surface | Example kind | Path | Runs? | Output evidence |
|---|---|---|---|---|

### 2. Anti-example removals
Old examples deleted because they demonstrated a deprecated or removed path. Sourced from `/delete`.

### 3. Canonical example references
For each public symbol, the one example the docs link to.

### 4. Validation log
The commands run to validate each example, and their outputs.

### 5. Open issues
Example gaps captured per `/issue-capture`.

### 6. Handoff
Block per `/artifact-protocol`, pointing at `/pr`.

## Rules

- Every public surface has one canonical example.
- Every example imports public surface only.
- Every typed error has a failure-path example with the recovery shown.
- Every example runs in this phase; failures block `/pr`.
- Anti-examples are deleted, not left for "context".
- Examples are agent-readable: short, named, self-contained.

## Anti-patterns

- An example that imports `../../src/internal/...`.
- "See test fixtures for usage" — fixtures are not examples.
- Multiple competing examples for the same surface.
- Examples that have not been run since the API changed.
- Example output that is described in prose rather than captured.

## Composition

References: `/interface`, `/delete`, `/docs`, `/core-field-guides` (DX, AX), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Bloch, Diátaxis, Hyrum's Law).

## Final response

End with exactly:

> Examples validated. Continue to `/pr`.
