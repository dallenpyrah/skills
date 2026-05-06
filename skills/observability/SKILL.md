---
name: observability
description: "Design the debugging interface after /performance, before /refactor. Specifies logs, traces, metrics, events, correlation IDs, spans, redaction, audit records, and the diagnostics future maintainers need. Use when the user types /observability, when a future incident needs answerable questions, or when log/trace coverage feels arbitrary. Writes 15-observability.md and hands off to /refactor."
---

# /observability

Observability is the debugging interface for future maintainers and agents. This phase designs it deliberately, not as a side effect of console.logs.

## When this fires

- The user types `/observability`
- Performance budgets exist and need verification signals
- A future incident needs to be answerable
- Logs and traces feel arbitrary or excessive

## Position in the workflow

Previous: `/performance`. Next: `/refactor`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/14-performance.md` named hot paths and budgets
- `<run-dir>/13-security.md` named redaction obligations

## Stance

Start from the question. What will a future operator, agent, or auditor need to answer when the system fails? Then derive the smallest set of signals that answers it. Apply `/game-theory`: future contributors will copy whatever logging shape they see; the canonical example must be the right one.

## Required output

Write `<run-dir>/15-observability.md`:

### 1. Diagnostic questions
The questions the system must be able to answer. Each question routes to one or more signals. Examples:

- What happened in this request?
- In what order, across services?
- Under whose authority?
- What was the input, after redaction?
- Why did it fail (code path, error type, downstream)?
- Was this user / tenant rate-limited / over-quota?
- How long did each stage take?
- Did this deployment regress a metric?

### 2. Signal plan
Per question, name the signal:

| Question | Signal | Type | Where it lives | Cardinality | Retention |
|---|---|---|---|---|---|

Type ∈ { log, structured event, metric, trace span, audit record, dashboard, alert }.

Cardinality matters: tag dimensions with bounded sets, never raw IDs as metric labels.

### 3. Trace and correlation
- Correlation ID propagation rules (HTTP, queue, agent tool call)
- Span boundaries: what gets a span, what does not
- Baggage / context propagation rules
- OpenTelemetry / Dapper-style trace structure

### 4. Log shape
- Structured (JSON, key=value) only
- Required fields per log: timestamp, level, correlation ID, actor, action, outcome
- Forbidden fields: secrets, full request bodies, full PII
- Levels and when to use them (no ad-hoc levels)

### 5. Metric shape
- Counter / gauge / histogram conventions
- Naming convention (`<domain>_<noun>_<unit>`)
- Cardinality budget per metric
- USE-method coverage for resources (utilization / saturation / errors)

### 6. Audit records
What must be recorded for compliance, security review, or debugging trust decisions. Each audit record:

- when written
- by whom
- what fields
- where stored
- retention and tamper-resistance

### 7. Redaction
Per signal, the redaction rule. Cross-reference `/security` for the asset list.

### 8. Alerting
- Per metric, the alert condition (SLO burn rate, threshold, anomaly)
- Routing (page / ticket / dashboard-only)
- Runbook reference (what the responder should do)

### 9. Verification
Per signal, how it is verified:

- test that the log line / span / metric is emitted on the failure path
- failure-injection test that the alert fires
- synthetic that exercises the trace

Names route to `/test-plan` and `/verify`.

### 10. Open issues
Coverage gaps captured per `/issue-capture`.

### 11. Handoff
Block per `/artifact-protocol`, pointing at `/refactor`.

## Rules

- Every signal answers a stated question.
- Every log is structured.
- Every metric has a cardinality budget.
- Every audit record has retention and tamper-resistance.
- Every alert has a runbook.
- No raw secrets, no full PII, no full request bodies.
- The canonical logging example must be the right shape; agents will copy it.

## Anti-patterns

- `console.log("here")`
- Free-text logs that grep cannot parse
- High-cardinality metric labels (per-user, per-request-id)
- Alerts with no runbook
- Tracing that stops at the first async boundary

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Observability), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (OpenTelemetry, Dapper, USE method).

## Final response

End with exactly:

> Observability designed. Continue to `/refactor`.
