---
name: teach
description: Teach Dallen a concept, solution, or pattern using his learning style — story → problem → simple version → core principle → examples → precision → wrong-vs-right model → check. Use when Dallen says /teach, asks to learn/understand/study a concept, or asks to be taught the solution you just proposed (architecture, bug fix, design, library behavior).
---

# /teach

Before rendering user-facing output, read `../_shared/plain-output.md`.

Teach a specific concept using the `dallen-learning-style` profile. That profile owns the *how*. This skill picks the target, grounds it, and renders the template.

## Pick the target

The concept comes from one of these, in order:

1. An explicit topic in the invocation — e.g. `/teach database indexes`, `/teach effect layers`.
2. The active conversation artifact — the architecture from `/architect`, the fix from `/debug`, the design under review, the library you just used.
3. If neither is clear, ask exactly one question: **"What concept should I teach?"** Then stop and wait.

"Teach me everything about X" is not a target — narrow it to one load-bearing idea first.

## Ground before teaching

If the topic is repo code, library behavior, or an API shape: read the actual code or run `context7` / `gh_grep` before writing. Never teach from training-data assumptions — hallucinated mechanism is worse than no explanation.

## Render

Use Plain Senior output. One screen. Plain English before jargon. Examples before abstraction.

````markdown
## Decision
<the concept in one plain sentence>

## Story
<the situation that creates the need>

## Why
<what breaks without this idea, then the core principle>

## Example
```ts
<small code or pseudocode example>
```

## Mental Model
- Wrong: <likely wrong model>
- Right: <correct model>
- Flip: <what changes>

## Risk
<where the concept breaks down>

## Next
1. <diagnostic question — "why does this work" / "where would this fail" / "what changes if X changes">
2. <second question, different angle>
3. <teach-back OR build-the-smallest-version prompt>
````

## Rules

- **Context before definition.** Never lead with "X is a Y that does Z." Lead with the situation.
- **Examples before abstraction.** Name the pattern *after* the examples, not before.
- **Define jargon inline on first use, six words max — or do not use it.**
- **Analogies must be structural.** Map → predict → break. If the analogy does not help predict behavior, cut it.
- **Three questions max at the end.** Probe, not quiz.
- **One screen.** If it overflows, the topic is too broad — narrow it and ask which sub-concept to teach next.
- **No hedging filler.** Strip "essentially," "basically," "it's worth noting." Say the thing.

## Output

The rendered explanation is the output. It must include a concrete code or pseudocode example. End with exactly this line and stop:

> Teach delivered. Answer the check questions, or ask for the next layer.
