---
name: learn
description: Capture the post-mortem for a compound-engineering cycle. Reads the issue, PR, review comments (addressed + pushed-back), and git log. Writes docs/learnings/YYYY-MM-DD-slug.md covering what was planned, what actually ended up working, what surfaced in review, the non-obvious lesson, reproducible patterns, and any AGENTS.md amendment candidate.
---

# /learn

Close the compound-engineering loop. Capture what was planned, what actually shipped, and what the cycle taught.

## Preconditions

- A PR exists (ideally merged; draft or open is acceptable if the user explicitly wants to capture mid-flight learnings).
- The PR has a linked issue (via `Closes #<n>` in the body).
- `gh` authenticated.

## Phase 1 — Gather context

Collect in parallel (one message, multiple tool calls):

1. **Issue body and metadata.** `gh issue view <n> --json title,body,state,url`
2. **PR metadata and diff.** `gh pr view <n> --json title,body,state,mergedAt,url` and `gh pr diff <n>`
3. **Review threads.** The GraphQL `reviewThreads` query from `/address` — include resolved status, reviewer, body, path, line.
4. **Git log for the branch.** `git log --oneline <base>...<head>` (or `git log --oneline origin/main..HEAD` if base is main).

## Phase 2 — Analyze (parallel Explore agents)

Spawn three Explore agents in parallel. Give each the context bundle from Phase 1.

- **Agent A — What actually ended up working.** Compare the issue's Architecture section with the merged code. What matches. What changed. Why. If the mermaid diagram in the issue no longer describes reality, draft the replacement diagram. Return a 150-300 word summary.

- **Agent B — What surfaced in review.** Summarize the review threads: how many addressed, how many pushed back, how many escalated. For each pushback, state the one-line reason (usually visible in the triage commit messages or in conversation history). For each escalation, state what it changed. Return a 100-200 word summary.

- **Agent C — Non-obvious lesson + patterns.** What would a thoughtful engineer not have known before doing this cycle? Is there a reproducible pattern worth naming? Is there a concrete one-sentence rule that belongs in `AGENTS.md`? Return the lesson (one paragraph), the pattern (3-5 lines or `None`), and the AGENTS.md amendment candidate (one sentence with a Why: clause, or `None`).

## Phase 3 — Assemble the file

Write to `docs/learnings/YYYY-MM-DD-<slug>.md` relative to the target repo's root. Use today's date from `date +%Y-%m-%d`. Slug is a kebab-case version of the issue title, trimmed to < 50 chars.

If `docs/learnings/` does not exist, create it.

File contents:

```markdown
---
date: YYYY-MM-DD
type: bug | feature | refactor | decision
topic: <one-line from issue title>
issue: <issue url>
pr: <pr url>
---

# <topic>

## What we set out to do

<One paragraph. Pulled from issue Problem + Architecture.>

## What actually ended up working

<Output from Agent A. Include the updated mermaid diagram if the architecture shifted.>

## What surfaced in review

<Output from Agent B.>

## Non-obvious lesson

<Output from Agent C — the lesson paragraph.>

## Reproducible pattern (if any)

<Output from Agent C — the pattern section, or "None" if no pattern emerged.>

## AGENTS.md amendment candidate (if any)

<Output from Agent C — the amendment candidate, or "None" if no durable rule emerged.>

This is a proposal. Review and edit AGENTS.md yourself if you want to adopt it — `/learn` never auto-edits AGENTS.md.
```

## Output

Print the path to the written file. Then end with exactly this line and stop:

> Cycle captured at <path>. Loop complete.

## Rules

- Do not write the file if Agent A, B, or C failed to produce content — surface the failure and stop.
- Do not auto-apply AGENTS.md amendments. The candidate is a proposal only.
- If the PR is not yet merged, prefix the `type` frontmatter value with `in-flight-` (e.g., `in-flight-feature`). This flags the learning as tentative — the real outcome isn't locked yet.
- Do not create a learning file if the issue/PR carries no non-obvious content. If all three agents return "nothing surprising, everything went as architected," say that and stop without writing the file — tell the user there's nothing durable to capture here.
