---
name: boundary
description: "Lock module, package, folder, service, trust, and agent boundaries after /architect, before /dependency. Defines public surface, private internals, allowed/forbidden crossings, error/telemetry crossings, and enforcement (export rules, lint rules, type fences). Use when the user types /boundary, when modules from /architect need explicit interfaces, or when a leak is suspected. Writes 06-boundary.md and hands off to /dependency."
---

# /boundary

A boundary is only useful when it hides a volatile decision, protects authority, preserves an invariant, or stops dependency leakage. This phase makes each boundary explicit and enforceable.

## When this fires

- The user types `/boundary`
- `/architect` named modules and they need explicit public/private surfaces
- A leak is suspected (callers reaching into internals, helper used as public API)
- A trust boundary or agent boundary needs to be named

## Position in the workflow

Previous: `/architect`. Next: `/dependency`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/05-architect.md` exists with named modules and ports
- The invariants each module protects are nameable

## Stance

Apply the boundary field guide from `/core-field-guides` and `/game-theory` (which actor benefits from each crossing). A boundary that does not enforce a specific invariant or hide a specific decision is decorative.

## Required output

Write `<run-dir>/06-boundary.md`:

### 1. Boundary inventory
Table for each boundary in the system:

| Boundary | Type | Public surface | Private internals | Invariant protected | Enforcement |
|---|---|---|---|---|---|

Type ∈ { module, package, folder, service, trust, agent, network, process }.

Public surface is the few exports (functions, types, schemas, constructors) intended for callers. Private internals are everything else.

### 2. Allowed crossings
For each boundary, name which directions are allowed and which actors may cross. Cite the invariant each crossing preserves.

### 3. Forbidden crossings
List explicitly. Each forbidden crossing has:

- what would be tempting to do
- why it is forbidden (which invariant it would break)
- how the crossing is prevented (export visibility, lint rule, type fence, capability, runtime check)

### 4. Error and telemetry crossings
Which errors cross which boundaries, in what shape (typed error, structured log, span event). Sensitive data redaction rules. Cross-reference `/observability` for the full signal plan.

### 5. Trust boundaries
Where untrusted input enters: HTTP, DB, queue, filesystem, vendor SDK, user input, model output. Each trust boundary names its validation authority (schema, parser, sanitizer) and what fails closed.

### 6. Agent boundaries
Where coding agents and runtime agents may act: shell exec, file write, model call, tool use. Each agent boundary names allowed tools, capability scope, and audit signal.

### 7. Enforcement mechanisms
Which mechanism is used per boundary. Possibilities:

- package exports / index files
- ESLint / Biome import rules
- TypeScript `private` / `protected` / module fences
- Effect Layer scoping
- Runtime capability tokens
- Test fixtures that reject forbidden imports
- Build-time dependency-graph checks

### 8. Open issues
Boundaries that the codebase cannot enforce yet, with the smallest mechanism that would.

### 9. Handoff
Block per `/artifact-protocol`, pointing at `/dependency`.

## Rules

- Every boundary has an invariant.
- Every boundary has an enforcement mechanism.
- "Folder boundary" is not a boundary unless imports are constrained.
- A boundary that everyone bypasses is not a boundary.
- Trust and agent boundaries are first-class, not afterthoughts.

## Anti-patterns

- Public option bags that bypass policy.
- Private internals re-exported through a "convenience" file.
- Trust boundary that depends on convention rather than validation.
- Telemetry that exfiltrates secrets across an audit boundary.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Boundaries, Folder architecture), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Parnas, Liskov, Saltzer & Schroeder).

## Final response

End with exactly:

> Boundaries locked. Continue to `/dependency`.
