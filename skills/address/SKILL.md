---
name: address
description: "Triage and execute on PR review comments after /code-review, before /learn. Each comment becomes Address / Push-back / Escalate / Follow-up. Push-back must cite a specific principle. Address produces a code change and silent thread resolution. Watches CI after push. Use when the user types /address, when review comments need to be worked through, or when CI is failing after review fixes. Writes 27-address.md and hands off to /learn."
---

# /address

Work through review comments. Triage runs autonomously: print the table for transparency, then execute. The user can interrupt; silence is consent.

## When this fires

- The user types `/address`
- A `/code-review` produced comments, or human reviewers commented on the PR
- CI is failing after a review fix push and needs to go green again

## Position in the workflow

Previous: `/code-review`. Next: `/learn`. See `/compound-workflow`.

## Preconditions

- The PR has comments to address (`gh pr view <number> --json reviews,comments`)
- The branch is the PR's head and the working tree is clean

## Stance

Apply `/first-principles` and `/game-theory`: most comments are right; some are wrong; pushback requires a citable reason. Without a citation, the verdict becomes Address. The loop is not complete until CI is green again.

## Triage verdicts

For each comment, pick exactly one:

- **Address** — code changes. Default verdict.
- **Push-back** — explain why no change. **Must cite** a specific principle (locked architecture artifact, AGENTS.md rule, issue scope, contract non-goal). Without a citation, becomes Address.
- **Escalate** — comment surfaces something non-trivial (architecture revision, contract revision, security re-think). Invokes `/interview` or `/architect` inline before continuing.
- **Follow-up** — valid concern but out of scope; captured per `/issue-capture` with link.

## Procedure

### 1. Print the triage table
| # | Comment | Verdict | Reason / fix |
|---|---|---|---|

The table goes to the user before execution. The user can interrupt to override.

### 2. Execute Address verdicts
- Smallest commit per concern
- Reference the comment URL in the commit message
- Tests pass before pushing

### 3. Execute Escalate verdicts
- Pause execution
- Invoke `/interview` or `/architect` inline as appropriate
- Resume only after the design question is locked

### 4. Resolve threads
- Resolve Address threads silently via GraphQL `resolveReviewThread` (no reply text)
- Push-back threads stay unresolved until the human reviewer agrees or the verdict flips
- Follow-up threads are resolved with a link to the captured issue

### 5. Push and watch CI
- Push the address commits
- `gh pr checks --watch --fail-fast`
- The loop is not complete until CI is green
- If CI fails on a fix, root-cause; do not retry blindly

### 6. Loop
If new comments arrive during the address pass, loop back to step 1.

## Required output

Write `<run-dir>/27-address.md`:

### 1. Triage table
The full table with verdict and reason per comment.

### 2. Commits made
Per Address verdict, the commit SHA and one-line summary.

### 3. Escalations
Per Escalate verdict, which skill was invoked and the outcome.

### 4. Pushbacks
Per Push-back, the citation and the reviewer's response (if any).

### 5. Follow-up issues
Per Follow-up, the captured issue link.

### 6. CI status
Final state of required checks.

### 7. Open threads
Any threads still unresolved and why.

### 8. Handoff
Block per `/artifact-protocol`, pointing at `/learn`.

## Rules

- Default to Address.
- Push-back requires a specific citable principle.
- Escalations stop the address loop and invoke the right skill inline.
- Threads resolve silently; no reply text.
- CI must be watched until green; do not bypass hooks.
- The loop is autonomous; the user interrupts if needed.

## Anti-patterns

- "I disagree" without a cited principle.
- Bundling unrelated fixes into one commit.
- Skipping CI after a fix push.
- Replying to threads with text instead of resolving silently.
- Force-pushing to hide review history.
- Auto-resolving threads where the reviewer is still pushing back.

## Composition

References: `/code-review`, `/architect`, `/contract`, `/interview`, `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Tooling: `gh pr view`, `gh api`, GraphQL `resolveReviewThread`.

## Final response

End with exactly:

> Comments addressed. Continue to `/learn`.
