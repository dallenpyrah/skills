---
name: compound-workflow
description: "Reference map of the full compound-engineering chain (/scout through /merge) and the rationale for the order. Use when a workflow skill says 'continue the chain', when the user asks 'what comes next' or 'why this order', or when handing off between phases. Each individual phase skill references this map for the not-applicable rule and ordering rationale."
---

# /compound-workflow

The chain that turns one ambiguous request into reviewed, merged, and learned-from code.

## When this fires

- A workflow skill needs to point at the next phase
- The user asks "what's the order" or "do I have to run all of these"
- A phase wants to skip itself; the not-applicable rule lives here

## The chain

```
/scout → /interview → /contract → /domain-model → /architect → /boundary →
/dependency → /dedupe → /state-model → /interface → /value-map → /concurrency →
/security → /performance → /observability → /refactor → /delete → /test-plan →
/review → /issue → /work → /verify → /docs → /example → /pr → /code-review →
/address → /learn → /merge
```

29 phases. Each phase writes one artifact and a handoff (see `/artifact-protocol`).

## Why this order

1. **Scout** before asking, because code and official docs answer many questions better than the user can.
2. **Interview** before contract, because ambiguity should be surfaced before it is frozen.
3. **Contract** before design, because architecture against fuzzy intent is expensive theater.
4. **Domain model** before architecture, because wrong concepts create wrong modules.
5. **Architecture / boundary / dependency / dedupe / state / interface** before implementation, because these decisions define the game future contributors will play.
6. **Value / concurrency / security / performance / observability** before tests, because proof must include value, time, adversaries, budgets, and diagnostics.
7. **Refactor / delete** before test-plan, because adding a feature should also remove obsolete affordances.
8. **Test-plan / review / issue** before work, because issue-driven agents need a precise contract.
9. **Work / verify / docs / example / PR** before code review, because reviewers need evidence.
10. **Code-review / address / learn / merge** closes the loop and turns discovered friction into compounding memory.

## The not-applicable rule

Every phase is required, but some may be materially not applicable for a given run. In that case the skill still writes its artifact, with:

- why it is not applicable
- evidence checked
- risks if the assumption is wrong
- handoff to the next skill

**Do not skip the phase silently.** Silent skips destroy the audit trail that makes the workflow compound.

## Alternative entry points

Two entry points bypass the head of the chain:

- **`/debug`** — reproduce-first bug investigation. Hands off to `/pr → /code-review → /address → /learn → /merge`.
- **`/incident`** — production-pressure containment (rollback / flag-off / disable). Hands off to `/debug` if the underlying bug still needs fixing, or `/learn` if rollback was the fix.

These are real exits from the standard chain, not skips. Document them in the artifact.

## Run state

Each invocation of the chain creates a run directory:

```
.agents/runs/<yyyy-mm-dd>-<slug>/
  index.md
  handoff.yaml
  issue-candidates.md
  01-scout.md
  02-interview.md
  ...
  29-merge.md
```

This is project-local state, not shared skill content. Each project that uses the workflow keeps its own `.agents/runs/`.

To start a run, create the directory with bash:

```bash
SLUG="workspace-config-redesign"
RUN_ID="$(date +%Y-%m-%d)-${SLUG}"
mkdir -p .agents/runs/"$RUN_ID"
echo ".agents/runs/$RUN_ID" > .agents/runs/CURRENT
```

Then write `index.md`, `handoff.yaml`, and `issue-candidates.md` per `/artifact-protocol`.

## Boy Scout obligation

Every phase may surface unrelated decay (stale doc, dead helper, broken example, duplicate source of truth). Capture it in `issue-candidates.md` per `/issue-capture`. Do not derail the current phase.

## Composition

This skill is the chain map. The actual phase content lives in each phase's own SKILL.md. Cross-cutting reference cards: `/first-principles`, `/game-theory`, `/core-field-guides`, `/artifact-protocol`, `/issue-capture`, `/research-bibliography`.

## Final response

When invoked directly, end with:

> Workflow map shown. Continue from your current phase, or start at `/scout`.
