---
name: architect
description: "Derive the simplest architecture from first principles after /domain-model, before /boundary. Names the smallest mechanism that satisfies invariants, places state, defines ports/adapters, separates pure from effectful code, and shapes the lifecycle. Use when the user types /architect, when /domain-model is locked and modules need to be named, or when an existing design is being re-derived. Writes 05-architect.md and hands off to /boundary."
---

# /architect

Re-derive the simplest, cleanest architecture from the locked domain model. Enforce minimal code, composition, single source of truth, deep modules, narrow interfaces, functional core, lifecycle state machines, and ports/adapters at I/O boundaries.

## When this fires

- The user types `/architect`
- `/domain-model` is locked and modules need to be named
- An existing design is being re-derived against current constraints
- A reviewer asks "what is the smallest mechanism that satisfies these invariants?"

## Position in the workflow

Previous: `/domain-model`. Next: `/boundary`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/04-domain-model.md` exists
- `<run-dir>/03-contract.md` invariants and acceptance criteria are concrete
- If `/scout` did not run before `/interview`, perform scout-equivalent grounding here per `/scout` (cite repo evidence, official docs, installed source) before designing

## Stance

Derive, do not import. Resist analogy and pattern-shopping until the problem is named in plain terms. Apply `/first-principles` for the irreducible mechanism and `/game-theory` for the equilibrium the design rewards.

Default to:

- composition over abstraction
- one source of truth per concept
- deep modules with narrow interfaces (Ousterhout)
- functional core, imperative shell
- state machines for lifecycle
- ports / adapters at I/O boundaries
- typed errors with recovery instructions
- no silent fallbacks
- explicit irreversibility (idempotency, single-writer, or compensating actions)

If the project is Effect-first (see repo AGENTS), use Effect primitives in Effect-owned code; pure TypeScript in pure transformations.

## Required output

Write `<run-dir>/05-architect.md`:

### 1. Mechanism in one sentence
What the system does, in plain English, in one sentence. If you cannot, the design is not yet derived.

### 2. Architecture sketch
Prose + a single mermaid diagram (only if it conveys structure prose cannot). The sketch names modules, data flow, and the lifecycle.

### 3. Modules
For each module:

- one-sentence responsibility
- public surface (the few entry points)
- what it hides (the volatile decision)
- which invariant from `/contract` it protects
- pure vs effectful
- ownership of state (if any)

### 4. State placement
Where state lives, who writes it, who reads it. Persisted vs in-memory vs derived. Cross-reference `/state-model` for the full lifecycle.

### 5. Ports and adapters
External I/O surfaces (DB, HTTP, queue, filesystem, vendor SDK). For each:

- port (interface) name
- adapters that implement it
- invariants the port enforces
- failure model (typed errors)

### 6. Lifecycle and recovery
How the system starts, runs, fails, recovers, shuts down. State transitions named explicitly.

### 7. Trade-offs
The single core trade-off in one sentence ("trading X for Y because <constraint>"). The main alternative considered, and why this one wins.

### 8. Quality-attribute notes
Where each non-functional attribute is anchored (testability, observability, security, performance, reliability, agent navigability). Pointers, not full content; the cross-cutting skills (`/security`, `/performance`, `/observability`) own the detail.

### 9. Open questions
What remains uncertain. Each question routes to a specific later phase.

### 10. Handoff
Block per `/artifact-protocol`, pointing at `/boundary`.

## Rules

- The architecture must be derivable from `/contract` invariants and `/domain-model` concepts.
- One core trade-off named explicitly.
- No layer named "Manager", "Service", or "Helper" without justified responsibility.
- No silent fallbacks. No catch-and-ignore. No untyped errors.
- One writer per piece of state, or an explicit reconciliation mechanism.
- If the design needs more than one screen, it is hiding complexity. Decompose.
- No prose-only diagrams. Mermaid only when prose cannot convey the structural relationship.

## Anti-patterns

- Pattern-shopping ("let's use CQRS / hexagonal / event-sourcing") before naming the volatile decision.
- Designing for hypothetical future requirements.
- Wrappers that forward without hiding.
- Multiple sources of truth justified as "for performance" without measurement.
- Synchronous defaults that mask error budgets.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Boundaries, State, Concurrency, Refactoring), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Parnas, Ousterhout, Liskov, Hoare, Lamport, Harel).

## Final response

End with exactly:

> Architecture derived. Continue to `/boundary`.
