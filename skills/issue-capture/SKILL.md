---
name: issue-capture
description: "Reference for the Boy Scout rule: capturing unrelated verified decay without derailing the current phase. Use when a skill says 'capture issue candidates', when you spot a stale doc / dead helper / duplicate source of truth / unsafe shortcut while doing other work, or when the user asks 'should I open an issue for this'. Every workflow phase references this skill."
---

# /issue-capture

Every skill participates in leaving the codebase better than it found it. When unrelated verified decay shows up in evidence, capture it without derailing the current phase.

## When this fires

- A workflow skill says "append to issue-candidates" or "capture Boy Scout issues"
- During scout, review, refactor, delete, or learn, an unrelated problem becomes visible
- The user asks "should I file an issue for this"

## What to capture

Capture an issue candidate when you find unrelated but verified:

- broken behavior
- stale docs or examples
- duplicate source of truth
- misleading interface
- unsafe shortcut
- security risk
- performance regression risk
- dead code
- boundary violation
- flaky or missing test
- confusing folder/package placement
- agent-hostile context (e.g., examples that demonstrate the wrong path)

"Verified" means you cited the evidence. Speculation goes into the artifact's open-questions section, not into issue candidates.

## Quality bar

A candidate must include:

- **Title** — short, action-oriented
- **Evidence** — file path / command output / PR / doc / screenshot
- **Expected behavior** — what should be true
- **Actual / problem behavior** — what is broken, duplicated, misleading, unsafe, slow, or decayed
- **Scope** — the smallest issue that captures the problem
- **Suggested owner / area** — module, package, or person if known
- **Risk if ignored** — why this will decay or create bad incentives
- **Confidence** — high | medium | low
- **Outside current scope because** — one line of why it does not belong in this run

If you cannot fill these fields with evidence, it is not yet a candidate. Append a scout question to the current artifact instead.

## Action by confidence

- **High confidence, scoped, `gh` available** — invoke `/issue` to open a follow-up issue immediately. Continue the current phase.
- **Medium confidence or unclear scope** — append to `<run-dir>/issue-candidates.md` and let `/learn` or a future `/scout` triage it.
- **Low confidence** — append a scout question to the current phase's artifact, not an issue.

## Append format

Append to `<run-dir>/issue-candidates.md`:

```markdown
---

# <Title>

Captured: <iso-timestamp> by <skill-name>

## Evidence
- <file:line / command output / URL / screenshot>

## Expected behavior
<what should be true>

## Actual / problem behavior
<what is broken, stale, duplicated, misleading, unsafe, slow, or decayed>

## Scope
<smallest issue scope>

## Risk if ignored
<why this will decay or create bad incentives>

## Confidence
high | medium | low

## Outside current scope because
<one-line reason>

## Suggested next skill
/scout | /contract | /architect | /dedupe | /delete | /test-plan | /issue | other
```

Mirror the title in the current phase's handoff block under `issue_candidates:`.

## Anti-patterns

- Capturing speculation. If you cannot cite evidence, do not file.
- Derailing the current phase. The whole point of capture is to defer.
- Filing duplicates. Grep `issue-candidates.md` and recent GitHub issues first.
- Mixing scope. One candidate per problem.
- Vague risk ("this is bad"). Name the equilibrium it creates (see `/game-theory`).

## Composition

This skill is referenced by every workflow phase via `/compound-workflow`. The handoff block format lives in `/artifact-protocol`. Game-theoretic framing for "risk if ignored" lives in `/game-theory`.

## Final response

When invoked directly, end with:

> Issue capture rules loaded. Continue your current phase.
