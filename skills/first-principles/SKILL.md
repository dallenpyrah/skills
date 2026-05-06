---
name: first-principles
description: "Reference checklist for first-principles design reasoning. Use when a workflow skill says 'apply first principles', when triaging a fuzzy problem, when choosing between competing patterns, or when the user asks for first-principles analysis. Other skills (/scout, /architect, /review, etc.) reference this one instead of restating the questions."
---

# /first-principles

Reference card for first-principles reasoning. Other skills load this when they need a stable checklist; users invoke it directly when a problem feels stuck on inherited assumptions.

## When this fires

- A workflow skill says "apply first principles" or "decompose from first principles"
- A design choice is being justified by analogy ("we always do it this way") rather than the actual constraints
- The user explicitly asks for first-principles analysis

## What first-principles means here

Strip the problem to facts and constraints, then derive the simplest mechanism that satisfies them. Resist patterns that arrived by habit, framework default, or copy-paste from a sibling module.

## The ten questions

Walk these in order. Skipping is allowed only if the answer is genuinely already in evidence.

1. **What is true now?** Cite repo state, observed behavior, or a primary-source doc. Not memory.
2. **What must remain true?** Invariants that any solution must preserve.
3. **What is the irreducible problem?** Strip framing, restate in plain English in one sentence.
4. **What facts are grounded vs assumed?** Label each. Do not advance until material assumptions are flagged.
5. **What invariant is being protected?** Name it. If you cannot, the design is decorative.
6. **What volatile decision should be hidden?** That is where the abstraction goes.
7. **What complexity is real, and what is self-created?** Self-created complexity is the first cut.
8. **What is the smallest mechanism that satisfies the constraints?** Default to delete, not add.
9. **What should be impossible, loud, or recoverable?** Each failure mode picks one.
10. **What can be deleted?** Always ask; the absence of the question is how legacy accretes.

## Output shape

When a skill applies this checklist, the artifact should record:

- **Facts** — claims with evidence (file path, command output, doc URL, prior decision)
- **Assumptions** — claims that are believed but not verified; flag risk
- **Invariants** — what must remain true after the change
- **Constraints** — budgets, deadlines, compatibility, performance, security
- **The irreducible problem** — one sentence
- **The smallest mechanism** — described before any pattern is named
- **Failure-mode triage** — for each known failure: impossible / loud / recoverable

Lead with the one-sentence problem. Resist preamble.

## Common failure modes this catches

- Designing against a framework default instead of the actual constraint
- Importing a pattern (DDD, hexagonal, CQRS) before naming what is volatile
- Treating an analogy as evidence ("this is like the auth flow") without checking the comparison
- Adding an abstraction that hides nothing (a rename or pass-through)
- Persisting derived state without naming the lifecycle that justifies it

## Composition

Most workflow skills reference `/first-principles` alongside `/game-theory`. The pair is the design spine: facts and invariants from `/first-principles`, players and incentives from `/game-theory`. Together they answer "what is the smallest mechanism, and what equilibrium does it create?"

When deeper grounding on specific design activities is needed, see `/core-field-guides`.

## Reference anchors

- David Parnas, *On the Criteria To Be Used in Decomposing Systems into Modules* — modules hide design decisions likely to change
- John Ousterhout, *A Philosophy of Software Design* — deep modules, narrow interfaces, complexity as the enemy
- Edsger Dijkstra, *Notes on Structured Programming* — structure mirrors proof obligations

(See `/research-bibliography` for the full citation set.)
