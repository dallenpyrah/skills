---
name: work
description: "Implement a scoped GitHub issue on the current branch after /issue, before /verify. Reads the issue and run artifacts, derives tasks from /architect modules, commits referencing the issue number, captures discovered issues, and stops if a design assumption is invalidated. Use when the user types /work, when an issue is locked and code needs to be written, or when implementation has stalled. Writes 21-work.md and hands off to /verify."
---

# /work

Execute the locked design on the current branch. The issue is the contract; the run artifacts are the rationale. The code is what proves both.

## When this fires

- The user types `/work`
- The implementation issue from `/issue` exists and is the active scope
- Code needs to be written or extended on the current branch

## Position in the workflow

Previous: `/issue`. Next: `/verify`. See `/compound-workflow`.

## Preconditions

- The implementation issue exists and is referenced
- `<run-dir>/05-architect.md` and `<run-dir>/18-test-plan.md` are present
- The current branch is **not** main / master / trunk (refuse to run on trunk without explicit user confirmation)
- The working tree's modifications are intentional (commit or stash any unrelated dirty state first)

## Stance

Implement the smallest mechanism that satisfies the contract. No worktrees, no new branches unless explicitly approved. Commits are small and reference `#<issue>`. If a design assumption is invalidated mid-implementation, **stop** and route to the responsible phase (do not paper over).

## Procedure

### 1. Load context
- Read the implementation issue
- Read `05-architect.md`, `09-state-model.md`, `10-interface.md`, `13-security.md`, `14-performance.md`, `15-observability.md`, `18-test-plan.md`
- Confirm the branch and working-tree state

### 2. Derive tasks from modules
For each module named in `/architect`:

- task: implement public surface (per `/interface`)
- task: implement state machine (per `/state-model`)
- task: implement port and adapter (per `/architect`, `/boundary`)
- task: emit observability signals (per `/observability`)
- task: write tests named in `/test-plan`

Tasks are tracked in conversation, not in the issue body. (The issue is the design contract, not a checklist.)

### 3. Implement in small commits
- One concept per commit
- Commit message references `#<issue>`
- Structure changes and behavior changes never share a commit
- Tests for the change land in the same commit (or the commit immediately before)

### 4. Run the verification commands as you go
Run the relevant subset of `/test-plan` verification commands during implementation:

- type-check after every public-surface change
- unit/property tests for the module under change
- lint
- build (when build correctness is in scope)

If a command fails, stop and read the failure. Do not retry blindly.

### 5. Capture discovered issues
Anything surfaced during implementation that is unrelated to the current scope goes through `/issue-capture`. Do not let the run sprawl.

### 6. Stop conditions
Stop and route back to an earlier phase when:

- A contract invariant cannot be enforced as designed → `/architect`
- A state machine has a transition the design did not anticipate → `/state-model`
- A boundary requires a new public surface → `/interface`
- A concurrency / security / performance assumption is wrong → the responsible cross-cutting phase
- The user changes intent → `/interview`

## Required output

Write `<run-dir>/21-work.md`:

### 1. Issue and branch
- Issue number and URL
- Branch name and commit log (range from before to current HEAD)

### 2. Tasks completed
Per module / surface, what was implemented, with commit references.

### 3. Tests added
Per test from `/test-plan`, the path and the commit that added it.

### 4. Deviations from design
If implementation revealed something the design missed, name it and which earlier phase it routes to.

### 5. Discovered issues
Captured per `/issue-capture`.

### 6. Verification commands run during work
The subset of `/test-plan` commands run, with last-result status. (The full verification pass happens in `/verify`.)

### 7. Handoff
Block per `/artifact-protocol`, pointing at `/verify`.

## Rules

- Refuse to run on `main` / `master` / `trunk` without explicit user confirmation.
- No worktrees, no new branches unless explicitly approved.
- Each commit is small and references the issue.
- Structure and behavior never bundled.
- Failing verification commands stop the work; do not paper over.
- Discovered issues go to `/issue-capture`, not into this run.
- If design assumptions break, stop and route back.

## Anti-patterns

- "Big bang" commits that span multiple concerns.
- Skipping the test for the failure path because the happy path passes.
- Adding scope mid-implementation without going back to `/contract`.
- Using `--no-verify` to bypass hooks.
- Force-push or destructive git operations without explicit user request.

## Composition

References: `/architect`, `/state-model`, `/interface`, `/concurrency`, `/security`, `/performance`, `/observability`, `/test-plan`, `/artifact-protocol`, `/issue-capture`, `/compound-workflow`.

## Final response

End with exactly:

> Implementation in place. Continue to `/verify`.
