# Issue Reference

Use this only when `/issue` needs a durable contract shape.

## Shape

```md
# <short outcome title>

Owner: <human or team>
Appetite: <time/risk budget>
Status: Ready | Needs review | Blocked

## Problem
<what is true now, what must remain true, what should become true>

## Outcome
<observable result>

## Contract
<architecture or implementation contract at the boundary level>

## Acceptance
- [ ] <observable behavior>
- [ ] <failure mode handled>
- [ ] <verification path>

## Out of Scope
- <tempting work not included>
```

## Rules

- Use the issue as the durable implementation contract.
- Do not include raw derivation, long plans, or chat history.
- Reference `.context/` evidence paths when useful.
- Use ASCII diagrams only when structure would otherwise be ambiguous.
