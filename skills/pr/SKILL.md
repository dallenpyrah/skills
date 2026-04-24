---
name: pr
description: Open a pull request with a strict minimal body — Summary (2-4 sentences) plus a mermaid Flow diagram plus `Closes #<issue>`. No changes list, no tests section, no breaking-changes section. Pushes the current branch, refuses to run on main/master/trunk. Watches GitHub Actions until they terminate — the PR is not complete until all checks pass. Hands off to /code-review.
---

# /pr

Open a pull request with a minimal, opinionated body.

## Preconditions

1. **Working tree clean.** `git status --porcelain` must be empty. If not, tell the user to commit or stash and stop.
2. **Not on trunk.** If the current branch is `main`, `master`, or `trunk`, refuse — PRs must come from a non-trunk branch.
3. **Upstream branch or remote exists.** `git remote get-url origin` must succeed.
4. **`gh` authenticated.**

## Process

1. Find the linked issue number. Options, in order:
   - If the user passed an explicit `--issue <n>` or `<n>` argument, use it.
   - Otherwise, scan recent commit bodies (`git log -20 --format=%B`) for `Refs #<n>`. Use the most common match.
   - If still not found, ask the user for the issue number.

2. Fetch the issue title: `gh issue view <n> --json title -q .title`. Use this as the PR title.

3. Build the PR body using the template in `REFERENCE.md`:
   - `## Summary` — 2-4 sentences. What and why. Written against the issue's problem statement.
   - `## Flow` — a mermaid `flowchart` or `sequenceDiagram` showing the runtime or user flow introduced by this PR. Required.
   - Final line: `Closes #<n>`.
   - **Nothing else.** No changes section, no test plan, no screenshots block, no rollout plan.

4. Write the body to a temp file (mermaid needs file-based --body-file, not inline).

5. Push the branch:

```bash
git push -u origin "$(git branch --show-current)"
```

6. Open the PR:

```bash
gh pr create --title "<title>" --body-file "<tmpfile>"
```

7. Capture the PR URL. Delete the temp file.

8. **Wait for GitHub Actions.** Do not hand off until checks terminate. The PR is not complete until all checks pass.

```bash
gh pr checks "<pr-number>" --watch --fail-fast
```

- `--watch` blocks until every check finishes (success, failure, cancelled, or skipped).
- `--fail-fast` returns non-zero the moment any check fails, so you surface failures promptly instead of waiting for the rest.
- If `gh pr checks` returns "no checks reported on the <branch> branch", there are no workflows — treat this as a pass and continue.
- If any check fails, stop and surface:
  1. The failing check name(s).
  2. The last ~30 lines of the failing job log via `gh run view <run-id> --log-failed` (find `run-id` with `gh pr checks <n> --json link -q '.[]|select(.state=="FAILURE")|.link'`).
  3. Tell the user: *"CI failed. Address the failure before running `/code-review` — either fix the underlying bug in this branch, or if the failure is unrelated infra, explicitly say so and I will proceed."*
- Do not retry failing checks automatically. Do not approve, dismiss, or close the PR.

## Forbidden sections (do not add these even if the user asks offhand)

- "Changes" / "Files changed" — the diff is visible; do not enumerate it.
- "Tests" / "Test plan" — verification lives in the issue.
- "How to verify" / "Screenshots" — out of this body's scope.
- "Breaking changes" — if there are any, mention them in the Summary prose.
- "Checklist" — no ceremony.
- Emoji headers.

## Output

Print the PR URL and the final CI status (all-pass / none-configured / failed). Only proceed to the handoff when CI has terminated cleanly (all-pass or no-checks). If CI failed, do NOT print the handoff — print the failure summary and stop.

On success, end with exactly this line and stop:

> PR opened: <url>. CI green. Run `/code-review` to fan out reviewers and post findings to the PR.
