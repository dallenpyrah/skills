---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use for web components, pages, dashboards, applications, posters, HTML/CSS layouts, or styling/beautifying web UI while avoiding generic AI aesthetics.
license: Complete terms in LICENSE.txt
---

# Frontend Design

Read the shared contracts before output: `../_shared/operator-output.md`, `../_shared/attention-budget.md`, `../_shared/evidence-record.md`, `../_shared/state.md`, `../_shared/cognitive-load.md`, `../_shared/collaboration.md`.

## Purpose

Build a usable interface that fits the product, audience, and workflow.

## Inputs

User request, existing UI/codebase, design references, target audience, technical constraints, or attached assets.

## Reads

Existing components/styles, package/framework conventions, design assets, relevant screenshots, and browser verification results when available.

## Writes

- frontend code/assets
- `.context/frontend-design.md` for design rationale and visual QA notes
- `.context/session-state.md` for substantial work

## Process

1. Inspect existing UI patterns before designing.
2. Choose one clear aesthetic direction tied to the domain.
3. Build the actual usable experience, not a marketing shell unless requested.
4. Use real/generative visual assets when the experience needs visual substance.
5. Keep controls complete and ergonomic for the target workflow.
6. Verify responsive layout, text fit, overlap, and critical interactions with the tightest available browser/screenshot loop.
7. Put design rationale, rejected directions, and QA notes in `.context/frontend-design.md`.

## Design Rules

- Avoid generic AI aesthetics, default font/color choices, and decorative noise.
- Match density to domain: operational tools should be quiet and scannable; games/creative tools may be expressive.
- Prefer familiar controls: icons for tools, toggles for booleans, sliders/inputs for numbers, tabs for views, menus for option sets.
- Do not nest cards inside cards.
- Do not use decorative orbs, blobs, or bokeh backgrounds.
- Do not scale font size with viewport width.
- Keep text inside its container on mobile and desktop.
- Use icons from the app's icon library when available.
- Use Three.js for primary 3D scenes and verify the canvas is nonblank and framed.

## Operator Output

Return what was built, up to three evidence bullets including verification, remaining risk, and how to view/run it. Put detailed design notes in `.context/frontend-design.md`.

## Stop Conditions

Stop if required product intent or assets are missing and cannot be reasonably inferred, or if visual verification cannot run for a UI change that needs it.
