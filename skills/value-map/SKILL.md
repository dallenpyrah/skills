---
name: value-map
description: "Connect each behavior to who it benefits, what destroys that value, and what the opportunity cost is. Runs after /interface, before /concurrency. Use when the user types /value-map, when scope-cutting decisions need a value rationale, or when a feature seems to lack a clear beneficiary. Writes 11-value-map.md and hands off to /concurrency."
---

# /value-map

A feature without a beneficiary is decoration. This phase makes the beneficiary, the failure cost, and the opportunity cost explicit.

## When this fires

- The user types `/value-map`
- Scope-cutting decisions need a value rationale
- A behavior is being justified by feature-completeness rather than who it serves
- A reviewer asks "what does this enable, and what would happen if it broke?"

## Position in the workflow

Previous: `/interface`. Next: `/concurrency`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/10-interface.md` defines the surface that delivers value
- Acceptance criteria from `/contract` are concrete

## Stance

Apply `/game-theory`: who benefits, who pays, what behavior is rewarded. Apply `/first-principles`: what is the irreducible value vs nice-to-have. Be honest about cost.

## Required output

Write `<run-dir>/11-value-map.md`:

### 1. Behavior inventory
Table:

| Behavior | Beneficiary | Value (one sentence) | If this breaks | Opportunity cost of building | Priority |
|---|---|---|---|---|---|

Beneficiary is a named role (end user, developer, agent, ops, support, finance, security, future maintainer). "If this breaks" names the user-visible consequence, not the symptom. Opportunity cost names what else this work displaces.

### 2. Value tiers
Group behaviors into:

- **Core** — the contract fails without this
- **Important** — value erodes meaningfully without this
- **Nice-to-have** — measurable but small benefit
- **Noise** — listed because it appeared in the contract; flag for `/contract` revision

### 3. Failure-mode value cost
For each Core / Important behavior, the artifact pairs the failure mode with the value cost:

- silent failure cost (worst — value lost without anyone noticing)
- loud failure cost (better — system surfaces and recovers)
- recoverable failure cost (best — system surfaces and self-heals or instructs)

This pairing routes work to `/concurrency`, `/security`, `/observability`, and `/test-plan`.

### 4. Opportunity-cost notes
What else the team / agent could be doing with the same effort. If the alternative is materially better, this is a `/contract` revision signal.

### 5. Cut candidates
Behaviors whose opportunity cost outweighs their value. Each cut candidate has the proposed scope reduction and the conditions under which it would be reinstated.

### 6. Open value questions
Ambiguous beneficiaries or unclear value. Each one routes to `/interview` (if user input is needed) or `/scout` (if evidence is needed).

### 7. Handoff
Block per `/artifact-protocol`, pointing at `/concurrency`.

## Rules

- Every behavior has a named beneficiary.
- Every behavior has a stated failure cost.
- Cut candidates are explicit, not implicit.
- Opportunity cost is named in concrete terms (the alternative that loses).
- Value tier disagreements with `/contract` get raised, not silently overridden.

## Anti-patterns

- "It's a nice feature" without a beneficiary.
- Treating engineering effort as free.
- Bundling Core and Nice-to-have under one acceptance criterion.
- Value rationales that loop back to the team's preferences ("it's cleaner") without external benefit.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (DX, AX), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`.

## Final response

End with exactly:

> Value map locked. Continue to `/concurrency`.
