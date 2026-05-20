---
name: emilkowal-animations
description: Apply Emil Kowalski-style animation guidance for web interfaces: purposeful motion, correct easing, interruptibility, performance, reduced motion, and interaction feel.
---

# Animation Best Practices

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Use motion only when it improves orientation, feedback, continuity, or perceived responsiveness.

## Inputs

Animation request, UI component, gesture, transition, toast, drawer, tab, scroll reveal, or motion review.

## Reads

Existing implementation, browser behavior when available, framework/library docs, and targeted reference files under `references/` only for the specific animation type.

## Writes

- animation code changes when asked
- `.context/animations.md` for timing decisions and QA notes
- `.context/session-state.md` for substantial work

## Process

1. Decide the purpose of the motion: feedback, orientation, continuity, hierarchy, or explanation.
2. Check frequency: repeated UI motion must be faster and quieter than rare explanatory motion.
3. Prefer transform/opacity; avoid layout-heavy animation.
4. Make interactions interruptible.
5. Respect reduced motion.
6. Verify timing and feel in browser when implementing.
7. Load only the relevant reference file, such as `references/ease-out-default.md`, `references/timing-300ms-max.md`, or `references/polish-reduced-motion.md`.

## Defaults

- Most UI transitions finish within 300ms.
- Use ease-out for entering feedback and context-specific easing for drawers/gestures.
- Avoid bounce except for playful or physical drag interactions.
- Never animate keyboard response in a way that delays input.

## Operator Output

Return the motion decision or implemented change, up to three evidence bullets, remaining risk, and next action. Put detailed timing notes in `.context/animations.md`.

## Stop Conditions

Stop if the motion has no clear purpose, would harm frequent workflow use, or cannot be verified enough to judge feel.
