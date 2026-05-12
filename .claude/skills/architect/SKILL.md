---
name: architect
description: Re-derive the simplest, cleanest architecture from first principles. Enforces minimal code, composition, single source of truth, deep modules, clear abstractions, clean interfaces, functional core, state machines for lifecycle, ports/adapters, typed recovery, no silent fallbacks, Effect primitives in Effect-owned code, and game-theoretic incentive compatibility. Runs after /interview. If /scout was not run, performs scout-equivalent grounding. Produces an architecture proposal in conversation context. Hands off to /review.
---

# /architect

Before rendering user-facing output, read `../_shared/plain-output.md`.

Re-derive the architecture from the problem, constraints, values, non-goals, codebase reality, and incentive structure.

Do not anchor on the user's initial solution sketch unless it survives first-principles scrutiny and game-theoretic pressure.

This is an architecture skill, not an implementation skill. Produce the architecture that should exist before GitHub issues are written.

## Preconditions

- `/interview` should have produced a locked core shape, or the current conversation must contain equivalent clarity:
  - problem
  - root cause
  - affected users/systems
  - constraints
  - non-goals
  - architectural values
  - game board
  - desired equilibrium
  - rough solution direction
  - review criteria
- If the core shape is missing, do not design. Tell the user to run `/interview` first and stop.
- If `/scout` has not run, perform a scout-equivalent grounding pass before designing.

## Core architecture thesis

A good architecture is a mechanism.

It should make:

- the correct action cheap
- the dangerous action impossible or loud
- the ambiguous action reviewable
- the repeated future action sustainable
- the local incentive aligned with global code health

## Shared contracts

Before grounding or spawning subagents, read `../_shared/subagents.md`, `../_shared/evidence-quality.md`, and `../_shared/grounding.md`.

`/architect` owns the final design. Subagents may gather evidence, propose alternatives, or critique a draft, but they do not decide the architecture.

## Principle spine

Use this checklist as the architecture spine. A violation is allowed only when it is named as an explicit trade-off and justified.

### First principles

1. **Start from invariants.** Do not start from frameworks, files, classes, or user-suggested solution shapes.
2. **Separate facts from assumptions.** Label what is grounded, inferred, unknown, and intentionally deferred.
3. **Identify irreducible constraints.** Time, performance, compatibility, migration, security, external API semantics, and existing code shape are not preferences.
4. **Name the primitive concepts.** If the problem cannot be explained without implementation jargon, the model is not understood.
5. **Derive before choosing.** Do not choose a pattern until the problem demands it.

### Game-theoretic design

6. **Design the mechanism, not just the module.** The architecture must shape future behavior.
7. **Make the good move the easy move.** APIs, types, tests, and boundaries should guide implementers toward correct use.
8. **Make the bad move impossible or loud.** Misuse should fail at compile time, construction time, validation time, or review time.
9. **Account for players.** Identify callers, maintainers, reviewers, users, attackers, external services, CI, and future implementers.
10. **Account for incentives.** State what each player is tempted to do and how the design changes that payoff.
11. **Handle information asymmetry.** Expose the information needed to make correct decisions; hide only implementation details.
12. **Avoid bad equilibria.** Reject designs where locally convenient changes accumulate into global coupling.
13. **Repeated-game durability.** Optimize for the 20th future change, not only the first implementation.
14. **Principal-agent safety.** When one component acts on behalf of another, define authority, observability, and accountability.
15. **Adversarial thinking.** Treat attackers, malformed inputs, flaky dependencies, retries, and future misuse as strategic players.

### Simplicity and complexity

16. **Minimal code.** Prefer the fewest concepts, modules, branches, and moving parts that satisfy the real constraints.
17. **KISS.** Choose the simplest design that can be explained directly.
18. **YAGNI.** Do not build extension points, abstractions, options, or generality for hypothetical futures.
19. **Avoid premature abstraction.** Duplication is cheaper than a false abstraction until the repeated thing has a real shared meaning.
20. **Complexity is a budget.** Every abstraction must earn its keep by hiding real complexity, protecting invariants, creating a stable seam, or changing bad incentives.

### Modularity and boundaries

