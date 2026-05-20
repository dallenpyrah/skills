# Cognitive Load

Use this before adding context, agents, questions, or long output.

## Load Types

- **Intrinsic load:** the real complexity of the task.
- **Extraneous load:** avoidable complexity caused by presentation, duplicated context, vague prompts, raw logs, or scattered state.
- **Coordination load:** overhead from agent handoffs, tool fanout, checkpoints, and integrating partial results.

## Rules

- Reduce extraneous load first.
- Split intrinsic load only when the task has independent parts.
- Do not add subagents when coordination load would dominate.
- Keep one collective working memory: `.context/session-state.md`.
- Put large evidence in `.context/`, not chat.
- If context feels crowded, compile it into a smaller artifact before continuing.

## Subagent Gate

Use subagents only when all are true:

- the task has separable lanes
- each lane has a clear output shape
- integration cost is lower than doing it locally
- the main agent can verify or reject the result

Do not use subagents for vague brainstorming, tightly coupled edits, or work whose output the user must manually reconcile.

## Context Compilation

When a workflow repeats or a pattern stabilizes, compile the result:

- into a skill rule if it changes future behavior
- into `.context/session-state.md` if it is session-local
- into `docs/learnings/` if it is durable project learning
- into an issue/PR body only if it is part of the public contract
