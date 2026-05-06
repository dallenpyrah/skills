---
name: pr
description: "Open the pull request after /example, before /code-review. Body is a strict minimal shape: Summary (2–4 sentences) + mermaid Flow diagram + `Closes #<issue>`. Watches CI until checks pass. Use when the user types /pr, when implementation/verification/docs/examples are complete and ready for review, or when an existing PR needs an update push. Writes 25-pr.md and hands off to /code-review."
---

# /pr

Open or update the PR. The body captures intent and flow only — reviewers go to the run for design, the diff for changes, and CI for proof.

## When this fires

- The user types `/pr`
- `/verify`, `/docs`, `/example` are complete
- A PR is the right next step (vs internal review-only)

## Position in the workflow

Previous: `/example`. Next: `/code-review`. See `/compound-workflow`.

## Preconditions

- Branch exists and tracks (or will track) a remote
- Implementation issue exists from `/issue`
- Repo policy permits PRs (vs trunk-based commit)

## Stance

Short, scannable, mermaid-only-when-it-pays-its-keep, no checklists. The PR body is for reviewers triaging at a glance; the run artifacts are for reviewers who want depth.

## PR body shape

```markdown
## Summary

<2 to 4 sentences from /contract and /architect: what changed, why, the core trade-off>

## Flow

\`\`\`mermaid
<diagram showing the runtime or data flow that changed; only if structure cannot be conveyed in prose>
\`\`\`

Closes #<issue>
```

That is the body. No "Changes" section. No "Test plan" checklist. Reviewers see verification in CI; design in the run; changes in the diff.

## Title

- Under 70 characters
- Imperative ("add", "fix", "update", "refactor")
- No ticket prefix unless repo convention requires
- Mirrors the implementation-issue title where reasonable

## Procedure

### 1. State check
Run in parallel via Bash:

- `git status` — confirm clean working tree (or stash unrelated state)
- `git diff main...HEAD` (or repo's base branch) — sanity check
- `gh pr list --head <branch>` — does a PR already exist?

### 2. Push (with `-u` if first push)
- Confirm the branch tracks the right remote
- Push without `--no-verify` unless the user explicitly asked

### 3. Create or update
- If no PR: `gh pr create --title <title> --body "$(cat <<'EOF' ... EOF)"`
- If PR exists: `gh pr edit <number> --body "$(cat <<'EOF' ... EOF)"`

### 4. Link the implementation issue
- `Closes #<issue>` in the body
- If Boy Scout follow-up issues exist, link as references (not `Closes`)

### 5. Watch CI
- `gh pr checks --watch --fail-fast`
- The PR is **not** complete until required checks pass
- If a required check fails, root-cause and push the fix; do not bypass

### 6. Review-readiness
- Confirm draft / ready state matches user intent
- Add reviewers per repo convention if expected

## Required output

Write `<run-dir>/25-pr.md`:

### 1. PR
Number, URL, title, full body.

### 2. CI status
Per required check, status and link. Final summary: all-green / failing.

### 3. Linked issues
Implementation issue closed, Boy Scout issues referenced.

### 4. Open issues
Anything captured per `/issue-capture` during the PR pass.

### 5. Handoff
Block per `/artifact-protocol`, pointing at `/code-review`. Include PR number in `required_context`.

## Rules

- Body has Summary + Flow (mermaid optional) + `Closes #<issue>`. Nothing else.
- Title is short, imperative, under 70 chars.
- CI must be watched until checks pass.
- Never bypass hooks (`--no-verify`, `--no-gpg-sign`) without the user explicitly asking.
- Never force-push without explicit user request.
- Never push to main / master.
- Mermaid only when prose cannot convey the structural relationship.

## Anti-patterns

- "Changes" or "Test plan" sections in the body — reviewers do not need them; the run and CI provide them.
- Long emoji-laden summary.
- Title that restates the issue verbatim including ticket prefixes.
- Pushing and walking away without watching CI.
- Force-push to overwrite review history.

## Composition

References: `/issue`, `/verify`, `/docs`, `/example`, `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Tooling: `gh`, `git`.

## Final response

End with exactly:

> PR ready. Continue to `/code-review`.
