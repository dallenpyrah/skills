---
name: architect
description: Re-derive the simplest, cleanest architecture for the problem from first principles. Deep modules, narrow interfaces, state machines for lifecycle, ports & adapters for I/O, Effect-first for effectful paths. Runs after /interview has established the core shape of the problem and the user's solution direction. If /scout was not run first, performs deep grounding research before designing so missing edge cases surface here. Uses shelf, repo search, node_modules source, official docs, exa, context7, and gh_grep as applicable. Produces an architecture proposal in conversation context — no files. Hands off to /review.
---

# /architect

Re-derive the architecture from the problem and constraints alone. Do not anchor on the user's initial solution sketch unless it survives first-principles scrutiny.

## Principles (non-negotiable)

Citations for these rules are in `AGENTS_sources.md` at the root of this devbox repo. If a proposed architecture violates one, either change the architecture or state the deliberate trade-off out loud.

- **Deep modules over shallow ones.** Narrow interface, powerful implementation. A wrapper that just forwards gets deleted.
- **Don't complect.** State separate from value. Transport separate from logic. Storage separate from query.
- **Push state to the edges.** Keep the core pure.
- **Prefer state machines for anything with lifecycle.** Explicit states and transitions over ad-hoc booleans and nullable fields.
- **Ports & adapters for I/O.** The logic owns the port; the transport is injected. The deep module is testable as a unit even when deployed across a network boundary.
- **Effect-first for effectful paths** (per `AGENTS.md`). Plain TS for pure transformations, type-level utilities, constants, and thin interop boundaries.
- **Name what it is, not what wraps it.** `Cache` beats `CacheManager`. `User` beats `UserEntity`. If two concepts share a name, they are complected.
- **Data beats behavior for portability.** Plain data travels cleanly between contexts; objects with implicit state do not.
- **Complexity is a budget.** Every net-new abstraction must hide something. If it hides nothing, delete it.

## Process

0. Confirm whether `/scout` ran for this problem. If it did not, do a scout-equivalent grounding pass before designing. Dig deep enough to find missing edge cases, not just enough to feel familiar:
   - Read the relevant repo code and tests; use ast-grep/rg for structural and text search.
   - Search `node_modules` or installed package source when the dependency is present locally; source beats memory.
   - Use `shelf` for cached reference repos and run `shelf detect` / `shelf list` / `shelf update` when reference code may clarify behavior.
   - Use context7 for documented API shape and valid options.
   - Use gh_grep for real-world usage patterns and migration gotchas.
   - Use exa for current docs, issue threads, release notes, and war stories when behavior may be version- or platform-specific.
   - Read official online documentation when the architecture depends on product semantics, limits, pricing, permissions, lifecycle, or security behavior.
   - Enumerate edge cases, lifecycle states, failure modes, existing conventions, and compatibility constraints found during grounding.
   Do not output a separate scout brief; fold the findings into the architecture.
1. Restate the problem in one sentence, from first principles. Do not carry forward the user's phrasing if it encodes a solution.
2. Enumerate constraints — what must remain true, including constraints and edge cases found during grounding.
3. Name the core trade-off in one sentence: "I am trading X for Y."
4. Derive the minimal architecture that satisfies the constraints. Draw a mermaid diagram of the runtime flow or module graph. If the change has lifecycle (anything with states like pending/active/closed/paid/etc.), also draw a `stateDiagram-v2`.
5. For each module, specify: responsibility, interface signature, what it hides, dependency category (in-process / local-substitutable / ports-and-adapters / true-external).
6. Write one paragraph explaining why this is the simplest version — what you considered and discarded and why.
7. State explicit non-goals.

If you cannot ground a decision (library behavior, API shape, existing code structure, external service semantics), stop and ground it using the strongest available source: repo code/tests, node_modules source, shelf reference repos, official docs, context7, gh_grep, exa, ast-grep, or Read. Do not guess.

## Output shape

Render your final message in chat using this structure, verbatim headings:

```
## Problem
<one sentence, first-principles>

## Constraints
<bullets — what must remain true>

## Core trade-off
<one sentence: "I am trading X for Y.">

## Architecture
<short prose — 1-2 paragraphs>

```mermaid
<flowchart or classDiagram>
```

<if lifecycle exists, add:>

```mermaid
<stateDiagram-v2>
```

## Modules
1. **<Name>** — responsibility. Interface: `<signature>`. Hides: <impl detail>. Dependency: <category>.
2. ...

## Why this is the simplest version
<one paragraph — what you considered and discarded>

## What this is NOT
<bullets — explicit non-goals>
```

Then end with exactly this line and stop:

> Architecture proposed. Run `/review` to pressure-test it before opening an issue.
