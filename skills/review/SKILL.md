---
name: review
description: Pressure-test the architecture produced by /architect. Enforces first-principles derivation, game-theoretic incentive fit, minimal code, composition, single source of truth, deep modules, clean interfaces, functional core, lifecycle state machines, ports/adapters, Effect discipline, no silent fallbacks, performance, reliability, security, observability, and testability. Runs principle-compliance and reality-check passes. Hands off to /issue only when locked.
---

# /review

Review the architecture that `/architect` produced. This is an architecture review, not a code review.

Be blunt. The goal is to catch design errors before they become GitHub issues.

## Preconditions

- `/architect` output must be present in the conversation context.
- If you cannot find an architecture proposal with at least these sections, tell the user to run `/architect` first and stop:
  - Problem
  - Game board
  - Constraints
  - Core trade-off
  - Architecture
  - Modules
- If the architecture references code, files, functions, types, symbols, commands, libraries, docs, APIs, or existing conventions, they must be grounded before the review can lock.

## Review stance

A clean architecture is not just internally elegant. It must create good incentives.

Ask:

- Did the architect derive the design from first principles?
- Does the design protect the invariant?
- Does the design align local incentives with global code health?
- Does the design make the correct behavior cheap?
- Does the design make dangerous behavior impossible or loud?
- Does the design survive repeated future changes?
- Does it resist adversarial input, misuse, and deadline pressure?

Use this severity model:

- **Blocking** — likely to produce wrong architecture, untestable design, hidden failure, bad equilibrium, state bugs, performance cliffs, security risk, or irreversible coupling.
- **Important** — should be fixed before issue-writing, but the design direction is probably salvageable.
- **Minor** — wording, naming, or small clarification.

For every finding, state:

```markdown
- **Severity:** Blocking | Important | Minor
- **Principle:** <principle>
- **Violation:** <specific problem>
- **Game-theory failure:** <bad incentive/equilibrium/information problem, if applicable>
- **Why it matters:** <consequence>
- **Fix:** <specific architectural change>
```

If the architecture is clean, say so in one sentence and move on to the reality check.

## Pass 1 — First-principles compliance

Flag solution-first reasoning, framework-first reasoning, missing invariant, assumptions presented as facts, vague problem statement, unclear source of truth, omitted constraints, omitted trade-off, and patterns chosen before need was established.

Required checks:

- problem reduced to primitive concepts
- constraints explicit
- invariants explicit
- core trade-off explicit
- facts grounded
- assumptions labeled
- non-goals named

## Pass 2 — Game-theory compliance

Flag:

- local shortcut that creates global cost
- API that makes misuse easy
- review-only enforcement where type/interface enforcement is possible
- hidden fallback that rewards ignoring failure
- broad interface that rewards overreach
- shallow abstraction that rewards unnecessary indirection
- missing information needed by caller/reviewer/maintainer
- principal-agent problem without observability/accountability
- attacker or malformed input not modeled
- repeated future changes likely to degrade architecture
- coordination problem hidden by vague naming

Required checks:

- players named
- incentives named
- information asymmetries named
- bad equilibrium named
- desired equilibrium named
- mechanism changes incentives
- good move made easy
- bad move impossible or loud
- adversarial player considered
- repeated-game durability considered

## Pass 3 — Principle compliance

Walk the architecture against the `/architect` principle spine.

### Simplicity and abstraction

Flag unnecessary modules, speculative extension points, abstractions that hide nothing, wrappers that only forward, broad generic services, option bags used to avoid real modeling, and designs that solve hypothetical future problems.

Required checks: minimal code, KISS, YAGNI, avoid premature abstraction, complexity budget, deep modules, information hiding, encapsulation.

### Boundaries and coupling

Flag shallow modules, complected concepts, domain logic in transport/UI/persistence, storage braided with query, validation scattered across layers, low cohesion, duplicate sources of truth, circular dependencies, and wrapper names.

Required checks: separation of concerns, don't complect, high cohesion, low coupling, single responsibility, orthogonality, law of Demeter, bounded contexts when relevant, ubiquitous language, naming discipline.

### Composition and extensibility

Flag inheritance used for reuse, weak subclass contracts, broad interfaces, unused capabilities, high-level policy depending on concrete details, speculative Open/Closed mechanisms, plugin abstractions without real variation, and manager/service/helper abstractions that hide no decision.

Required checks: composition over inheritance, true subtypes only, Liskov, program to contracts, Interface Segregation, Dependency Inversion, restrained Open/Closed, extensibility through stable seams.

