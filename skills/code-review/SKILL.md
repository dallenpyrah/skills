---
name: code-review
description: Fan out six reviewer personas in parallel against the current PR — correctness, testing, maintainability, project-standards, security, previous-findings. Dedupe findings, validate each with a fresh agent, then post a summary review plus line-level comments to the PR via gh. No autofix, no headless mode. Hands off to /address.
---

# /code-review

Multi-agent code review that posts findings to the pull request.

## Preconditions

- A PR must exist for the current branch. Find it with `gh pr view --json number,url,headRefName,baseRefName,headRefOid`. If none, tell the user to run `/pr` first and stop.
- `gh` authenticated.
- Working tree clean — no uncommitted changes that would confuse line positions.

## Context to gather first

Before spawning reviewers, collect and hold:

1. PR metadata: number, URL, title, body, head SHA, base branch.
2. Diff: `gh pr diff <n>` or `git diff <base>...<head>`.
3. Changed files: `gh pr view <n> --json files -q '.files[].path'`.
4. Linked issue: parse `Closes #<n>` from the PR body, then `gh issue view <issue> --json title,body`. The architecture in the issue is the source of truth for "what this was supposed to do."
5. Prior PR comments: `gh api repos/{owner}/{repo}/pulls/<n>/comments` and `gh api repos/{owner}/{repo}/issues/<n>/comments`.

Pass this bundle to every reviewer agent.

## The six reviewers

Full prompts in `REVIEWERS.md`. Each returns structured JSON:

```json
[
  {
    "severity": "blocker | major | minor | nit",
    "file": "<path>",
    "line": <int>,
    "finding": "<one-sentence problem statement>",
    "suggested_fix": "<concrete suggestion>"
  }
]
```

Personas (all always-on):

1. **correctness** — does the code do what the architecture says; edge cases; race conditions; error paths.
2. **testing** — coverage of the change; test shape; real-vs-mocked boundaries; tests that would not have caught the bug.
3. **maintainability** — deep vs. shallow modules; complect checks; state-machine discipline; naming; unexplained abstractions.
4. **project-standards** — AGENTS.md compliance for this repo; Effect-first discipline in TS; grounding rules; verification-loop rules.
5. **security** — input validation at boundaries; secret handling; auth paths; injection; OWASP top-10 for the changed surface.
6. **previous-findings** — scans existing PR comments and prior merged PRs on this codebase for recurring issues; flags if this PR reintroduces a pattern that was corrected before.

## Orchestration

1. **Fan out.** Spawn all six reviewers in parallel — one message with six Agent tool calls. Each uses subagent_type `general-purpose` unless a more specific type fits.

2. **Collect.** Each reviewer returns JSON. Parse into one flat array.

3. **Dedupe.** Two findings are duplicates if they share `(file, line-range-within-5, category)` where category is inferred from the finding text. Prefer the blocker/major-severity version. Merge `suggested_fix` text.

4. **Validate.** For each deduped finding, spawn one validator Agent (parallel across findings):
   - Give it the finding, the file contents, and the PR diff.
   - Ask: "Is this finding real, or is it a false positive? Return `{valid: true|false, reason: <string>}`."
   - Drop findings where `valid: false`.

5. **Group.** Group surviving findings by severity: blocker → major → minor → nit.

## Posting to GitHub

Post in two layers:

**Layer 1 — Line-level comments.** For each validated finding, post a line comment:

```bash
gh api \
  -X POST \
  /repos/{owner}/{repo}/pulls/<n>/comments \
  -f body="<finding + suggested_fix>" \
  -f commit_id="<head_sha>" \
  -f path="<file>" \
  -F line=<int> \
  -f side="RIGHT"
```

Resolve `{owner}` and `{repo}` from `gh repo view --json nameWithOwner -q .nameWithOwner`.

**Layer 2 — Summary review.** One summary comment listing findings grouped by severity:

```bash
gh pr review <n> --comment --body-file "<summary-file>"
```

The summary body:

```markdown
## Review summary

<X> blockers, <Y> majors, <Z> minors, <W> nits.

### Blockers
- <file>:<line> — <finding>

### Majors
- ...

(etc — omit empty severity sections)

Posted by `/code-review` — see line comments for details.
```

## What NOT to do

- Do not approve the PR. `gh pr review --approve` is never invoked by this skill. Human approval is a separate decision.
- Do not request changes as a block-merge. `gh pr review --request-changes` is also off-limits in v1 — the line comments carry the signal.
- Do not post an empty review. If zero validated findings, post one summary line: "No findings." via `gh pr review --comment`.
- Do not autofix. That's `/address`.

## Output

Print: `<url>` of the PR, counts by severity, count of findings dropped by the validator pass.

Then end with exactly this line and stop:

> Review posted to PR <url>. Run `/address` to work through the comments.
