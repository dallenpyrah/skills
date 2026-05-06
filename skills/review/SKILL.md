---
name: review
description: "Pressure-test the design after /test-plan, before /issue. Checks that every prior artifact exists, every invariant is enforced, every incentive is named, and every proof gate has a test. Use when the user types /review, when a design is about to become an issue, or when a coherence check is needed before any code is written. Writes 19-review.md and hands off to /issue."
---

# /review

The pre-implementation gate. The design either survives this pass or returns to an earlier phase. No code yet.

## When this fires

- The user types `/review`
- All design phases (scout through test-plan) have artifacts
- A coherence check is needed before any code is written

## Position in the workflow

Previous: `/test-plan`. Next: `/issue`. See `/compound-workflow`.

## Preconditions

- Artifacts 01-scout through 18-test-plan exist (or are explicitly marked `not_applicable` with evidence)
- The user is ready to lock the design

## Stance

Apply principle-compliance and reality-check passes in parallel. Apply `/first-principles` and `/game-theory` adversarially. The goal is to catch design mistakes before they become committed-code mistakes.

## Two passes

### Pass A — Principle compliance

For each principle, the reviewer verifies the design:

- **First-principles derivation** — every module / state / interface ties back to a contract invariant or an explicit volatility decision
- **Game-theoretic incentive fit** — the design rewards the desired equilibrium and makes the bad local move impossible / loud / recoverable
- **Minimal code** — no abstraction that hides nothing; no future-proofing for unstated requirements
- **Composition over inheritance** — no `extends` chains hiding behavior
- **Single source of truth** — every shared concept has one owner
- **Deep modules, narrow interfaces** — Ousterhout
- **Functional core, imperative shell** — pure transformations isolated
- **State machines for lifecycle** — no boolean soup
- **Ports / adapters at I/O** — vendor types do not leak
- **Typed errors with recovery instructions** — no silent fallbacks
- **Effect discipline** (when Effect-first) — Effect primitives in Effect-owned code; pure TS at boundaries
- **No silent fallbacks**
- **Performance budgets with measurement** — budgets cited, regression thresholds concrete
- **Reliability** — concurrency hazards have mitigations
- **Security** — assets and trust boundaries explicit; complete mediation; least privilege
- **Observability** — every diagnostic question has a signal
- **Testability** — every invariant has a named test

Each principle gets a status: `pass`, `pass-with-note`, `fail`. Failures route back to the responsible phase.

### Pass B — Reality check

Imagine the system in production after 6 months and 20 changes. Apply `/game-theory`:

- What shortcut will future contributors take?
- Which boundary will be bypassed first under deadline pressure?
- Which invariant is enforced only by hope?
- Which doc / example will go stale before being noticed?
- Which alert will fire so often it gets ignored?
- Which agent will copy a non-canonical example?

Each reality-check finding routes to a fix or a captured issue.

## Required output

Write `<run-dir>/19-review.md`:

### 1. Artifact inventory
Confirm every prior artifact exists or is `not_applicable` with evidence.

### 2. Principle-compliance pass
Table of principle / status / evidence / fix.

### 3. Reality-check pass
List of stress scenarios with findings.

### 4. Required fixes before /issue
Findings that must be addressed before locking. Each routes to the phase that owns the fix.

### 5. Permitted as-is
Findings that the reviewer accepts with stated trade-off.

### 6. Issue candidates captured
Per `/issue-capture`.

### 7. Verdict
- **locked** — design is ready for `/issue`
- **return** — return to a specific earlier phase with named fixes

### 8. Handoff
Block per `/artifact-protocol`, pointing at `/issue` (when locked) or the named earlier phase (when returning).

## Rules

- A design is locked or it is not. No "mostly".
- Every fail has a named owner phase and a concrete fix.
- The reviewer applies pressure to assumptions, not to people.
- "It would be better if" is feedback, not a fail.
- Failures are not arguments; they cite the principle and the evidence.

## Anti-patterns

- Reviewing under deadline pressure and rubber-stamping.
- Skipping reality-check because principle pass looked clean.
- Locking with material `not_applicable` artifacts that have no evidence.
- Returning the run without naming the smallest required fix.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides`, `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Parnas, Ousterhout, Liskov, Saltzer & Schroeder, Dijkstra).

## Final response

When **locked**, end with exactly:

> Design locked. Continue to `/issue`.

When **returning**, end with exactly:

> Design returned to /<phase>. Resume from there.
