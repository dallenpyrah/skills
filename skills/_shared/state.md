# Workflow State

Every workflow skill keeps `.context/session-state.md` current.

## Required Fields

```md
# Session State

## Goal
<current goal>

## Phase
<workflow phase and skill>

## User Model
- Detail level: <known preference or unknown>
- Checkpoint preference: <known preference or unknown>
- Risk tolerance: <known preference or unknown>

## Commitment
- Goal: <current committed goal>
- Direction: <current plan or chosen direction>
- Still valid because: <evidence>

## Reconsider If
- <trigger>

## Locked Decisions
- <decision>

## Open Questions
- <question or None>

## Evidence
- <path>: <what it contains>

## Last Verified
<command/test/check and result, or unverified reason>

## Next
<exact next action>
```

## Rules

- Update state before the final operator output for substantial work.
- Prefer paths over pasted evidence.
- Preserve unresolved risks and unverified claims.
- Preserve the current commitment and reconsideration triggers.
- Preserve durable user preferences when the user states or demonstrates them.
- If compaction happens, this file should be enough to resume.
