---
name: scout
description: Pre-/interview grounding for unfamiliar domains. Maps one concrete library, module, external service, API, repo area, or pattern using repo search, tests, node_modules source, official docs, context7, gh_grep, exa, shelf, structural search, first-principles decomposition, and game-theoretic incentive analysis. Produces a one-screen brief. No recommendations yet. Hands off to /interview.
---

# /scout

Before rendering user-facing output, read `../_shared/plain-output.md`.

Map the territory before `/interview`.

Use this when the domain is unfamiliar enough that interviewing would stall on unknown facts: a new library, external service, repo area, architectural pattern, API, migration path, or failure mode.

This skill is not research for research’s sake. It should uncover constraints that would change the architecture.

## Pick the topic

The topic comes from one of:

1. Explicit invocation text, e.g. `/scout effect layers`.
2. The active question the user is stuck on.
3. The linked issue or PR context, if invoked from a workflow.

If the topic is missing, ask exactly one question and stop:

> What domain should I scout?

Bad topics:

- “the codebase”
- “the app”
- “architecture”
- “tests”
- “game theory”

Good topics:

- “Effect Layer usage in this repo”
- “billing webhook idempotency”
- “GitHub PR review comments API”
- “the auth session lifecycle”
- “state modeling for imports”
- “current fallback/default patterns”
- “review comments as a code-health mechanism”

## Scout stance

Be concrete. Cite or do not claim.

The output should help `/interview` ask better questions and help `/architect` avoid hallucinated constraints.

Do not recommend the solution yet.

## Shared contracts

Before parallel exploration, read `../_shared/subagents.md`, `../_shared/evidence-quality.md`, and `../_shared/grounding.md`.

Use host-neutral subagent roles. When subagents are available, use independent explorer subagents for repo evidence, git/GitHub history, dependency/API semantics, external references, failure modes, and incentive analysis. When subagents are unavailable, perform those lanes locally and state that parallel exploration was unavailable.

## First-principles scouting

For the topic, identify:

- primitive facts
- actors
- invariants
- constraints
- irreversible decisions
- state/lifecycle
- external dependencies
- failure modes
- hidden assumptions
- source of truth

## Game-theoretic scouting

For the topic, identify:

- players
- incentives
- local shortcuts
- global costs
- information asymmetries
- principal-agent relationships
- repeated-game risks
- adversarial behavior
- coordination failures
- what the current system makes easy or hard

Examples:

- A broad helper makes local implementation easy but global coupling likely.
- A silent default makes local code pass but hides operational failure.
- A mock-only test makes the author move fast but gives reviewers false confidence.
- A missing port makes a module convenient now but costly to test and migrate later.
- An unclear interface lets callers guess, creating inconsistent behavior over repeated changes.

## Grounding matrix

Run applicable sources in parallel. Skip a source only when its question does not apply, and say why.

| Source | Question it answers |
|---|---|
| repo files/tests with `rg` | What exists here? What names, flows, tests, and conventions are already committed? |
| structural search with ast-grep | What code shapes exist independent of spelling? |
| symbol/type search | Where are the real definitions and call sites? |
| git history | What was tried, reverted, renamed, or migrated? |
| `docs/learnings/` | What has this repo already learned? |
| `skills/` | Is there an existing workflow/pattern to reuse? |
| `node_modules` / installed package source | What does the installed version actually do? |
| package metadata / lockfile | Which version and feature set are actually installed? |
| official docs | What semantics, limits, lifecycle, permissions, pricing, or security behavior are documented? |
| context7 | What is the current version-specific API shape? |
| gh_grep / public code search | How do real projects use this API or pattern? |
| shelf reference repos | Is there cached upstream/reference code? |
| exa / web search | What recent docs, release notes, issue threads, or war stories change the decision? |

## Search procedure

### 1. Local first

Start with repo evidence:

```bash
rg "<topic keywords>"
rg "<type or function name>"
rg "<status/fallback/error/state keyword>"
```

Use `rg -uuu` only when hidden/generated/ignored files are relevant.

### 2. Structural next

Use ast-grep when text search is too shallow:

```bash
ast-grep -p '<pattern>'
```

Use it for:

- broad `try/catch`
- swallowed errors
- raw `Promise` in Effect-owned code
- `extends`
- status booleans/nullables
- direct I/O calls
- direct vendor SDK calls
- default/fallback patterns
- repeated wrapper shapes
- broad manager/service/helper modules
- duplicated source-of-truth patterns

### 3. Definitions and references

Use symbol search, type search, or GitHub Code Search when local navigation is insufficient.

Find defining modules, exported interfaces, call sites, tests, adapters, migration files, and deleted/renamed predecessors.

### 4. Package/source truth

When a library matters:

1. Identify installed version from lockfile/package metadata.
2. Inspect local `node_modules` source/types.
3. Use official docs for semantics.
4. Use context7 for current version-specific docs when available.
5. Use public code search only as supporting evidence, never as source of truth.

### 5. External service truth

When an external service matters, official docs win.

Scout API shape, auth model, rate limits, retry semantics, idempotency, pagination, webhooks, failure modes, permission model, pricing/quotas, eventual consistency, deprecation/versioning, and security constraints.

### 6. Stop condition

Stop when additional research is unlikely to change module boundaries, state model, error model, port/adapter shape, performance constraint, security constraint, migration strategy, incentives, or interview questions.

Do not keep collecting facts for completeness.

## Output

Use Plain Senior output. One screen.

````markdown
## Decision
<domain scouted and the main constraint found>

## Why
- Evidence: <source> — <what it proved>
- Prior art: <repo fact with path>
- Constraint: <fact that changes design or interview questions>

## Example
```bash
<command used to prove the key repo fact>
```

## Risk
<unknown that could change module boundaries, state, errors, ports, performance, or security>

## Next
Open questions for `/interview`:
1. <question the evidence cannot answer>
2. <question>
3. <question>
4. <question>
5. <question>
````

## Rules

- One concrete topic.
- One screen.
- Cite or do not claim.
- Trade-offs, not feature lists.
- No recommendations yet.
- No architecture yet.
- No implementation steps yet.
- Local code and installed source beat memory.
- Official docs beat blog posts for API semantics.
- Public code search shows patterns, not correctness.
- If a source was skipped, say why.
- If evidence conflicts, name the conflict instead of resolving it by guess.
- If a local shortcut creates global cost, surface it.
- If an interface creates bad incentives, surface it.

End with exactly this line and stop:

> Scout brief delivered. Run `/interview` to pressure-test the problem and direction with this context loaded.
