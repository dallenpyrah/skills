# PR Reference

Use this only when `/pr` needs a minimal pull request body.

## Shape

```md
## Summary
<2-4 sentences: what changed, why, and the user/operator-visible effect>

## Flow
<ASCII flow only when it clarifies runtime or user behavior>

Closes #<issue>
```

## Rules

- The PR body is a review surface, not a changelog.
- Do not duplicate the diff, test logs, architecture derivation, or `.context/` records.
- Include an issue closure only when there is a real issue.
- If there is no useful flow, omit the flow section.
