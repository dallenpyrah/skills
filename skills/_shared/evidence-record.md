# Evidence Record

`.context/` is durable working memory for agents.

## Memory Types

- **Working memory:** `.context/session-state.md`, the active goal, phase, commitment, and next action.
- **Episodic memory:** `.context/<workflow>/*.md`, what happened in this run.
- **Semantic memory:** `AGENTS.md`, repo docs, source docs, and stable facts.
- **Procedural memory:** `skills/*/SKILL.md`, reusable workflows and rules.

## Locations

- Session state: `.context/session-state.md`
- Workflow evidence: `.context/<workflow>/<artifact>.md`
- Raw logs, if needed: `.context/<workflow>/logs/<name>.txt`

## Chat vs Evidence

Chat gets:

- decision
- three evidence bullets max
- risk
- next action
- path to the evidence record

Evidence files get:

- derivation
- source notes and citations
- raw tool output summaries
- subagent reports
- long plans
- review matrices
- rejected alternatives
- audit details

## Rules

- Do not make chat the source of truth for durable decisions.
- Do not duplicate the same architecture, review, or plan across stages.
- Each stage owns one artifact and references prior artifacts by path.
- Record enough evidence for another agent to resume without rereading the transcript.
- Compile repeated reasoning into procedural or semantic memory only when it should change future behavior.
