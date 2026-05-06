---
name: interview
description: "Pressure-test a problem and the user's intended solution direction in five-question rounds, after /scout, before /contract. Use when the user types /interview, when scope is fuzzy, when there is no locked problem statement, or when assumptions need surfacing. Uses first-principles decomposition, game-theoretic incentive analysis, 5 Whys, laddering, and Socratic pressure. Writes 02-interview.md and hands off to /contract."
---

# /interview

Relentless, unscripted grill. One question at a time until the problem, values, constraints, non-goals, incentives, failure modes, and intended solution direction are locked.

## When this fires

- The user types `/interview` (with or without a topic)
- A `/scout` artifact exists and the workflow is moving forward
- The problem statement is still fuzzy enough that designing now would be expensive theater

## Position in the workflow

Previous: `/scout`. Next: `/contract`. See `/compound-workflow`.

## Preconditions

- A scout artifact at `<run-dir>/01-scout.md`, or — if scout was skipped — equivalent grounding in conversation that you reconstruct in this artifact and label `conversation-derived`
- A topic, issue, PR, area, bug, or feature concern

## Stance

- One question at a time. Wait for the answer before the next.
- Five-question rounds. After each round, summarize what is now locked and what is still fuzzy.
- Use the user's words. If they say "workspace", do not invent "tenant".
- Apply `/first-principles` and `/game-theory` continuously: facts/invariants on one side, players/incentives on the other.
- Pressure direction, not the user. Challenge assumptions, not motives.
- When the user says "I want X", ask what X solves and what would invalidate X.

## Question patterns

Cycle through these without announcing them:

- **5 Whys** — "Why does that matter? Why now? Why not the alternative?"
- **Laddering** — abstract → concrete and back. "What does success look like in one sentence?" → "Show me the smallest example."
- **QFT-style selection** — generate many candidate questions, then pick the highest-leverage one.
- **Socratic pressure** — restate the user's claim and ask what would falsify it.
- **Constraint discovery** — budgets, deadlines, compatibility, performance, security, headcount, vendor lock-in.
- **Non-goals** — "What must this *not* do?"
- **Incentive surfacing** — "Who else has to live with this? What would they choose if forced?"

## Required coverage

By the end of the interview, the artifact should record explicit user-confirmed answers for:

1. Problem in one sentence
2. Who the players are and what each wants (see `/game-theory`)
3. Invariants — what must remain true after the change
4. Constraints — budgets, compatibility, performance, security, deadlines
5. Non-goals — what is explicitly out of scope
6. Failure modes the user has seen or fears
7. Acceptance criteria — what the user will use to call this done
8. Solution direction — the user's intended approach (not the locked design)
9. Open risks — assumptions still untested

If any item is unanswered after five rounds, name it as **open** in the artifact rather than fabricating an answer.

## When to stop

Stop interviewing when:

- All eight required items have user-confirmed answers, and
- A new round would produce restated answers, not new ones, and
- `/contract` could be written without further user input

## Artifact shape

Write `<run-dir>/02-interview.md`:

- **Problem (one sentence)**
- **Players and incentives** (table)
- **Invariants** (list)
- **Constraints** (list with units)
- **Non-goals**
- **Failure modes named**
- **Acceptance criteria**
- **User's intended solution direction** (verbatim or close)
- **Open risks / unanswered questions**
- **Issue candidates** per `/issue-capture`
- **Handoff block** per `/artifact-protocol`

## Rules

- One question per turn.
- After each five-question round, summarize lock + fuzzy.
- Do not propose architecture yet. If the user proposes architecture, capture it under "intended solution direction" and continue.
- Do not assume. Ask.
- Do not paraphrase the user's invariant; quote it.

## Composition

References: `/first-principles`, `/game-theory`, `/artifact-protocol`, `/issue-capture`, `/compound-workflow`.

## Final response

End with exactly:

> Interview locked. Continue to `/contract`.
