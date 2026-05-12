---
name: issue
description: "Open a clean GitHub issue from the architecture locked by /review. Body captures architectural intent only: Problem, Game board, Architecture with mermaid, Modules, Verification, Out of scope. No implementation steps, no changes list, no test-plan checklist. Hands off to /work."
---

# /issue

Before rendering user-facing output, read `../_shared/plain-output.md`.

Open a GitHub issue that captures the locked architecture.

The issue is the durable architectural contract for the implementation cycle. It is not a task list.

## Preconditions

- A locked architecture must be present in the conversation context.
- The locked architecture must have come from `/review` or have been explicitly accepted after `/review`.
- If no locked architecture exists, tell the user to run `/architect` and `/review` first, then stop.
- `gh` must be authenticated:

```bash
gh auth status
```

If authentication fails, tell the user to run `gh auth login` and stop.

## Issue philosophy

The issue should function as a mechanism:

- it gives implementers the source of truth
- it gives reviewers the contract to enforce
- it makes scope boundaries explicit
- it prevents implementation drift
- it captures the desired equilibrium without dictating every step

Do not include implementation steps. `/work` owns the task list.

## Process

1. Read the locked architecture from conversation context.
2. Derive a short, imperative issue title under 70 characters.
3. Assemble the issue body using the template below.
4. Write the body to a temp file:

```bash
BODY_FILE="$(mktemp -t issue-body-XXXXXX.md)"
```

5. Create the issue:

```bash
gh issue create --title "<title>" --body-file "$BODY_FILE"
```

6. Capture the printed issue URL.
7. Extract the issue number.
8. Delete the temp file.
9. Print the issue URL and number.

## What NOT to include

- No “Changes” section.
- No “Files changed” section.
- No “Implementation steps.”
- No checklist test plan.
- No “How to run.”
- No rollout plan beyond the architectural verification paragraph.
- No emojis in headers.
- No speculative future work.
- No design alternatives unless the locked architecture explicitly needs a trade-off note.

## Issue body template

Use this exact structure. Section order is fixed. Do not add sections.

````markdown
## Problem

<One tight paragraph. What is wrong or missing, who feels it, what invariant is at risk, and what must remain true. First-principles framing. No solution language here.>

## Game board

| Player | Incentive | Risk | Mechanism |
|---|---|---|---|
| <player> | <what they are tempted to do> | <bad local/global outcome> | <how the architecture aligns incentives> |

Desired equilibrium: <one sentence describing the stable behavior this architecture should create.>

## Architecture

<Short prose description — 1-2 paragraphs — of the proposed architecture from `/architect`.>

```mermaid
<flowchart or classDiagram from /architect>
```

<If the change has lifecycle, include the stateDiagram-v2 as well:>

```mermaid
<stateDiagram-v2 from /architect>
```

## Modules

| # | Name | Responsibility | Interface | Hides | Dependency | Incentive effect |
|---|---|---|---|---|---|---|
| 1 | `<Name>` | <one sentence> | `<signature>` | <impl detail> | <pure-core / in-process / local-substitutable / ports-and-adapters / true-external> | <how this makes correct use easy or misuse loud> |
| 2 | ... | | | | | |

## Verification

<How we will prove end-to-end that this works. Focus on observable behavior at the public interface, invariant protection, failure behavior, and incentive mechanism. Not a test-plan checklist — one paragraph describing what "done" looks like.>

## Out of scope

- <explicit non-goal>
- <explicit non-goal>
````

## Heredoc invocation pattern

Always use a temp file rather than inlining the body. Mermaid blocks contain backticks that break shell quoting.

```bash
BODY_FILE="$(mktemp -t issue-body-XXXXXX.md)"
cat > "$BODY_FILE" <<'EOF'
## Problem

...

## Game board

...

## Architecture

...

EOF

gh issue create --title "<title>" --body-file "$BODY_FILE"
rm "$BODY_FILE"
```

## Title rules

- Imperative mood: “Extract rate limiter into port”, not “Rate limiter extraction”.
- Under 70 characters.
- No issue number prefix.
- No trailing period.
- No emoji.

## Mermaid rules

- `flowchart LR` for request/response or data flow.
- `flowchart TD` for hierarchy.
- `classDiagram` for module graphs.
- `stateDiagram-v2` for lifecycle — always when an entity has states.
- Keep node labels short.
- Quote multi-word labels.
- Verify the diagram renders on GitHub before closing the terminal when possible.

## Output

Use Plain Senior output with the issue URL, issue number, and exact next command.

Example:

```bash
/work <issue#>
```

Then end with exactly this line and stop:

> Issue created: <url>. Run `/work <issue#>` to start implementation on the current branch.
