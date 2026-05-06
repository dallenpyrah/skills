---
name: issue
description: "Open the implementation GitHub issue from a locked design after /review, before /work. Body captures architectural intent only — Problem, Game board, Architecture (mermaid), Modules, Verification, Out of scope. Also files Boy Scout follow-up issues that were captured during the run. Use when the user types /issue, when /review is locked, or when issues need to be staged before code is written. Writes 20-issue.md and hands off to /work."
---

# /issue

Open a clean GitHub issue from the locked architecture. The body captures intent only — no implementation steps, no test-plan checklists, no file lists. Implementation belongs in `/work`; tests belong in `/test-plan`.

## When this fires

- The user types `/issue`
- `/review` produced a `locked` verdict
- Boy Scout follow-up issues from `/issue-capture` are ready to be filed

## Position in the workflow

Previous: `/review`. Next: `/work`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/19-review.md` is `locked`
- `gh` is installed and authenticated, or the user has accepted local-only mode
- Repository tracks issues on GitHub (or the equivalent issue tracker is configured)

## Stance

The issue is the contract for `/work`. It must be readable in three minutes by a contributor who has not seen the run. Cite the run's artifacts but do not paste them.

## Implementation issue body

Open one issue with this exact body shape:

```markdown
## Problem

<one to two sentences from /contract — what is true now, what must be true>

## Game board

- Players: <list>
- Local shortcut: <one line>
- Global cost: <one line>
- Desired equilibrium: <one line>
- Mechanism: <one line>

## Architecture

<one sentence summary>

\`\`\`mermaid
<mermaid diagram from /architect, only if it conveys structure prose cannot>
\`\`\`

## Modules

- `<module>` — <one-line responsibility>
- `<module>` — <one-line responsibility>

## Verification

- Acceptance criteria: see `<run-dir>/03-contract.md`
- Test plan: see `<run-dir>/18-test-plan.md`
- Verification commands: <list of shell commands>

## Out of scope

- <non-goal>
- <non-goal>

## Run

`<run-dir>` (artifacts 01-scout.md through 19-review.md)
```

## Boy Scout follow-up issues

For each high-confidence candidate in `<run-dir>/issue-candidates.md`:

- Open a separate issue with the candidate's title and body (per `/issue-capture` schema).
- Tag it `boy-scout` (or the project's equivalent).
- Link it to the implementation issue as a "discovered during run" reference.
- Mark the candidate in `issue-candidates.md` with the issue number.

Medium-confidence candidates stay in `issue-candidates.md` for `/learn` to triage.

## Required output

Write `<run-dir>/20-issue.md`:

### 1. Implementation issue
Number, URL, title, full body that was filed.

### 2. Boy Scout issues filed
Table:

| Candidate title | Issue # | URL | Confidence |
|---|---|---|---|

### 3. Candidates deferred
Candidates left in `issue-candidates.md` with reason.

### 4. Handoff
Block per `/artifact-protocol`, pointing at `/work`. Include the implementation issue number in `required_context`.

## Rules

- One implementation issue per run.
- The body captures intent only: no implementation steps, no file lists, no test checklists.
- Mermaid only when it conveys structural relationship prose cannot.
- Out of scope is explicit (mirrors `/contract` non-goals).
- Boy Scout issues are scoped, separate, and linked.
- Title is short (under 70 characters).

## Anti-patterns

- A "tasks" checklist in the body. Move to `/work`.
- Pasting full architecture artifact into the body. Link instead.
- Bundling unrelated Boy Scout findings into the implementation issue.
- Vague titles ("Improve auth").
- Embedding implementation choices ("Use Redis to store sessions") without justifying them as design.

## Composition

References: `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Tooling: `gh issue create`, `gh issue list`, `gh issue link`.

## Final response

End with exactly:

> Issue opened. Continue to `/work`.
