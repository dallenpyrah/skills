---
name: teach
description: Teach Dallen a concept, solution, or pattern using his learning style — story → problem → simple version → core principle → examples → precision → wrong-vs-right model → check. Use when Dallen says /teach, asks to learn/understand/study a concept, or asks to be taught the solution you just proposed (architecture, bug fix, design, library behavior).
---

# /teach

## First-principles rule

Think from first principles before following an existing pattern: name what is true now, what must remain true, and what you want to be true, then choose the smallest action that closes the gap. Few-shot: if a task says "add a service," ask "what complexity does this hide?"; if none, do not add it. If a task says "add a fallback," ask "what failure does this mask?"; if it masks failure, model an explicit typed error or recovery path. If a task says "match the existing pattern," ask "which invariant does the pattern protect?"; keep it only if the invariant still applies.


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

Output uses these verbatim headings, in this order. One screen. Plain English before jargon. Examples before abstraction.

```
## The story
<the situation that created the need — concrete, not abstract. No definition yet.>

## The problem
<what breaks or becomes painful without this concept — one paragraph>

## The simplest solution
<the dumbest working version — code, pseudocode, or a one-line description>

## The core principle
<one or two sentences — the load-bearing idea, in plain English>

## Examples
1. <concrete case>
2. <second case from a different angle>
3. <third variation that stresses the pattern>

## The more precise version
<the technical version — refines the simple model, does not replace it>

## Wrong vs right mental model
- Likely wrong model: <one sentence>
- Correct model: <one sentence>
- The gap: <one sentence — what flips between them>

## Where it fails
- Works well when: <bullets>
- Breaks down when: <bullets>

## Check your understanding
1. <diagnostic question — "why does this work" / "where would this fail" / "what changes if X changes">
2. <second question, different angle>
3. <teach-back OR build-the-smallest-version prompt>
```

## Rules

- **Context before definition.** Never lead with "X is a Y that does Z." Lead with the situation.
- **Examples before abstraction.** Name the pattern *after* the examples, not before.
- **Define jargon inline on first use, six words max — or do not use it.**
- **Analogies must be structural.** Map → predict → break. If the analogy does not help predict behavior, cut it.
- **Three questions max at the end.** Probe, not quiz.
- **One screen.** If it overflows, the topic is too broad — narrow it and ask which sub-concept to teach next.
- **No hedging filler.** Strip "essentially," "basically," "it's worth noting." Say the thing.

## Output

The rendered explanation is the output. End with exactly this line and stop:

> Teach delivered. Answer the check questions, or ask for the next layer.
