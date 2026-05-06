---
name: core-field-guides
description: "Reference card for what 'doing X properly' means across major design activities: domain modeling, boundaries, folder architecture, state, concurrency, observability, refactoring, deletion, developer experience, and agent experience. Use when a workflow skill needs a stable definition of good vs bad output for one of these activities, or when the user asks 'what does proper domain modeling look like'."
---

# /core-field-guides

Reference card for the major design activities. Each section names what good output looks like and what bad output looks like, so phase skills do not have to redefine the bar.

## When this fires

- A design-phase skill (`/domain-model`, `/boundary`, `/state-model`, `/concurrency`, `/observability`, `/refactor`, `/delete`) says "see core-field-guides"
- The user asks what proper-X looks like in this codebase context
- A reviewer wants the standard for "good output" before evaluating

Use the relevant section and skip the rest.

## Domain modeling

A proper domain model names the real things in the problem, not implementation containers. It defines identity, lifecycle, authority, relationships, invariants, non-equivalences, and bounded contexts. It prevents conflating things that look similar but behave differently.

**Good output**

- concept definitions with examples and non-examples
- non-equivalences such as `Task != Run != Session`
- bounded contexts where names have local meaning
- illegal states removed through types, schemas, constructors, or state machines

**Bad output**

- classes named after UI screens or database tables only
- nouns copied from implementation details
- one generic entity that hides multiple lifecycles

## Boundaries

A boundary is useful when it hides a volatile decision, protects authority, preserves an invariant, or stops dependency leakage. A boundary defines public surface, private internals, allowed crossings, forbidden crossings, error/telemetry crossings, and enforcement.

**Good output**

- package exports that expose the intended seam
- forbidden imports made enforceable
- trust boundaries named explicitly
- no public path to private internals

**Bad output**

- shallow wrappers that forward everything
- folders used as boundaries without export/import enforcement
- public option bags that bypass policy

## Folder architecture

A folder owns a cohesive concept or layer. Avoid giant catch-all folders and tiny ceremonial folders.

**Test:** a future agent should know where to add a related change without searching the entire repo or creating a duplicate source of truth.

**Good output**

- one owner per concept
- local tests/examples near the concept when useful
- public entry point separated from internals
- folder size reflects cohesion, not arbitrary file count

## State modeling

Proper state modeling names every state, owner, source of truth, lifecycle, invalidation rule, mutation path, consistency level, and deletion path. Derived state is not stored unless it has independent lifecycle or performance justification.

**Good output**

- state inventory table
- state machines instead of boolean soup
- one writer or explicit reconciliation
- tests for invalid state and stale reads

**Bad output**

- two writers for the same state
- cached state with no invalidation owner
- persisted derived state without reason

## Concurrency

Proper concurrency design specifies actors, ordering, cancellation, retry, idempotency, queueing, backpressure, locks, stale reads, partial failure, and duplicate actions. If order matters, state the happens-before relation. If order is unknowable, design for commutativity, idempotency, or reconciliation.

**Good output**

- race matrix
- cancellation/timeout policy
- duplicate/retry behavior
- idempotency key or single-writer mechanism
- stress or race tests when relevant

## Observability

Proper observability designs the debugging interface. Start from the questions future maintainers and agents must answer: what happened, in what order, under whose authority, and why did it fail?

**Good output**

- signals chosen by intent, not random logs
- trace / span / metric / event plan
- correlation IDs through the call graph
- redaction rules for PII and secrets
- diagnostics verified by tests or failure-path checks

## Refactoring

A proper refactor preserves behavior while improving structure. State the smell, the cost of the current structure, the new incentive it creates, and the proof that behavior is preserved. Do not refactor for pattern compliance alone.

**Good output**

- structural changes separated from behavior changes
- characterization tests or equivalent safety proof
- refactor before feature when it shrinks risk
- follow-up issue captured for optional cleanup

## Deletion

Deletion is a design activity. Every leftover obsolete path remains an affordance that future people and agents may use. Proper deletion finds dead code, duplicate paths, stale docs, compatibility shims, misleading examples, old flags, and unused helpers, then proves safe removal or files a migration / follow-up issue.

**Good output**

- delete / deprecate / keep classification
- usage search and compatibility proof (`rg`, `gh code-search`, type references)
- stale docs/examples removed
- old paths hidden or made loud

## Developer experience (DX)

DX is the developer's path from intent to correct action. Measure install / import friction, time to first success, call-site clarity, type hints, examples, error recovery, docs navigation, and migration. Good DX makes the correct move obvious and the unsafe move hard.

## Agent experience (AX)

AX is whether a coding agent can infer the correct path from repo affordances: file names, public exports, docs, examples, tests, errors, AGENTS instructions, and validation commands. Agent-hostile code has hidden conventions, private imports in examples, stale docs, and multiple competing patterns.

**Good output**

- public exports match what examples import
- one canonical example per surface
- errors point at the fix, not just the symptom
- AGENTS.md and tests agree on conventions
- no dead helpers that look canonical

## Composition

This skill is referenced by the design-phase skills (`/domain-model`, `/boundary`, `/state-model`, `/concurrency`, `/observability`, `/refactor`, `/delete`, etc.) for their good/bad output bars. First-principles framing comes from `/first-principles`; incentive analysis from `/game-theory`. Citations live in `/research-bibliography`.

## Final response

When invoked directly, end with:

> Field guide loaded. Apply the relevant section to your current phase.
