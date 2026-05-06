---
name: scout
description: "Ground an engineering workflow before /interview. Researches repo reality, official docs, tests, prior issues/PRs, learnings, examples, external APIs, risks, incentives, unknowns, and evidence quality. Use when the user types /scout, when the domain is unfamiliar enough that interviewing would stall on unknown facts, or when starting a new compound-engineering run. Writes 01-scout.md and hands off to /interview."
---

# /scout

Map reality before asking questions or designing. Prevents hallucinated constraints, stale assumptions, and interviews that waste time on facts the repo or official docs already answer.

## When this fires

- The user types `/scout <topic>`
- The domain is unfamiliar (new library, external service, repo area, pattern, migration path, failure mode)
- A run is being started and `/interview` would stall without grounding

If the topic is missing, ask exactly one question and stop:

> What domain should I scout?

## Position in the workflow

Previous: none — this starts the chain.
Next: `/interview`.

See `/compound-workflow` for the full chain and the not-applicable rule.

## Pick a concrete topic

Reject vague topics ("the codebase", "architecture", "tests"). Convert them into something specific:

- "Effect Layer usage in this repo"
- "billing webhook idempotency"
- "GitHub PR review comments API"
- "the auth session lifecycle"
- "current fallback / default patterns"

A scout topic is good when `/interview` could ask a sharp locking question after reading the brief.

## Run setup

Resolve or initialize the run directory per `/artifact-protocol`. Then write this skill's artifact at `<run-dir>/01-scout.md`.

## Stance

Cite or do not claim. Local code and installed source beat memory. Official docs beat blog posts for API semantics. Public code search shows patterns, not correctness. Do not recommend the architecture yet.

Apply `/first-principles` (facts, invariants, constraints, irreducible problem) and `/game-theory` (players, incentives, asymmetries, bad equilibria) as you go.

## Grounding matrix

Run applicable sources in parallel. If a source is skipped, say why.

| Source | Question it answers |
|---|---|
| repo files / tests via `rg` | What exists here? What names, flows, tests, conventions are committed? |
| ast-grep | What code shapes exist independent of spelling? |
| symbol/type search | Where are real definitions and call sites? |
| git history | What was tried, reverted, renamed, migrated? |
| `docs/learnings/` | What has this repo already learned? |
| `skills/` | Is there an existing workflow/pattern to reuse? |
| `node_modules` source | What does the installed version actually do? |
| package metadata / lockfile | Which version and feature set are installed? |
| official docs | Semantics, limits, lifecycle, permissions, pricing, security |
| context7 | Current version-specific API shape |
| gh_grep / public code search | How real projects use this API |
| shelf reference repos | Cached upstream/reference code |
| exa / web | Recent docs, release notes, war stories |

## Search procedure

1. **Local first.** `rg "<keyword>"`, `rg "<TypeOrFn>"`, `rg "<error|fallback|state>"`. Use `rg -uuu` only when hidden/generated files matter.
2. **Structural next.** `ast-grep -p '<pattern>'` for shape-based search: swallowed errors, raw `Promise` in Effect-owned code, `extends`, status booleans, direct vendor SDK calls, default/fallback patterns.
3. **Definitions and references.** Symbol search, type search, GitHub Code Search.
4. **Package source truth.** Lockfile → installed `node_modules` source → official docs → context7 → public code search (supporting evidence only).
5. **External service truth.** Official docs win. Scout API shape, auth, rate limits, retries, idempotency, pagination, webhooks, failure modes, permissions, quotas, eventual consistency, deprecation, security.
6. **Stop condition.** Stop when more research is unlikely to change module boundaries, state model, error model, port/adapter shape, performance / security constraint, migration strategy, incentives, or interview questions.

## Artifact shape

Write `<run-dir>/01-scout.md` with these sections (one screen where possible):

- **Topic and scope** — one sentence, why now
- **Evidence map** — sources consulted; tag each with the level from `/artifact-protocol` (repo / official / paper / community / inference)
- **Repo findings** — what exists, what is missing, what was tried/abandoned, with file paths and commits
- **External / official findings** — semantics, limits, failure modes
- **Facts vs assumptions vs unknowns** — labeled separately
- **Source-of-truth candidates** — for each concept that affects design
- **Game board** — players, incentives, asymmetries, bad local move, global cost (see `/game-theory`)
- **Failure / risk map** — what could break and why
- **Library / API / pattern landscape** — top 2–3 options with trade-offs, not feature lists
- **Open questions for /interview** — five precise locking questions
- **Issue candidates** — capture per `/issue-capture`
- **Handoff block** per `/artifact-protocol`

## Rules

- One concrete topic.
- One screen where possible; link, don't inline, when more is needed.
- Cite or do not claim.
- Trade-offs, not feature lists.
- No recommendations yet.
- No architecture yet.
- If sources conflict, name the conflict; do not resolve by guess.
- If a local shortcut creates global cost, surface it.

## Composition

References: `/first-principles`, `/game-theory`, `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations in `/research-bibliography`.

## Final response

End with exactly:

> Scout complete. Continue to `/interview`.
