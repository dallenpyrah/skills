---
name: emil-design-eng
description: "Apply Emil Kowalski-style UI polish: interaction details, component feel, animation restraint, and invisible product quality. Uses progressive disclosure instead of long design essays."
---

# Design Engineering

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Improve how an interface feels by fixing concrete friction, timing, hierarchy, feedback, and interaction details.

## Inputs

UI code, screenshot, component, interaction, animation, or user request for polish/design engineering.

## Reads

Existing UI implementation, screenshots/browser state, component library conventions, animation references when needed.

## Writes

- UI/code changes when asked to implement
- `.context/design-eng.md` for audit notes and rejected polish ideas
- `.context/session-state.md` for substantial work

## Process

1. Inspect the actual UI/code before judging.
2. Identify the smallest polish changes that make behavior clearer or more responsive.
3. Prefer restraint: animation and visual detail must carry purpose.
4. Verify interaction timing, hover/focus/pressed states, loading/empty/error states, and reduced-motion behavior when relevant.
5. Put detailed audit notes in `.context/design-eng.md`; keep chat to the highest-impact fixes.

## Review Format

When reviewing UI, use a compact table only if it improves scanning:

| Before | After | Why |
|---|---|---|
| `<issue>` | `<change>` | `<reason>` |

Respect the attention budget: no more than eight rows in chat.

## Operator Output

Return the design decision or implemented polish, up to three evidence bullets, remaining risk, and next action. For pure review, include only the top issues in chat and write the rest to `.context/design-eng.md`.

## Stop Conditions

Stop if the UI cannot be inspected, the target audience/workflow is unknown and materially changes the design, or verification cannot run for a risky interaction.