21. **Deep modules over shallow modules.** A module should have a narrow interface and a powerful implementation. A wrapper that just forwards gets deleted.
22. **Information hiding.** A module must hide a volatile decision, algorithm, policy, representation, protocol, or dependency.
23. **Encapsulation.** Callers should not know internal representation, construction details, lifecycle details, or dependency wiring.
24. **Clear interfaces.** Interfaces should be small, explicit, typed, intention-revealing, and hard to misuse.
25. **High cohesion.** Put things together when they belong together and change together.
26. **Low coupling.** Minimize knowledge across modules. Do not make unrelated changes ripple.
27. **Separation of concerns.** Keep domain, transport, persistence, rendering, configuration, orchestration, validation, and side effects separate unless a deliberate trade-off says otherwise.
28. **Don't complect.** Do not braid concepts that vary independently: state with value, transport with logic, query with storage, UI with policy, persistence with validation, configuration with behavior.
29. **Single Responsibility Principle.** Gather things that change for the same reason. Separate things that change for different reasons.
30. **Orthogonality.** A change in one concern should not require edits in unrelated concerns.
31. **Law of Demeter / least knowledge.** Do not reach through chains of objects/modules to depend on internals.
32. **Bounded contexts when the domain warrants it.** When the same term means different things in different parts of the domain, split the model and name the boundary.
33. **Ubiquitous language.** Names should come from the domain and the real concept, not framework mechanics.
34. **Name what it is, not what wraps it.** `Cache` beats `CacheManager`. `User` beats `UserEntity`. `WorkflowState` beats `WorkflowStateHelper`.

### Composition, contracts, and extensibility

35. **Composition over inheritance.** Reuse behavior by composing capabilities. Use inheritance only when the subtype is truly substitutable.
36. **Inheritance only for true subtypes.** `extends` is valid only when every child preserves the parent contract and invariants.
37. **Liskov Substitution Principle.** If subtyping exists, callers must be able to use a subtype without changing correctness.
38. **Program to contracts.** Depend on stable interfaces, schemas, ports, and capabilities rather than concrete details.
39. **Interface Segregation Principle.** Callers should not depend on methods, fields, dependencies, or capabilities they do not use.
40. **Dependency Inversion Principle.** High-level policy owns the abstraction. Low-level details implement it.
41. **Open/Closed Principle with restraint.** Design stable seams for known variation. Do not create speculative extension mechanisms.
42. **Extensible architecture.** Extensibility comes from deep modules, stable contracts, and explicit seams — not from generic managers, plugin fantasies, or broad option bags.

### Dependency direction and I/O

43. **Dependency rule.** Source dependencies point inward toward policy/domain logic, not outward toward frameworks, transports, databases, or vendors.
44. **Ports and adapters for I/O.** Domain/application logic owns the port. Filesystem, network, database, queue, clock, randomness, and third-party APIs are adapters.
45. **Layer discipline.** UI has no business logic. Domain has no UI or infrastructure dependency. Infrastructure does not define domain policy.
46. **No circular dependencies.** Cycles are design smells. Break them with a deeper module, a port, or a clearer boundary.
47. **Local substitutability.** Anything hard to test because it touches the world needs a port, fake, test adapter, or pure core seam.

### Functional architecture

48. **Functional core, imperative shell.** Put business decisions in pure functions. Put I/O, mutation, orchestration, retries, logging, and process lifecycle at the shell.
49. **Push state to the edges.** The core should be pure or as close to pure as the language/project allows.
50. **Immutability by default.** Prefer immutable values. Localized mutation is allowed only when it is faster, clearer, and contained.
51. **Referential transparency for core transforms.** Same input should produce same output in core logic.
52. **Data over behavior at boundaries.** Plain data crosses module/process boundaries cleanly. Objects with hidden state do not.
53. **Single source of truth / DRY.** Each piece of knowledge has one authoritative representation. DRY is about knowledge, not merely duplicate-looking text.

### State, invariants, and lifecycle

54. **Make invalid states unrepresentable.** Use types, schemas, branded values, discriminated unions, and constructors to prevent illegal combinations.
55. **State machines for lifecycle.** Use explicit states and transitions for domain lifecycle. Do not use ad-hoc booleans, nullable fields, or string soup for lifecycle.
56. **State machines where they make sense, not everywhere.** Use state machines for domain lifecycle. Use schemas, ports, types, or simpler control flow when those are enough.
57. **Exhaustive handling.** Variants, states, and tagged errors should be handled exhaustively where the language allows it.
58. **Domain invariants at boundaries.** Validate and protect invariants at module/domain boundaries. Do not scatter invariant checks.
59. **Transaction boundaries follow invariants.** Choose transaction scope based on consistency requirements, not convenience.
60. **Consistency strategy explicit.** State whether the design requires strong consistency, eventual consistency, idempotent reconciliation, or compensating action.

### Effects, errors, and recovery

61. **Effect-first for effectful paths.** In Effect-owned code, use Effect primitives instead of ad-hoc TypeScript effect handling.
62. **Use Effect primitives when using Effect.** Prefer `Effect`, `Layer`, `Context`, `Schema`, `Config`, `Cause`, `Schedule`, `Ref`, `Queue`, `Deferred`, `Scope`, and typed service tags where appropriate.
63. **Plain TypeScript is fine for pure code.** Pure transformations, constants, type utilities, and thin interop boundaries do not need Effect ceremony.
64. **Typed errors.** Failures should be modeled in the type/error channel, not hidden behind nullable returns, broad exceptions, boolean flags, or generic strings.
65. **NO SILENT FALLBACKS.** No hidden defaults, catch-and-continue behavior, best-effort substitution, implicit retries, or fallback providers that mask failure.
66. **Only explicit typed recovery.** Recovery is allowed only when modeled, typed, observable, tested, and part of the product behavior.
67. **Idempotency for side-effecting commands.** If a command can be retried, replayed, duplicated, or externally triggered, define duplicate handling.
68. **Failure modes are architecture.** Name what can fail, how it fails, who observes it, and what recovery or non-recovery means.

