---
name: performance
description: "Set performance budgets and verify hot paths after /security, before /observability. Identifies hot paths, algorithmic complexity, latency, memory, throughput, startup, rendering, tail latency, caching, batching, and regression thresholds. Use when the user types /performance, when SLOs / latency budgets are in scope, or when a hot path needs a defensible budget. Writes 14-performance.md and hands off to /observability."
---

# /performance

Performance lives or dies at the budget. This phase makes the budget explicit, names the hot paths, and decides what gets measured before it ships.

## When this fires

- The user types `/performance`
- SLOs, latency budgets, throughput targets, or memory ceilings are in scope
- A hot path is being touched (request handling, query, render, model call, batch job)
- A regression is suspected or budgets are being formalized for the first time

## Position in the workflow

Previous: `/security`. Next: `/observability`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/03-contract.md` named a performance baseline
- The architecture is concrete enough to identify hot paths

## Stance

Cite or do not claim. Use measurement, not memory. Apply Brendan Gregg's USE method (utilization, saturation, errors) where relevant. Apply tail-latency thinking (Dean & Barroso) for any composed system. Apply `/game-theory`: which contributor will sneak a synchronous call into the hot path because it is locally easy?

## Required output

Write `<run-dir>/14-performance.md`:

### 1. Budgets
Table per public surface:

| Surface | Metric | Budget | Measurement window | Alert threshold | Source of truth |
|---|---|---|---|---|---|

Metric ∈ { p50 latency, p95, p99, throughput, memory, startup, FCP / LCP, CPU, DB rows scanned, cost per call }.

Budgets must be cited (existing SLO, product requirement, contract criterion). If no source exists, name the assumption and route to `/interview`.

### 2. Hot path inventory
For each hot path:

- request flow (one-line)
- expected QPS
- critical resources (DB, cache, network, model, render)
- known cliffs (lock contention, N+1, cold cache, model timeout)
- baseline measurement (if any) with command / dashboard reference

### 3. Algorithmic concerns
For each algorithm in scope:

- complexity (time / space)
- input distribution
- worst-case scenario
- whether worst-case is reachable from untrusted input (also a security concern)

### 4. Caching, batching, parallelism
Per surface:

- cache strategy (key, TTL, invalidation owner — cross-reference `/state-model`)
- batching strategy (debounce, coalesce, bulk endpoint)
- parallelism strategy (fan-out, work-steal, queue depth)
- failure mode when each is unavailable

### 5. Tail latency
For each multi-stage flow, the artifact names:

- expected p99 of each stage
- compounding effect on end-to-end p99
- hedging / cancellation / partial-result strategy

### 6. Regression thresholds
What must trigger a build failure or alert. Concrete thresholds, not "if it gets slow".

### 7. Verification plan
For each budget, the verification mechanism:

- micro-benchmark (criterion / vitest / k6)
- load test (k6 / locust / vegeta)
- production probe / synthetic
- distributed tracing dashboard
- continuous performance test in CI

Names route to `/test-plan` and `/verify`.

### 8. Open issues
Performance hazards or unverified budgets captured per `/issue-capture`.

### 9. Handoff
Block per `/artifact-protocol`, pointing at `/observability`.

## Rules

- Every hot path has a budget.
- Every budget cites a source (SLO, product requirement, contract criterion).
- Every cache has an invalidation owner (no orphan caches).
- Worst-case complexity from untrusted input is named.
- Regression threshold is concrete.
- "Performant" without a number is not a budget.

## Anti-patterns

- Premature micro-optimization without a budget.
- Caches that hide a slow query no one fixed.
- Synchronous external calls in the hot path.
- N+1 queries hidden behind ORM convenience.
- Tail latency ignored because the average looks fine.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Concurrency, Observability), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Dean & Barroso tail at scale, USE method).

## Final response

End with exactly:

> Performance budgets locked. Continue to `/observability`.
