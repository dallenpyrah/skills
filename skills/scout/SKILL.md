---
name: scout
description: Pre-/interview grounding for unfamiliar domains. Maps prior art in this repo, the library/pattern landscape, and discovered constraints into a one-screen brief that feeds /interview with context. Use when the user can't yet articulate the trade-off space — new library, new external service, new pattern, or a corner of the repo you haven't read.
---

# /scout

Map the territory before the interview. Use this when the domain is unfamiliar enough that `/interview` would grind on "I don't actually know what's possible here" — a new library, a new external service, a new pattern, or a part of the repo you haven't read.

This is not research-for-research's-sake. The output is a one-screen brief that feeds the next skill — nothing more.

## Pick the topic

The topic comes from one of:

1. An explicit phrase in the invocation (e.g. `/scout effect layers`, `/scout the billing module`).
2. The active question the user is stuck on.
3. If neither is clear, ask exactly one question: **"What domain should I scout?"** Then stop.

"Scout the codebase" is not a topic. Narrow to one concrete thing — a library, a module, a pattern, an external service.

## Ground in parallel

Run all applicable grounding tools in parallel (one message, multiple tool calls). Each owns a different question:

| Tool | Question it answers |
|---|---|
| **context7** | What is the official shape / API / valid options? |
| **gh_grep** | What does real-world usage look like? Are there idiomatic patterns? |
| **ast-grep** or `grep` in the current repo | What already exists here? What patterns has this codebase committed to? |
| **exa** | What's the current landscape? Alternatives? Known war stories or version-specific gotchas? |

Skip a tool if its question doesn't apply (e.g. `gh_grep` for a private internal library), but say so explicitly — silently skipping looks like an oversight.

## Render the brief

Output uses these verbatim headings, one screen:

```
## Domain
<one sentence — what we're scouting and why now>

## Prior art in this repo
<what exists, what's missing, what was clearly attempted-and-abandoned. Cite file paths.>

## Library / pattern landscape
<top 2-3 options. For each: one-line description, one-line trade-off. The trade-off is what matters.>

## Constraints discovered
<bullets — what must remain true based on existing code, framework choices, deployed state, AGENTS.md rules>

## Open questions for /interview
<3-5 questions the brief surfaced but cannot answer alone. The interview will pressure-test these.>
```

## Rules

- **One screen.** If the brief overflows, you're scouting too broad. Narrow and rerun.
- **Cite or don't claim.** Every "this exists" or "this is idiomatic" needs a file path or a tool result. Hallucinated prior art is worse than no brief.
- **Trade-offs, not features.** "Library X has more stars" is noise. "Library X requires a runtime, Library Y is compile-time-only" is signal.
- **No recommendations yet.** `/scout` maps the territory; `/interview` and `/architect` decide the path.

## Output

The rendered brief is the output. End with exactly this line and stop:

> Scout brief delivered. Run `/interview` to pressure-test the problem and direction with this context loaded.