### Quality attributes

69. **Performance budget explicit.** Critical paths must state expected complexity, latency, memory, throughput, batching, caching, or concurrency constraints.
70. **Reliability explicit.** State the failure model, retry policy, timeout policy, cancellation behavior, and partial-failure behavior.
71. **Security / least privilege.** Interfaces expose only the data and authority they need.
72. **Observability.** Important production paths expose useful logs, traces, metrics, events, or audit records.
73. **Testability.** Explain how the core, ports, adapters, state transitions, error paths, and performance-sensitive paths are tested.
74. **Migration safety.** If existing behavior changes, name the migration path, compatibility risks, and rollback strategy.
75. **Clear non-goals.** State what the architecture intentionally does not solve.

## Process

0. **Check the conversation context.**
   - If `/interview` has not locked the core shape and the current context does not contain equivalent clarity, stop and ask the user to run `/interview`.
   - If `/scout` did not run, perform a scout-equivalent grounding pass before designing.

1. **Ground before designing.** Read relevant repo code/tests; use `rg`, ast-grep, symbol/type search; inspect existing conventions; inspect `node_modules` or installed package source when library behavior matters; use official docs, `shelf`, `context7`, `gh_grep`, and `exa` when relevant; enumerate edge cases, lifecycle states, failure modes, compatibility constraints, and incentive traps. If the codebase can answer a question, answer it by exploration instead of asking the user.

2. **Restate the problem from first principles.** One sentence. Do not carry forward solution-assuming phrasing.

3. **Define the game board.** Players, incentives, information asymmetries, bad local moves, global costs, desired equilibrium, adversarial moves, and repeated-game risks.

4. **List constraints.** Include user, codebase, quality, compatibility, migration, and non-negotiable architectural constraints.

5. **Name the core trade-off.** Use: `I am trading X for Y.`

6. **Derive the minimal architecture.** Start from invariants and pure core. Push state, I/O, lifecycle, framework details, retries, logging, and wiring outward. Add ports only for real I/O or volatility. Add abstractions only when they hide something real. Add state machines only for lifecycle. Add mechanisms only when they change incentives or protect invariants.

7. **Draw the architecture.** Include mermaid flow/module graph; include `stateDiagram-v2` for lifecycle; show important dependency directions and incentive mechanisms.

8. **Specify modules.** For each module, state responsibility, interface signature, what it hides, dependency category (`pure-core`, `in-process`, `local-substitutable`, `ports-and-adapters`, `true-external`), state ownership, error model, incentive effect, and test strategy.

9. **Run the principle fit check.** Name high-risk principles and how the architecture satisfies or deliberately violates them.

10. **Run the game-theory fit check.** Answer: what behavior is incentivized; what bad behavior is impossible/expensive/loud; what information is exposed; what principal-agent problem exists; what repeated-game failure is prevented; what adversarial move was modeled; what equilibrium should emerge.

11. **State quality attributes.** Include performance, reliability/failure modes, security/least privilege, observability, testability, and migration/compatibility.

12. **State why this is the simplest version.** Name discarded options and why they were too shallow, coupled, speculative, stateful, slow, weak against incentives, or hard to test.

13. **Run architecture self-review before output.** When subagents are available, spawn bounded critic or validator subagents for the highest-risk lenses: boundary ownership, lifecycle/state, failure/concurrency, security/authority, simplicity/deep modules, Effect discipline, and code grounding. Revise the draft before presenting it. If subagents are unavailable, run those lenses locally and state that parallel self-review was unavailable.

14. **State explicit non-goals.**

If you cannot ground a decision, stop and ground it using the strongest available source. Do not guess.

## Output

Use Plain Senior output. Keep the proposal readable and complete enough for `/review`.

````markdown
## Decision
<one sentence naming the architecture>

## Problem
<what is true now, what must remain true, what should become true>

## Why
- Grounding: <repo/doc facts that shaped the design>
- Trade-off: I am trading <X> for <Y>.
- Mechanism: <how the good move becomes cheap and the bad move loud>

## Design
<1-2 paragraphs. Name modules only when they change the decision.>

```mermaid
<flow, module, or state diagram when it clarifies the design>
```

## Example
```ts
<main interface, state type, command shape, or pseudocode>
```

## Proof
- Invariants protected:
- Failure modes:
- Observability:
- Tests:

## Risk
- <remaining risk or explicit trade-off>

## Next
Run `/review` to pressure-test it before opening an issue.
````

Then end with exactly this line and stop:

> Architecture proposed. Run `/review` to pressure-test it before opening an issue.
