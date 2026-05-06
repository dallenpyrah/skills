---
name: code-review
description: "Multi-lens PR review after /pr, before /address. Six reviewer personas (correctness, testing, maintainability, project-standards, security, previous-findings) read the diff and post inline + summary comments via gh. Use when the user types /code-review, when a PR is ready for review pressure, or when a coherence pass is needed before requesting human review. Writes 26-code-review.md and hands off to /address."
---

# /code-review

Apply six independent perspectives to the diff. Dedup, validate that each comment can be posted on a real diff line, and post one GitHub review with summary + inline comments. No autofix; no approval; no request-changes.

## When this fires

- The user types `/code-review`
- A PR exists from `/pr` and CI is green
- A pre-human review pass is wanted

## Position in the workflow

Previous: `/pr`. Next: `/address`. See `/compound-workflow`.

## Preconditions

- The PR is open and CI checks pass (or are explicitly accepted-failing)
- The diff is fetchable: `gh pr diff <number>` works
- `gh api repos/<owner>/<repo>/pulls/<number>` returns metadata

## Stance

Each persona reads the diff with first-principles and game-theoretic pressure. Reviews are evidence-based: every comment cites a file and line, names the principle violated, and proposes the smallest fix.

## The six personas

Run in parallel; each produces findings independently.

### 1. Correctness
- Logic errors, off-by-one, type / null / undefined hazards
- Missing error handling, swallowed errors
- Wrong invariant enforcement
- Race / lost-update / stale-read hazards (anchors `/concurrency`)

### 2. Testing
- Are tests named in `/test-plan` actually present and passing?
- Tests verify the failure path, not just the happy path
- Mocks only at trust boundaries
- Property tests for state machines and parsers
- Coverage is a floor, not a target

### 3. Maintainability
- Single source of truth respected (anchors `/dedupe`)
- Deep modules with narrow interfaces (anchors `/architect`, `/interface`)
- Boundaries respected (anchors `/boundary`, `/dependency`)
- No premature abstraction
- Naming consistent with `/domain-model` ubiquitous language

### 4. Project standards
- AGENTS / CLAUDE files honored
- Lint / formatting rules pass
- Effect discipline (when Effect-first): Effect primitives in Effect-owned code
- Stack defaults followed (or deviation justified)

### 5. Security
- Trust boundaries respected (anchors `/security`)
- No new secret / PII exposure in logs / errors / traces
- Capability scope respected for agent / tool calls
- Injection surfaces canonicalized

### 6. Previous findings
- Read `docs/learnings/`
- Confirm prior incidents are not being replayed
- Confirm prior architectural decisions are honored or explicitly revisited

## Procedure

### 1. Fetch the diff
- `gh pr diff <number>` — the full diff
- `gh pr view <number> --json baseRefName,headRefName,files` — file list
- Read each touched file at HEAD for context (the diff is not enough for review)

### 2. Run the six personas
- Each persona produces findings tagged with file:line, severity, principle
- Severities: `must-fix`, `should-fix`, `consider`, `nit`

### 3. Dedupe
- Two personas catching the same issue collapse to one comment
- Tag the comment with all the personas that found it (tells the author the lens)

### 4. Validate
- Every inline comment must point at a line that exists in the diff (use diff hunks, not file lines)
- Comments that cannot be inlined become summary-section bullets

### 5. Post one review
- `gh pr review <number> --comment --body "$(cat <<'EOF' ... EOF)"` for the summary
- `gh api ... pulls/<number>/comments` for each inline comment
- Do **not** approve; do **not** request changes; this skill leaves both decisions to humans

## Required output

Write `<run-dir>/26-code-review.md`:

### 1. Persona findings
Per persona: list of findings with file:line, severity, principle, suggested fix.

### 2. Posted review
- Review URL
- Summary body posted
- Inline comments table (file:line, severity, body)

### 3. Out-of-scope findings
Issues unrelated to this PR captured per `/issue-capture`.

### 4. Handoff
Block per `/artifact-protocol`, pointing at `/address`. Include the review URL in `required_context`.

## Rules

- Six personas, run independently.
- Every comment cites file:line, principle, and a smallest-fix proposal.
- Inline only when the comment can map to a diff line.
- No autofix. No approval. No request-changes.
- Dedup before posting.
- One review per pass.
- Reviewers pressure assumptions, not authors.

## Anti-patterns

- Three personas posting the same comment.
- Comments that say "this is bad" without naming the principle and the fix.
- Comments on lines that the diff did not touch.
- Approving the PR; that is for humans.
- "Looks good to me" with no findings; the personas should at least have nits or note the strong points.

## Composition

References: `/architect`, `/boundary`, `/dependency`, `/dedupe`, `/state-model`, `/interface`, `/concurrency`, `/security`, `/performance`, `/observability`, `/test-plan`, `/first-principles`, `/game-theory`, `/core-field-guides`, `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Tooling: `gh pr diff`, `gh pr review`, `gh api`.

## Final response

End with exactly:

> Review posted. Continue to `/address`.
