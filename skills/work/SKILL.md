---
name: work
description: Execute the architecture in a GitHub issue on the current branch. Reads the issue, derives tasks from the Modules section, commits referencing the issue number. Refuses to run on main/master/trunk without explicit confirmation. No worktrees, no new branches. Hands off to /pr.
---

# /work

## First-principles rule

Think from first principles before following an existing pattern: name what is true now, what must remain true, and what you want to be true, then choose the smallest action that closes the gap. Few-shot: if a task says "add a service," ask "what complexity does this hide?"; if none, do not add it. If a task says "add a fallback," ask "what failure does this mask?"; if it masks failure, model an explicit typed error or recovery path. If a task says "match the existing pattern," ask "which invariant does the pattern protect?"; keep it only if the invariant still applies.


Execute the architecture from a GitHub issue. Stay on the current branch.

Usage: `/work <issue#>` (e.g., `/work 42`).

## Preconditions (hard, fail fast)

1. **Issue exists and has an architecture body.** Run `gh issue view <n> --json title,body,url,state`. If not found or the body does not contain the Problem / Architecture / Modules sections, abort and tell the user to run `/issue` first.
2. **Working tree is clean** OR the user has explicitly confirmed uncommitted changes are intentional. If dirty and unconfirmed, run `git status` and ask once.
3. **Current branch is safe.** Get the branch with `git branch --show-current`. If it is `main`, `master`, or `trunk`, stop and ask: *"You are on `<branch>`. Work commits will land directly on this branch. Confirm to proceed, or switch branches first."* Only proceed on explicit confirmation.

## Process

1. Load the issue body. Parse the Modules section. Each module row becomes one task.
2. `TaskCreate` one task per module, in order. Set the first to `in_progress`.
3. Execute tasks serially — one at a time. Use Read/Edit/Write directly, or delegate to subagents for contained sub-problems. Do NOT run tasks in parallel in v1.
4. For each task: implement → verify (type-check, lint, or tightest feedback loop available) → commit.
5. Commit messages follow this shape:

```
<type>: <one-line summary>

Refs #<issue>
```

Type is one of `feat`, `fix`, `refactor`, `test`, `docs`, `chore`. One logical change per commit.

6. If the architecture's mermaid diagram must change during execution (e.g., a module boundary shifted because reality pushed back), edit the issue body:

```bash
BODY_FILE="$(mktemp -t issue-body-XXXXXX.md)"
gh issue view <n> --json body -q .body > "$BODY_FILE"
# edit the mermaid block in $BODY_FILE
gh issue edit <n> --body-file "$BODY_FILE"
rm "$BODY_FILE"
```

Note the reason in the body of the commit that introduced the mid-flight change.

7. Mark each task `completed` as it lands. Do not batch.

## Grounding

If a task requires knowing something about a library, API, or codebase pattern you're not certain of, ground before coding (context7, gh_grep, ast-grep, Read). Never guess a signature.

## When execution uncovers something unexpected

If a task reveals that the architecture is wrong (not just imprecise — actually wrong), stop. Present the discovery to the user. Options:
- Amend the architecture in the issue body and continue.
- Abort work, go back to `/architect` or `/interview`.

Do NOT silently diverge from the issue.

## Output

When all tasks are complete:

1. Run `git status` to confirm the tree is clean.
2. Run `git log --oneline origin/main..HEAD` (or the appropriate base) to show the commit list.
3. Print a one-line summary.

Then end with exactly this line and stop:

> Work complete. Run `/pr` to open a pull request.