### Dependency direction and I/O

Flag domain importing framework/network/filesystem/database/queue/CLI/UI/clock/randomness/vendor SDK directly, adapters defining domain policy, transport schema leaking into domain model, database convenience shaping domain, business logic in UI/infrastructure, missing fake/test adapter, and outward core dependencies.

Required checks: dependency rule, ports and adapters, layer discipline, no circular dependencies, local substitutability.

### Functional architecture

Flag mutable state inside pure core, impure core functions, hidden dependencies, behavior-heavy objects crossing boundaries, data models with implicit lifecycle behavior, duplicate knowledge, config defaults hiding missing configuration, and utility behavior that should be domain logic.

Required checks: functional core/imperative shell, state/effects at edges, immutability by default, referential transparency, data over behavior at boundaries, single source of truth / DRY as knowledge.

### State, invariants, and lifecycle

Flag lifecycle represented by booleans/nullables/magic strings/timestamps alone, illegal states representable in types, missing transitions/terminal/cancellation/error states, scattered transitions, post-construction invariant checks, transaction boundaries by convenience, and omitted consistency strategy.

Required checks: invalid states unrepresentable, state machines for lifecycle, state machines only where useful, exhaustive handling, domain invariants at boundaries, transaction boundaries follow invariants, consistency explicit.

### Effects, errors, and recovery

Flag raw `Promise` orchestration in Effect-owned code, broad `try/catch`, custom `Result` in Effect-owned paths, nullable/stringly errors, swallowed errors, hidden retries, fallback providers, defaults that mask missing required input, catch-and-continue, untyped recovery, and retriable side effects without idempotency.

Required checks: Effect-first for effectful paths, Effect primitives, plain TS for pure/thin interop, typed errors, NO SILENT FALLBACKS, explicit typed recovery only, idempotency, failure modes as architecture.

### Quality attributes

Flag missing performance budget, unknown hot-path complexity, no timeout/cancellation/retry policy, no partial-failure model, no security/least-privilege discussion, no observability for important production paths, weak test strategy, and no migration/rollback story.

Required checks: performance, reliability, security / least privilege, observability, testability, migration safety, explicit non-goals.

## Pass 4 — Reality check

Spawn two Explore agents in parallel, in one message with two tool calls.

### Agent A — Code grounding

Verify every file, function, type, symbol, command, module, dependency, and convention referenced by the architecture.

Agent A must report references that match, references that behave differently, hallucinated symbols, missing tests/conventions, package/library behavior needing source/docs, and current code paths that create bad incentives or hidden coupling.

Report in fewer than 300 words.

### Agent B — Prior art and incentive history

Scan git log, existing `skills/`, adjacent modules, prior issues/migrations if available, utilities/helpers, similar conventions, deleted/abandoned approaches, `docs/learnings/`, and previous review comments if accessible.

Agent B must report reusable patterns, prior work to extend, naming/style conventions, risky deviations, duplicate abstractions, and known bad equilibria this repo already learned from.

Report in fewer than 300 words.

## Pass 5 — Synthesis

Merge first-principles findings, game-theory findings, principle findings, Agent A grounding, and Agent B prior art.

Then decide:

- **LOCKED** — no blocking findings; important findings are either fixed in the revised architecture or explicitly accepted as trade-offs.
- **NOT LOCKED** — any blocking finding remains unresolved.

If edits are warranted, propose revised sections, not vague recommendations.

Use clear diffs:

```diff
- Old architecture claim
+ Revised architecture claim
```

When revising modules, include the full revised module entry.

## Output shape

Use this structure:

```markdown
## Verdict
LOCKED | NOT LOCKED

## First-principles findings
<findings grouped by severity; if none, one sentence>

## Game-theory findings
<findings grouped by severity; if none, one sentence>

## Principle compliance findings
<findings grouped by severity; if none, one sentence>

## Reality check
### Agent A — Code grounding
<short report>

### Agent B — Prior art and incentive history
<short report>

## Synthesis
<what the combined evidence means>

## Required architecture edits
<diffs or revised sections>

## Remaining decisions
<only if NOT LOCKED>
```

If **NOT LOCKED**, end with exactly this line and stop:

> Architecture not locked. Resolve the blocking findings above, then rerun `/review`.

If **LOCKED**, restate the final locked architecture with enough detail that `/issue` can find it in conversation context.

Then end with exactly this line and stop:

> Architecture locked. Run `/issue` to open the GitHub issue.
