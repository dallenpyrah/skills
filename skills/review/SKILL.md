---
name: review
description: Pressure-test the architecture produced by /architect. Runs two passes — a principle-compliance pass (checks deep modules, no-complect, state machines, ports & adapters, naming) and a parallel reality-check pass (two Explore agents verify referenced code exists and scan for prior work). Proposes a revised architecture. Hands off to /issue when locked.
---

# /review

Review the architecture that `/architect` produced. This is an architecture review, not a code review. Be blunt. The goal is to catch design errors before they become GitHub issues.

## Preconditions

- `/architect` output must be present in the conversation context. If you cannot find an architecture proposal with Problem / Constraints / Core trade-off / Architecture / Modules sections, tell the user to run `/architect` first and stop.

## Pass 1 — Principle compliance

Walk the architecture against every principle from `/architect`'s spine. For each finding, state the principle, the violation, and the suggested fix.

Flag, specifically:
- **Shallow modules.** Any module whose interface is as wide as its implementation. Any wrapper that just forwards. Delete or deepen.
- **Complected concepts.** State braided with value. Transport braided with logic. Query braided with storage. Split them.
- **State in the core.** Any lifecycle or mutable state that lives in the pure core instead of at the edges. Push it out.
- **Lifecycle without a state machine.** Any workflow expressed via booleans/nullables instead of explicit states and transitions.
- **I/O without a port.** Any direct call to the filesystem, network, database, or third-party service from inside a domain module. Extract a port.
- **Naming that describes a wrapper.** `FooManager`, `BarService`, `BazHelper`. Rename to what it is.
- **Unexplained abstractions.** Any module whose answer to "what does it hide?" is "nothing, it's just a rename."

Be blunt. If the architecture is clean, say so in one sentence and move on.

## Pass 2 — Reality check (parallel)

Spawn two Explore agents in parallel, one message, two tool calls:

- **Agent A — Code grounding.** Verify every file, function, type, or symbol the architecture references exists and behaves as assumed. Report any hallucinated or misremembered references.
- **Agent B — Prior art.** Scan git log and the existing `skills/` directory for prior work, adjacent patterns, or existing utilities that should be reused instead of reinvented.

Both agents return short reports (< 300 words each).

## Synthesis

Merge Pass 1 findings + Pass 2 reports into a single review. If edits are warranted, propose a revised version of each affected section of the architecture. Present the diff clearly.

The user accepts or iterates. On acceptance, restate the locked architecture in one final message so `/issue` can find it in conversation context.

End with exactly this line and stop:

> Architecture locked. Run `/issue` to open the GitHub issue.
