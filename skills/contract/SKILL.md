---
name: contract
description: "Freeze the engineering contract after /interview, before /domain-model. Locks problem, actors, invariants, non-goals, acceptance criteria, game-board, proof gates, compatibility, security, performance, docs, examples, and issue-capture obligations. Use when the user types /contract, when an interview is complete and design is about to start, or when a fuzzy intent needs to become a testable contract. Writes 03-contract.md and hands off to /domain-model."
---

# /contract

Freeze intent. Architecture against fuzzy intent is expensive theater; this phase prevents that by writing a contract that the rest of the chain proves against.

## When this fires

- The user types `/contract`
- `/interview` is complete (or grounding is equivalent and labeled `conversation-derived`)
- Design is about to start

## Position in the workflow

Previous: `/interview`. Next: `/domain-model`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/02-interview.md` exists, or its content has been reconstructed
- The user has confirmed the problem, invariants, constraints, non-goals, and acceptance criteria

If acceptance criteria are missing, return to `/interview` for one more round. Do not fabricate them.

## Stance

A contract is a testable promise. Every claim must either be verifiable now (test, type, command output) or labeled as a future proof gate. Apply `/first-principles` for invariants and `/game-theory` for the equilibrium the contract is trying to create.

## Required sections

The artifact at `<run-dir>/03-contract.md` must contain:

### 1. Problem
One sentence. Plain English. No jargon unless defined here.

### 2. Actors
Each player named, with what they can do, what they want locally, and the information they have or lack. (See `/game-theory`.)

### 3. Invariants
What must remain true after the change. Each invariant labeled with how it will be enforced: type, schema, test, runtime check, lint rule, or doc.

### 4. Non-goals
What this change explicitly will not do. Each non-goal has a one-line reason ("out of scope because <reason>") so a future reader does not relitigate.

### 5. Acceptance criteria
Numbered, testable, observable. Each one references how it will be verified in `/verify`.

### 6. Game board
Players, incentives, information asymmetries, bad local move, global cost, desired equilibrium, mechanism category to use (see `/game-theory`).

### 7. Proof gates
For each acceptance criterion and each invariant, the artifact lists:

- evidence type (command output, test, type-check, screenshot, log, metric, browser flow, computer-use flow, security check, benchmark, example)
- where the proof will live (test path, dashboard, doc)
- which phase produces it (`/test-plan`, `/work`, `/verify`, `/security`, `/performance`, etc.)

### 8. Compatibility
Versions, APIs, schemas, file formats, configs that must remain compatible. Migration paths if any.

### 9. Security baseline
Trust boundaries, sensitive data, threat model summary. Detail belongs in `/security`; this section names what cannot be missed.

### 10. Performance baseline
Budgets, SLOs, expected throughput, tail-latency expectations. Detail belongs in `/performance`.

### 11. Docs and examples obligations
What docs and which examples must exist or change for this to be agent- and human-usable (see `/core-field-guides` AX/DX sections).

### 12. Issue-capture obligations
Confirms the run will follow `/issue-capture` for unrelated decay.

### 13. Handoff
Block per `/artifact-protocol`, pointing at `/domain-model`.

## Rules

- One sentence per acceptance criterion.
- Each invariant labeled with its enforcement mechanism.
- Each non-goal labeled with its scope reason.
- No design choices yet (no module names, no concrete patterns).
- If the user disagrees with the contract, return to `/interview`.

## Anti-patterns

- "The system should be performant." — not a criterion. Replace with a budget or SLO.
- "Refactor the auth module." — not a contract. Replace with the invariant the refactor protects.
- Embedding implementation in invariants ("must use Redis"). Move to design phases.
- Skipping non-goals; they are how scope holds.

## Composition

References: `/first-principles`, `/game-theory`, `/artifact-protocol`, `/issue-capture`, `/core-field-guides`, `/compound-workflow`.

## Final response

End with exactly:

> Contract locked. Continue to `/domain-model`.
