# Operator Output

The human reads decisions; agents carry evidence.

Use this shape for user-facing output from every workflow skill:

```md
## Decision
<one sentence>

## Evidence
- <fact that changes trust or action>
- <fact>
- <fact>

## Risk
<remaining risk or None known>

## Next
<exact next action>
```

## Rules

- Name the current phase when useful.
- Lead with the decision.
- Evidence is capped at three bullets unless the user asks for depth.
- Put derivation, raw notes, subagent reports, and long source lists in `.context/`.
- If the answer needs a long artifact, give the path and a digest.
- Do not end with trailing summaries after `Next`.

## Allowed Expansion

Expand beyond one screen only when:

- the user asks for full reasoning or a full audit trail
- a production risk cannot be understood without more detail
- a tool/test failure needs enough detail for the user to act
- a public artifact body is the requested deliverable
