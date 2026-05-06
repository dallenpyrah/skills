---
name: dependency
description: "Map and constrain dependency direction after /boundary, before /dedupe. Checks imports, package graph, external libraries, cycles, framework leakage, and folder/package sizing. Use when the user types /dependency, when boundaries are locked and the import graph needs verification, or when a circular dependency / framework leak / wrong-direction import is suspected. Writes 07-dependency.md and hands off to /dedupe."
---

# /dependency

Architecture stays alive only if dependency direction does. This phase audits imports against the boundaries set in `/boundary`.

## When this fires

- The user types `/dependency`
- `/boundary` is locked and the actual import graph needs verification
- A circular dependency, layer violation, or framework leak is suspected
- A new external dependency is being added and needs justification

## Position in the workflow

Previous: `/boundary`. Next: `/dedupe`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/06-boundary.md` exists with boundary inventory
- `package.json` / lockfile / module manifests exist for the languages used

## Stance

Direction is the discipline. Apply `/first-principles` (which dependency is irreducible) and `/game-theory` (what shortcut a contributor takes when the rule is unenforced).

## Required output

Write `<run-dir>/07-dependency.md`:

### 1. Internal dependency map
A diagram or list of which modules import which. Cycles flagged. Layer violations flagged.

### 2. Direction rules
For each layer pair, which direction is allowed:

- domain ← application ← interface ← infrastructure (typical)
- core ← shell (functional core / imperative shell)
- public ← private (never the reverse)

Each rule has its enforcement mechanism: lint rule, build check, package export, type fence.

### 3. External dependencies
Table:

| Package | Version | Used by | Replaceable? | Risk | Justification |
|---|---|---|---|---|---|

Risk = supply-chain, license, abandonment, security advisory, version drift. Justification cites the invariant or capability the dependency provides.

### 4. Framework / vendor leakage
Where do framework or vendor types appear outside their adapter? Each leak has a cost (lock-in, test friction, replacement risk) and a fix (port at the boundary).

### 5. Source-of-truth ownership
Each shared concept (config schema, error type, ID format, event shape) named, with which module owns it. Multiple-owner concepts are decay; flag them.

### 6. Folder / package sizing
Folders and packages that violate the cohesion test from `/core-field-guides` (catch-all, ceremonial, mis-located). Each gets a smallest-fix proposal.

### 7. Cycle and violation report
For each cycle or violation:

- detection command (`madge`, `dependency-cruiser`, `eslint-plugin-import`, `tsc --noEmit`, custom script)
- evidence (output)
- root cause (which boundary leaked)
- fix (extract, invert, port, delete)

### 8. Open issues
Violations that cannot be fixed in this run, captured per `/issue-capture`.

### 9. Handoff
Block per `/artifact-protocol`, pointing at `/dedupe`.

## Rules

- Every layer pair has a documented direction.
- Every external dependency has a one-sentence justification.
- Cycles are not acceptable; either invert or extract.
- Framework types do not cross out of the adapter.
- Multiple owners of one concept is a `/dedupe` candidate.

## Anti-patterns

- "We need this dependency" without naming the invariant or capability it provides.
- A `utils/` or `common/` folder used as a dependency sink.
- Tests that import private internals to bypass the public API.
- Type fences enforced only by hope.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Boundaries, Folder architecture), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Parnas, Bloch, Hyrum's Law).

## Final response

End with exactly:

> Dependencies audited. Continue to `/dedupe`.
