# /pr — Reference

## PR title rules

The PR title must pass the repository's `pr-title` check, which uses `commitlint` rules in Orika.

Required shape:

```text
type(scope): subject
# or
type: subject
```

Rules:

- Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- Subject is lowercase.
- Subject is at most 72 characters.
- No `#<issue>` suffix in the title.

Validate before `gh pr create` when commitlint is available:

```bash
printf '%s\n' "$PR_TITLE" | bunx commitlint
```

## PR body template

Use this exact structure. Three elements. No others.

```markdown
## Summary

<2-4 sentences. What this PR does and why. Written against the issue's problem, not the diff.>

## Flow

```mermaid
<flowchart LR | flowchart TD | sequenceDiagram — see below>
```

Closes #<issue>
```

## Which diagram to pick

- **`flowchart LR`** — request/response shapes, data flow through a pipeline, left-to-right causality.
- **`flowchart TD`** — hierarchical or branching logic, top-down decision trees.
- **`sequenceDiagram`** — multi-actor interactions, request/response over network, anything with temporal ordering across participants.
- **`stateDiagram-v2`** — only if the PR introduces or changes a lifecycle. Usually the issue already has this; don't duplicate unless it changed.
- **`classDiagram`** — only for module-relationship PRs (extractions, splits, renames). Rare.

## Writing the Summary

- Lead with the outcome, not the mechanism.
- Reference the issue's problem phrasing. If the problem was "duplicate invoices on webhook retry," the summary starts with "Prevents duplicate invoices when …", not "Refactors the webhook handler."
- Call out breaking behavior or data migrations in one sentence if they exist.
- No marketing language. No "This PR introduces a new …" filler.

## Heredoc invocation pattern

```bash
BODY_FILE="$(mktemp -t pr-body-XXXXXX.md)"
cat > "$BODY_FILE" <<'EOF'
## Summary

<summary>

## Flow

```mermaid
<diagram>
```

Closes #<n>
EOF

git push -u origin "$(git branch --show-current)"
PR_TITLE="feat: add focused command palette search"
printf '%s\n' "$PR_TITLE" | bunx commitlint

gh pr create --title "$PR_TITLE" --body-file "$BODY_FILE"
rm "$BODY_FILE"
```

## What the PR body is NOT

The PR body is a signal to reviewers: "this is what I shipped and here's the shape of it." It is not:
- A diff summary (GitHub shows the diff).
- A test plan (the issue has verification).
- A changelog entry (changelogs live elsewhere).
- A retrospective (that's `/learn`).

Keep it tight.
