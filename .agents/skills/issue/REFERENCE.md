# /issue — Reference

## Issue body template

Use this exact structure. Section order is fixed. Do not add sections.

```markdown
## Problem

<One tight paragraph. What is wrong or missing, who feels it, what must remain true.
 First-principles framing. No solution language here.>

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

| # | Name | Responsibility | Interface | Hides | Dependency |
|---|---|---|---|---|---|
| 1 | `<Name>` | <one sentence> | `<signature>` | <impl detail> | <in-process / local-substitutable / ports-and-adapters / true-external> |
| 2 | ... | | | | |

## Verification

<How we will prove end-to-end that this works. Focus on observable behavior at the public interface. Not a test-plan checklist — one paragraph describing what "done" looks like.>

## Out of scope

- <explicit non-goal>
- <explicit non-goal>
```

## Heredoc invocation pattern

When calling `gh issue create`, always use a temp file rather than inlining the body — mermaid blocks contain backticks which break shell quoting.

```bash
BODY_FILE="$(mktemp -t issue-body-XXXXXX.md)"
cat > "$BODY_FILE" <<'EOF'
## Problem

...

## Architecture

...

(rest of body)
EOF

gh issue create --title "<title>" --body-file "$BODY_FILE"
rm "$BODY_FILE"
```

## Title rules

- Imperative mood: "Extract rate limiter into port", not "Rate limiter extraction".
- Under 70 characters.
- No issue number prefix, no trailing period.
- No emoji.

## Mermaid tips

- `flowchart LR` for request/response or data flow.
- `flowchart TD` when the shape is hierarchical.
- `classDiagram` for module graphs with relationships.
- `stateDiagram-v2` for lifecycle — always when an entity has states.
- Keep node labels short. Use `"Long label here"` quoting for multi-word labels.
- Verify the diagram renders on GitHub before closing the terminal — paste the issue URL into your browser and confirm.
