---
name: game-theory
description: "Reference checklist for game-theoretic / mechanism-design reasoning about code. Use when a workflow skill says 'analyze the game board' or 'check incentives', when reviewing an interface, error, doc, or test for what behavior it rewards, or when the user asks how a change shifts incentives. Other skills (/scout, /architect, /review, /code-review, etc.) reference this one."
---

# /game-theory

Reference card for treating a codebase as a mechanism that shapes strategic behavior. Every interface, error, doc, test, comment, lint rule, and review comment changes the incentives of future users, developers, agents, reviewers, maintainers, and attackers.

## When this fires

- A workflow skill says "analyze the game board" or "apply game theory"
- A change is being justified by feature-completeness, not behavior shift
- The user asks "what equilibrium does this create?", "what shortcut will future contributors take?", or similar
- A reviewer needs to ask why a local-good move creates a global-bad outcome

## The minimal vocabulary

| Concept | Engineering translation |
|---|---|
| Players | users, developers, agents, maintainers, reviewers, CI, attackers, vendors, future contributors |
| Actions | API calls, imports, config edits, retries, comments, branch names, tool calls, merges |
| Payoffs | speed, correctness, safety, review approval, convenience, cost, clarity, authority, support burden |
| Information asymmetry | one actor knows state, docs, constraints, or danger another lacks |
| Bad local move | action that helps the actor now but harms global code health |
| Bad equilibrium | repeated local shortcuts become the stable default |
| Desired equilibrium | the easiest repeated action is also the globally healthy one |
| Mechanism | interface, type, test, doc, lint rule, boundary, issue, error, permission, log, workflow gate |

## The required game-board questions

Walk these for every non-trivial change:

1. Who can act here?
2. What do they want locally?
3. What information do they lack?
4. What shortcut will they take under time pressure?
5. What observable behavior will users depend on? *(Hyrum's law)*
6. What will agents cargo-cult from nearby examples?
7. What can an adversary fake, replay, inject, exfiltrate, or escalate?
8. What makes the good move cheap?
9. What makes the bad move impossible, loud, or recoverable?
10. What happens after the 20th future change?

## Mechanisms that shift incentives

When the analysis shows a bad equilibrium, reach for one of these — pick the smallest that flips the incentive:

- Narrow public entry points; private internals
- Types/schemas/constructors that reject invalid state
- Typed errors with recovery instructions, not silent fallbacks
- Tests that fail on the shortcut path, not just the happy path
- Docs/examples that demonstrate only the canonical use
- Lint/import rules for dependency direction
- Explicit ownership and source-of-truth records
- Permission checks and fail-safe defaults
- Idempotency keys, queues, backpressure, cancellation
- Metrics/traces/logs that expose failure cheaply
- Deletion of obsolete affordances (so they cannot be cargo-culted)

## Output shape

When a skill applies this checklist, the artifact records:

- **Players** — who acts in this surface
- **Local payoff for each player** — what they want, right now
- **Information asymmetries** — who knows what
- **Bad local move** — the tempting shortcut
- **Global cost** — what breaks at scale or over time
- **Desired equilibrium** — the behavior the design should reward
- **Mechanism chosen** — which lever from the list above, and why it is the smallest one that flips the incentive

## Common failure modes this catches

- Broad helpers that make local code easy and global coupling likely
- Silent defaults that pass tests but hide operational failure
- Mock-only tests that move the author fast and give reviewers false confidence
- Public option bags that bypass policy
- "Clever" examples that future agents copy verbatim into hot paths
- Error messages that name the symptom, not the fix
- Docs that describe the happy path and bury the failure modes

## Composition

`/game-theory` is the partner to `/first-principles`. Facts and invariants come from `/first-principles`; players and incentives from `/game-theory`. Both run on every non-trivial design or review pass.

For deeper field guides on what proper domain modeling, boundary design, state modeling, etc. look like under this lens, see `/core-field-guides`.

## Reference anchors

- Hyrum's Law — *all observable behaviors will be depended on*
- Saltzer & Schroeder, *Protection of Information* — fail-safe defaults, least privilege, complete mediation
- Mechanism design literature — equilibrium engineering, not just rule-writing

(See `/research-bibliography` for the full citation set.)
