---
name: artifact-protocol
description: "Reference for how every workflow skill writes its run artifact and handoff. Use when a phase skill says 'write the artifact and update handoff.yaml', when starting a new run, or when the user asks 'where do these files go' or 'what is the handoff schema'. Defines run directory layout, artifact rules, the handoff yaml schema, and evidence levels."
---

# /artifact-protocol

The compound workflow compounds because every phase leaves a durable, auditable artifact and a machine-readable handoff. This skill is the reference card.

## When this fires

- A phase skill says "write the artifact" or "update handoff.yaml"
- A new run is being initialized
- The user asks where artifacts live, what the handoff format is, or what evidence levels mean

## Run directory layout

```
.agents/runs/<yyyy-mm-dd>-<slug>/
  index.md             # one-screen summary of the run, updated as phases land
  handoff.yaml         # always points at the most recent completed phase
  issue-candidates.md  # Boy Scout queue for unrelated decay
  01-scout.md
  02-interview.md
  03-contract.md
  ...
  29-merge.md
```

Each phase writes exactly one numbered `<nn>-<skill>.md` file. The number matches the phase order in `/compound-workflow`.

`.agents/runs/CURRENT` is a one-line file holding the path of the active run, so phase skills can resolve the run directory without arguments.

## Initialize a run

Plain bash, no scripts required:

```bash
SLUG="workspace-config-redesign"
RUN_ID="$(date +%Y-%m-%d)-${SLUG}"
RUN_DIR=".agents/runs/${RUN_ID}"
mkdir -p "$RUN_DIR"
echo "$RUN_DIR" > .agents/runs/CURRENT

cat > "$RUN_DIR/index.md" <<EOF
# Run: $RUN_ID

Started: $(date -Iseconds)
EOF

cat > "$RUN_DIR/handoff.yaml" <<EOF
from: init
to: scout
status: ready
artifact: $RUN_DIR/index.md
summary: Run initialized.
blocked_if: []
next_action: /scout
EOF

: > "$RUN_DIR/issue-candidates.md"
```

If the run already exists, phase skills resolve it via `cat .agents/runs/CURRENT`.

## Artifact rules

- Artifacts are durable handoffs, not verbose transcripts.
- Every claim that shaped a decision cites a source: file path, command output, issue/PR, official doc, web URL, user decision, or labeled inference.
- Mark facts, assumptions, unknowns, and decisions separately.
- Every artifact ends with a machine-readable handoff block (see schema below).
- Artifacts may append issue candidates to `issue-candidates.md` (see `/issue-capture`) but must not derail the current phase for unrelated work.
- One screen of body where possible. If the phase needs more, link supporting material rather than inline it.

## Handoff schema

Every artifact ends with a fenced YAML block:

```yaml
from: <skill-name>
to: <next-skill-name>
status: ready | blocked | not_applicable
artifact: .agents/runs/<run-id>/<nn>-<skill>.md
summary: <one sentence>
required_context:
  - <context the next skill must preserve>
blocked_if:
  - <specific blocker, or [] when ready>
issue_candidates:
  - <title or none>
next_action: /<next-skill>
```

After writing the artifact, mirror this block to `<run-dir>/handoff.yaml` so external tools can read the latest state from one file.

### Status values

- **ready** — next skill can run
- **blocked** — a specific evidence gap or decision is missing; populate `blocked_if`
- **not_applicable** — the phase is materially not relevant; the artifact still records why and hands off

## Evidence levels

Tag each piece of evidence so readers know how to weigh it:

- **repo** — code, tests, docs, AGENTS files, package manifests, generated files
- **history** — commits, issues, PRs, prior learning docs
- **official** — official docs, standards, API specs, vendor docs
- **paper** — peer-reviewed or classic research
- **community** — blog posts, Reddit, HN, real-project examples
- **inference** — reasoning from evidence; must be labeled

Decisions should rest primarily on **repo / official / paper**, with **community / inference** allowed only when higher-grade sources are silent.

## Example handoff

```yaml
from: interface
to: value-map
status: ready
artifact: .agents/runs/2026-05-06-workspace-config/10-interface.md
summary: Workspace config now has one explicit constructor, typed errors, and public-root examples.
required_context:
  - WorkspaceConfigSchema is the only validation authority.
  - Missing provider is a ConfigError, never a silent fallback.
blocked_if: []
issue_candidates:
  - Old CLI docs mention deprecated fallback flag.
next_action: /value-map
```

## Composition

Every workflow phase references this skill for the artifact + handoff contract. Issue candidates flow through `/issue-capture`. Workflow ordering lives in `/compound-workflow`.

## Final response

When invoked directly, end with:

> Artifact protocol loaded. Continue your current phase.
