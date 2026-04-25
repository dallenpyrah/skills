---
name: incident
description: Production-pressure entry point. Contain first (rollback / feature flag off / disable), communicate, then hand off to /debug for root-cause when the fire is out. Distinct from /debug, which is reproduce-first and assumes calm. Use when production is degraded right now and speed of mitigation matters more than minimal commit hygiene.
---

# /incident

Production is degraded. Fire first. Investigate later.

This skill is the alternative entry point to `/debug` when the situation is hot — users affected, error rate spiking, deploy known-bad. The order of operations is the opposite of `/debug`: contain before reproduce, mitigate before understand.

## Phase 1 — Contain

The goal is restoring service, not solving the bug. Identify the smallest reversal that stops the bleeding. In rough order of preference:

1. **Feature flag off.** If the broken code is behind a flag, flip it.
2. **Revert the bad deploy.** `git revert <sha>` of the suspected commit. The revert is allowed to be ugly — even if it reverts unrelated good work in the same PR. Cleanup happens later.
3. **Disable the feature / route / worker.** Comment out the registration, scale the worker to zero, return early from the handler.
4. **Roll back data.** Only if forward recovery is more dangerous than the data loss — call this out loud before doing it.

Commit:

```
incident: contain <one-line summary of what was reversed>

Reverts <sha> / disables <feature> / flips <flag>.
Bleeding stopped at <timestamp>. Root cause TBD.
```

Push immediately. Do NOT batch with anything else.

If containment requires merging directly to `main` / `master` / trunk, ask the user **once** for explicit confirmation. This is the rare case where the no-direct-trunk rule yields — but only with confirmation.

## Phase 2 — Communicate

Output a structured handoff note for the user to forward (Slack, status page, oncall channel, wherever they post). Three lines, no more:

```
Status: <what's broken, who's affected, severity>
Containment: <what was rolled back / disabled, when>
Remaining risk: <what's still degraded, what to watch>
```

`/incident` does not post this anywhere — it hands the note to the user. The user decides where it goes.

## Phase 3 — Investigate (or skip)

With the fire out, decide:

- **If the rollback was the fix and the root cause is obvious** (e.g. "the new migration was wrong, we don't need to ship it"): skip to `/learn`. The incident is over.
- **If the underlying bug must still be fixed** (the feature is needed, the rollback was temporary): hand off to `/debug` for the calm reproduce → root-cause → fix loop. The incident-contain commit is your safety net while you work.

## Rules

- **Contain before understand.** The three-strike investigation rule from `/debug` does not apply in Phase 1. Speed of mitigation wins over depth of knowledge.
- **Containment is allowed to be ugly.** Reverting a PR that mixes good and bad changes is fine — sort it out later in `/debug`.
- **One reversal per commit.** No drive-by fixes hidden in the contain commit.
- **Direct-to-trunk requires explicit confirmation.** And only in Phase 1.
- **Document the timeline.** Every action in Phases 1 and 2 gets a timestamp in the conversation. `/learn` will reconstruct from this.
- **Errors are signal even under pressure.** If a deploy / revert / migration command fails, surface it. Do not retry blindly.

## Output

After Phase 1, print the contain commit SHA. After Phase 2, print the three-line note. Then end with exactly one of these lines, depending on Phase 3:

If skipping investigation:

> Incident contained. Rollback was sufficient. Run `/learn` to capture the post-mortem.

If continuing to root-cause:

> Incident contained. Run `/debug` to find and fix the underlying bug — the contain commit is your safety net.
