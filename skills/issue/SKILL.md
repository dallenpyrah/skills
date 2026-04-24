---
name: issue
description: Open a clean GitHub issue from the architecture locked by /review. Body is minimal — Problem / Architecture (with mermaid) / Modules / Verification / Out of scope. No changes list, no test plan, no implementation steps. The issue is the architectural intent; the steps live in the worker's task list. Hands off to /work.
---

# /issue

Open a GitHub issue that captures the locked architecture. One command, one artifact.

## Preconditions

- A locked architecture must be present in the conversation context (produced by `/architect` and accepted in `/review`). If not, tell the user to run `/architect` and `/review` first, then stop.
- `gh` CLI is authenticated. If `gh auth status` fails, tell the user to run `gh auth login` and stop.

## Process

1. Read the locked architecture from conversation context.
2. Derive a short, imperative issue title (< 70 chars). Example: "Extract rate limiter into dedicated port".
3. Assemble the issue body using the template in `REFERENCE.md` — Problem / Architecture (including the mermaid diagram from `/architect`) / Modules table / Verification / Out of scope. Nothing else.
4. Write the body to a temp file: `mktemp -t issue-body-XXXXXX.md`.
5. Open the issue:

```bash
gh issue create --title "<title>" --body-file "<tmpfile>"
```

6. Capture the printed issue URL. Extract the issue number.
7. Delete the temp file.

## What NOT to include in the issue body

- No "Changes" or "Files changed" section.
- No "Tests" or "Test plan" section.
- No "Implementation steps" — those live in `/work`'s task list.
- No "How to run" or "Rollout plan" — verification covers what needs to be true at merge; rollout is separate.
- No emojis in headers.

## Output

Print the issue URL and number. Then end with exactly this line and stop:

> Issue created: <url>. Run `/work <issue#>` to start implementation on the current branch.
