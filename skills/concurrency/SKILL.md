---
name: concurrency
description: "Analyze concurrent behavior after /value-map, before /security. Defines ordering, cancellation, retries, idempotency, locks, queues, backpressure, races, partial failure, stale reads, and duplicate actions. Use when the user types /concurrency, when async work or shared state is in scope, or when a race / lost-update / duplicate-action bug is suspected. Writes 12-concurrency.md and hands off to /security."
---

# /concurrency

Concurrency bugs hide until production load. This phase makes ordering, cancellation, retries, and idempotency explicit before they become incidents.

## When this fires

- The user types `/concurrency`
- The system has async work, retries, queues, background jobs, distributed actors, or shared state
- A race, lost update, duplicate action, or stale read is suspected
- A reviewer asks "what happens if two of these run at once?"

## Position in the workflow

Previous: `/value-map`. Next: `/security`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/09-state-model.md` listed concurrency hooks
- `<run-dir>/10-interface.md` defined the surface that may be called concurrently

## Stance

Apply the concurrency field guide from `/core-field-guides`. State the happens-before relation when order matters. Design for commutativity, idempotency, or reconciliation when order does not. Apply `/first-principles` (the irreducible coordination requirement) and `/game-theory` (which actor benefits from skipping coordination).

## Required output

Write `<run-dir>/12-concurrency.md`:

### 1. Actor inventory
Every concurrent actor named: HTTP handlers, workers, queues, schedulers, browser tabs, mobile clients, retried callers, background reconcilers, agents, vendor webhooks. Each actor has its trigger, frequency, and what state it touches.

### 2. Race matrix
Table of pairs of actors that touch the same state, with the failure mode if they collide:

| Actor A | Actor B | Shared state | Collision failure mode | Mitigation |
|---|---|---|---|---|

Mitigation ∈ { single-writer, idempotency key, lock, optimistic concurrency, queue, CRDT, reconciliation, eventual + monotonic read }.

### 3. Ordering
For each operation:

- ordering required? (yes / no / per-key)
- happens-before relation (cite Lamport-style logical clocks if relevant)
- if order is unknowable, design for commutativity / idempotency / reconciliation

### 4. Cancellation and timeout
Cancellation policy: who can cancel, what cleans up, what guarantees survive cancellation. Timeouts named at every external call. Effect-first projects: scope cancellation through Effect's interruption model.

### 5. Retry and idempotency
Retry policy per external call: count, backoff, jitter, deadline. Idempotency keys named where retries can produce duplicate side effects. Stripe-style idempotency for payments / outbound webhooks / mutating APIs.

### 6. Backpressure and queueing
For each producer-consumer pair: queue type, max depth, overflow behavior (drop, block, fail-fast, shed). Tail-latency exposure named.

### 7. Partial failure
For each multi-step flow: which steps are reversible, which are not, what the compensating action is, what the system does if a compensating action also fails.

### 8. Stale-read tolerance
For each reader: acceptable staleness budget, fallback when stale, alert threshold for unbounded staleness.

### 9. Duplicate-action handling
For each user-visible mutation: how the system detects a duplicate (request ID, idempotency key, dedupe table) and what it returns.

### 10. Tests required
Names of tests that must exist (race / interleaving / idempotency / cancellation / partial-failure). Routes to `/test-plan`.

### 11. Open issues
Concurrency hazards captured per `/issue-capture`.

### 12. Handoff
Block per `/artifact-protocol`, pointing at `/security`.

## Rules

- Every shared state has a single writer or an explicit reconciliation mechanism.
- Every external call has a timeout.
- Every retry-capable mutation has an idempotency key.
- Every queue has overflow behavior.
- "It will probably be fine" is not a mitigation.

## Anti-patterns

- Implicit ordering ("we run them in this order so it's fine").
- Retries on non-idempotent endpoints.
- Locks held across I/O.
- Background jobs without dedupe.
- Caches without invalidation owners.
- Cancellation that leaks resources.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Concurrency, State modeling), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Hoare CSP, Lamport, Stripe idempotency, Dean & Barroso).

## Final response

End with exactly:

> Concurrency analyzed. Continue to `/security`.
