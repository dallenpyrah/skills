---
name: docs
description: Audit and update documentation after /test and before /pr. Reads the linked issue architecture, actual diff, changed public behavior, config, APIs, migrations, operational commands, and existing docs; updates only documentation files; commits doc-only changes; hands off to /pr.
---

# /docs

Before rendering user-facing output, read `../_shared/plain-output.md`.

Update the docs that make the shipped work usable and operable.

This skill is a workflow gate. It compares the issue architecture and actual diff against existing documentation and asks: "What would the next engineer, operator, or user need to know that is not written down?"

Do not rewrite docs for style. Do not duplicate code comments. Do not create ceremony docs for private implementation changes.

Usage: `/docs <issue#>` or `/docs` when the issue can be discovered from commits.

## Preconditions

- `/test` has completed or the current branch already contains implementation and test commits.
- Current branch is not `main`, `master`, or `trunk`.
- Working tree is clean before audit. If dirty, stop and ask the user to commit, stash, or confirm those changes are part of the docs pass.
- `gh` is authenticated when issue context is needed.
- A linked issue exists through one of:
  - explicit `/docs <issue#>`
  - recent commit body with `Refs #<n>`, `Fixes #<n>`, or `Closes #<n>`
  - branch name containing an issue number

## Process

### 1. Load the contract

Collect:

```bash
gh issue view <n> --json number,title,body,url,state
git status --short
git log --oneline origin/main..HEAD
git diff --stat origin/main...HEAD
git diff origin/main...HEAD
rg --files | rg '(^|/)(README|AGENTS|CLAUDE|docs|doc|adr|runbook|CHANGELOG|examples)'
```

If the base branch is not `main`, use the PR target branch or the issue's known base.

Read changed public interfaces, config files, CLIs, API routes, schemas, migrations, operational scripts, examples, and nearby docs. If a behavior is private and invisible to users/operators/callers, do not force a docs change.

### 2. Build the docs matrix

Create a small matrix:

```markdown
| Change | Reader | Existing doc | Docs needed |
|---|---|---|---|
| <behavior/config/API/operation> | <user/operator/dev> | <path or none> | <update or none> |
```

Consider docs when the work changes:

- public API, CLI, schema, event, config, environment variable, or file format
- setup, deployment, migration, rollback, or operational command
- permissions, auth, rate limits, retries, idempotency, errors, or observability
- user-visible behavior, workflow, screenshot-worthy UI, or example usage
- architecture contract that future work must preserve
- troubleshooting path for a new failure mode
- test command or verification workflow that operators or contributors need

Do not update docs for:

- private refactors with no caller/operator effect
- typo-only code changes
- tests that document behavior better than prose
- learning-cycle retrospectives, which belong to `/learn`

### 3. Edit docs only

Allowed:

- README, docs, examples, runbooks, ADRs, AGENTS/CLAUDE guidance, generated skill copies when sync owns them
- small examples that show the new behavior
- command snippets that can be run
- migration or rollback notes when behavior changes existing state

Forbidden:

- production code changes
- test changes
- broad wording rewrites unrelated to this issue
- changelog entries unless the repo already uses changelog discipline for this kind of change
- invented guarantees not proven by code or tests

Prefer the closest existing doc. Create a new doc only when no existing doc has the right audience.

### 4. Verify docs

Run the tightest available proof:

```bash
git diff --check
```

Then run any repo doc validation if it exists: markdown lint, link check, docs build, or example command smoke test. If no doc validator exists, reread the changed docs against the diff and state that no automated doc check exists.

### 5. Commit doc-only changes

If docs were added or changed:

```bash
git add -- <doc-paths-only>
git commit -m "docs: update #<issue> documentation"
```

Do not stage production or test files. If no docs were missing, do not commit.

## Output

Use Plain Senior output:

````markdown
## Decision
Docs updated, or no docs change needed.

## Why
- issue=<issue url>
- docs_changed=<n>
- reader=<user/operator/dev or "none">

## Example
```bash
<doc check or example command run>
```

## Proof
- <command> -> <result>
- <manual reread note if no automated docs check exists>

## Risk
<missing validator, unverified link, or "None known">

## Next
Run `/pr` to open the pull request.
````

Then end with exactly this line and stop:

> Docs ready. Run `/pr` to open the pull request.
