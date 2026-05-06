---
name: test-plan
description: "Convert contract, architecture, interfaces, value/failure map, concurrency, security, performance, observability, refactor, and deletion decisions into a concrete proof plan. Runs after /delete, before /review. Use when the user types /test-plan, when proof gates need to be turned into named tests, or when verification feels arbitrary. Writes 18-test-plan.md and hands off to /review."
---

# /test-plan

A test plan is the proof contract for the run. Every acceptance criterion, invariant, and cross-cutting concern from earlier phases lands here as a named test or verification command.

## When this fires

- The user types `/test-plan`
- All design phases are complete and proof gates need names
- A reviewer asks "how will you prove this works?"

## Position in the workflow

Previous: `/delete`. Next: `/review`. See `/compound-workflow`.

## Preconditions

- `/contract` proof gates exist
- `/state-model`, `/concurrency`, `/security`, `/performance`, `/observability` named tests they require
- The repo's test runner / framework is identified

## Stance

Dijkstra: testing shows presence of bugs, not absence — so design tests to fail when invariants are violated, not just when the happy path runs. Property-based testing (Claessen & Hughes) for state machines and parsers. Test pyramid (Google testing blog) — push toward unit and integration; reserve E2E for evidence the unit cannot show.

Apply `/game-theory`: which test would future contributors skip if it were slow or flaky? Make it fast and deterministic so they cannot skip it.

## Required output

Write `<run-dir>/18-test-plan.md`:

### 1. Proof matrix
Table mapping each acceptance criterion / invariant to a test or verification:

| Source | Item | Test type | Test name | Where | Evidence |
|---|---|---|---|---|---|

Source ∈ { contract criterion, architect invariant, state-model machine, interface example, concurrency race, security abuse case, performance budget, observability signal, refactor characterization, deletion compatibility }.

Test type ∈ { unit, property, integration, contract test, snapshot, characterization, race / interleaving, fuzz, load, soak, security, browser, computer-use, app-flow, screenshot, benchmark, synthetic }.

### 2. Layer plan
- **Unit** — pure logic, fast, deterministic (most volume here)
- **Property** — invariants over generated input (state machines, parsers, schemas)
- **Integration** — module boundaries, real dependencies where cheap
- **Contract** — port/adapter and external-API contracts
- **End-to-end** — only where unit + integration cannot show the evidence reviewers need
- **Performance** — micro-benchmark or load test per budget
- **Security** — abuse-case test per asset
- **Observability** — signal-emission test per critical signal

### 3. Fixtures and data
- Where fixtures live
- How they are generated (deterministic seed)
- Cleanup strategy
- Anti-mock policy: real DB / queue / browser where the test is verifying that boundary

### 4. Determinism
- Time, randomness, network, concurrency controlled at test boundaries
- Flaky-test policy: no skip-and-retry; either fix or quarantine with a tracking issue

### 5. Coverage budget
Per module / surface, the coverage expectation (line, branch, mutation if applicable). Coverage is a floor, not a target.

### 6. Performance and budget tests
For each `/performance` budget, the benchmark or load-test name and its threshold.

### 7. Verification commands
The exact shell commands the agent / human will run during `/verify` to produce evidence:

- `bun test`
- `bun run typecheck`
- `bun run lint`
- `npm run e2e -- --grep <pattern>`
- benchmark commands
- security scanners
- browser probes / computer-use scenarios

### 8. Open issues
Tests that should exist but cannot in this run; captured per `/issue-capture`.

### 9. Handoff
Block per `/artifact-protocol`, pointing at `/review`.

## Rules

- Every acceptance criterion and invariant maps to a test or named verification.
- Every test has a name, a location, and a failure mode.
- Mocks only at trust boundaries; real dependencies for integration.
- No flaky-then-skip; either fix or quarantine with a tracking issue.
- Performance budgets and security abuse cases get explicit tests.
- Verification commands are concrete and runnable.

## Anti-patterns

- "We have good test coverage." — not a plan.
- Mocks of the database in tests that are verifying database behavior.
- E2E tests that exist because the unit/integration design was avoided.
- Coverage targets that count empty `describe` blocks.
- Property tests with no shrinker and no seed.

## Composition

References: `/first-principles`, `/game-theory`, `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Dijkstra, QuickCheck, Google test pyramid).

## Final response

End with exactly:

> Test plan locked. Continue to `/review`.
