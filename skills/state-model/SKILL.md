---
name: state-model
description: "Define the state model after /dedupe, before /interface. Inventories every state, owner, source of truth, lifetime, transition, invalidation rule, persistence policy, derived state, and concurrency pressure point. Use when the user types /state-model, when boolean-soup or scattered state ownership is suspected, or when a lifecycle is non-trivial. Writes 09-state-model.md and hands off to /interface."
---

# /state-model

State that nobody owns becomes state that everybody corrupts. This phase names every piece of state and the rule that keeps it valid.

## When this fires

- The user types `/state-model`
- The architecture has non-trivial lifecycle (multi-step flow, retries, async work, background reconciliation)
- "Boolean soup" or scattered status flags are suspected
- A future feature would need to know "who owns this field?"

## Position in the workflow

Previous: `/dedupe`. Next: `/interface`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/04-domain-model.md` named lifecycle owners briefly
- `<run-dir>/05-architect.md` placed state in modules
- Concepts with state are nameable

## Stance

Apply the state-modeling field guide from `/core-field-guides`. Boolean-soup is the smell; state machines are the cure. Persisted derived state must justify its existence. Apply `/first-principles` (what state is irreducible) and `/game-theory` (which actor is tempted to write to state they do not own).

## Required output

Write `<run-dir>/09-state-model.md`:

### 1. State inventory
Table:

| State | Type | Owner | Source of truth | Lifetime | Persistence | Derived? | Writers | Readers |
|---|---|---|---|---|---|---|---|---|

Lifetime ∈ { request, session, run, persistent, eternal }. Persistence ∈ { in-memory, sessionStorage, localStorage, file, DB, queue, cache, log, none }.

### 2. State machines
For each piece of state with non-trivial lifecycle, draw the state machine (mermaid `stateDiagram-v2` or prose):

- states named with verbs that describe what is allowed in that state
- transitions labeled with their trigger
- terminal states named (success, failure modes)
- invalid transitions explicitly forbidden

Replace boolean flags (`isLoading`, `isError`, `isComplete`) with sum types or named states.

### 3. Single-writer or reconciliation
For each state, name either:

- the single writer (preferred), or
- the explicit reconciliation mechanism (CRDT, last-write-wins with timestamps, version vector, optimistic concurrency, queue)

Two writers without reconciliation is decay; flag it.

### 4. Invalidation rules
For each cached or derived state:

- when it must be invalidated
- who triggers invalidation
- what the staleness budget is
- what happens on stale read

### 5. Persistence policy
For each persistent state:

- what is written, when, and by whom
- write durability (sync, async, write-behind)
- read consistency (strong, eventual, monotonic)
- backup / migration policy
- deletion path (GDPR, account close, expiration)

### 6. Derived state
Any state that could be re-computed. Each entry justifies persistence (independent lifecycle, performance budget, audit log) or proposes deletion.

### 7. Impossible states made impossible
Each illegal combination from the contract, with the encoding that prevents it (sum type, refinement, runtime guard, lint rule, test).

### 8. Concurrency hooks
States that may be touched concurrently. Detail belongs in `/concurrency`; this section names them.

### 9. Tests for invalid state and stale reads
At least one test name per non-trivial state machine. Test names belong here as the contract for `/test-plan`.

### 10. Handoff
Block per `/artifact-protocol`, pointing at `/interface`.

## Rules

- Every state has one owner.
- Every state has a single writer or an explicit reconciliation mechanism.
- Every cache has an invalidation owner.
- Every derived persistent state has a justification.
- No `isLoading + isError + isSuccess` triplet; replace with a sum type.
- Persistent state has a deletion path.

## Anti-patterns

- Status booleans for non-binary states.
- "We'll just refresh the cache when we remember."
- Silent fallback to a default when state is missing.
- Two writers and a hope.
- Persisted derived state without a stated reason.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (State modeling, Concurrency), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Harel statecharts, Wlaschin, Lamport).

## Final response

End with exactly:

> State model locked. Continue to `/interface`.
