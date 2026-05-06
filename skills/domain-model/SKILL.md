---
name: domain-model
description: "Name the real things in the problem before naming modules. Defines identity, lifecycle, authority, relationships, invariants, non-equivalences, and bounded contexts. Use when the user types /domain-model, when /contract is locked and design is about to start, or when a proposed architecture is conflating concepts that behave differently. Writes 04-domain-model.md and hands off to /architect."
---

# /domain-model

Wrong concepts create wrong modules. Get the nouns right before deciding where they live.

## When this fires

- The user types `/domain-model`
- `/contract` is locked and design is about to start
- A proposed architecture confuses things that look similar but behave differently (e.g., conflating `Task / Run / Session`, `User / Account / Identity`, `Order / LineItem / Fulfillment`)

## Position in the workflow

Previous: `/contract`. Next: `/architect`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/03-contract.md` exists with named actors and invariants
- The "actors" and "invariants" sections of the contract are concrete enough to model

## Stance

Apply the domain-modeling field guide from `/core-field-guides`. Name the real things in the problem, not implementation containers, screens, or tables. Make non-equivalences explicit. Make illegal states unrepresentable.

Apply `/first-principles` (what is irreducible) and `/game-theory` (which actor authors which concept).

## Required output

Write `<run-dir>/04-domain-model.md`:

### 1. Concept inventory
Table:

| Concept | One-sentence definition | Identity | Lifecycle owner | Authority | Examples | Non-examples |
|---|---|---|---|---|---|---|

Identity says what makes two instances distinct. Lifecycle owner says who creates / mutates / deletes. Authority says who is allowed to.

### 2. Non-equivalences
Pairs or sets of concepts that look similar but behave differently. Each pair has a one-line justification.

Examples:

- `Task != Run != Session` — Task is a definition, Run is one execution, Session is one user's interaction across runs
- `User != Account != Identity` — User is a person, Account is a billing relationship, Identity is an authentication subject

### 3. Bounded contexts
Where does a name change meaning? List each context and the local meaning. Cross-context translations are explicit.

### 4. Invariants encoded as types
For each invariant from the contract, name the encoding:

- type / sum type / state machine
- schema / constructor / smart constructor
- runtime validation at boundary
- lifecycle gate

If an invariant cannot be encoded, name how it will be enforced and why the type system cannot.

### 5. Lifecycle and state ownership
For each concept with state, name:

- the source of truth
- who can mutate
- what the lifecycle states are (briefly — the full state machine lives in `/state-model`)
- the deletion path

### 6. Relationships and aggregates
Name the aggregates: which concepts mutate together under one consistency boundary.

### 7. Vocabulary glossary
Ubiquitous-language entries the rest of the team / agents will use. Stable names beat clever names.

### 8. Handoff
Block per `/artifact-protocol`, pointing at `/architect`.

## Rules

- Real things, not screens or tables.
- Every concept has identity, lifecycle owner, and authority.
- Non-equivalences are explicit. If two names appear, they must mean different things.
- Bounded contexts are explicit. Same word in two contexts must be flagged.
- Invariants encoded in types where possible.
- No module names yet. That is `/architect`.

## Anti-patterns

- A `Manager` / `Service` / `Helper` concept that exists only because the implementation needed a place for code.
- One generic entity that hides multiple lifecycles.
- Names copied from the database schema without justification.
- "Just use `User`" when there are three different identities involved.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Domain modeling, State modeling), `/artifact-protocol`, `/issue-capture`. Citations: `/research-bibliography` (Evans, Wlaschin, Fowler bounded context).

## Final response

End with exactly:

> Domain model locked. Continue to `/architect`.
