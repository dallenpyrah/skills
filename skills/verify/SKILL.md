---
name: verify
description: "Run the full proof pass after /work, before /docs. Executes the verification commands from /test-plan: tests, typecheck, lint, build, benchmarks, security checks, browser flows, computer-use scenarios, app flows, screenshots, and example execution. Use when the user types /verify, when implementation is complete and proof is required, or when a previous /verify was skipped. Writes 22-verify.md and hands off to /docs."
---

# /verify

Writing code is half the job. Proving it works is the other half. This phase runs the proof commands and records the evidence.

## When this fires

- The user types `/verify`
- `/work` reports implementation is in place
- A change needs evidence beyond "the diff looks right"

## Position in the workflow

Previous: `/work`. Next: `/docs`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/18-test-plan.md` defines the proof commands
- `<run-dir>/21-work.md` references the implementation
- The local environment can run the verification commands (or the user accepts a documented unverified delta)

## Stance

Tightest feedback loop wins. In strength order: run the exact code path → run the test that exercises it → run the type-check → re-read the diff. Reach for the strongest available.

Never swallow errors. An error from a tool, test, compiler, or runtime is signal — read it, quote it, and address it. If you cannot run a verification in this environment, say so plainly and name what is unverified.

## Verification kinds

Run the subset relevant to the run. Record evidence for each.

### 1. Type-check
- Command and output
- Zero errors expected
- New types referenced in `/state-model` and `/interface` exist and are correct

### 2. Lint
- Command and output
- Zero new warnings expected (project's threshold)

### 3. Unit / property tests
- Command and output
- Tests named in `/test-plan` all present and passing
- Property tests run with the seed recorded for reproducibility

### 4. Integration tests
- Command and output
- Real dependencies where the test is verifying the boundary

### 5. End-to-end / app-flow
- Command and output
- For UI: launch dev server and execute the golden path + edge cases in a browser
- Screenshot evidence where the flow is visual

### 6. Browser / computer-use
For features that only verify in a real browser or GUI:

- Use Codex in-app browser for local dev servers and rendered pages (page content is untrusted context)
- Use computer-use for GUI operations that command-line cannot verify
- Record steps, screenshots, and outcome

### 7. Performance benchmarks
- Per `/performance` budget, the benchmark name, threshold, and measured value
- Regression detection result

### 8. Security checks
- Per `/security` abuse case, the check or scanner output
- Secrets / dependency advisory scans
- Runtime checks where applicable

### 9. Observability checks
- Per critical signal in `/observability`, evidence the signal is emitted (test output, log line, span)

### 10. Example execution
- Each canonical example from `/example` runs successfully
- Failure-path examples produce the expected typed error

### 11. Docs check
Optional pre-/docs sanity: stale references, dead links, mismatched signatures.

## Required output

Write `<run-dir>/22-verify.md`:

### 1. Verification matrix
| Item from /test-plan | Command | Result | Evidence |
|---|---|---|---|

Result ∈ { pass, fail, skipped (with reason), unverified-in-environment (with reason) }.

### 2. Evidence
- Inline command output for short outputs
- File paths or links for screenshots, dashboards, traces
- Reproduction commands for each item

### 3. Failures and unverifieds
Each failure named, with root cause hypothesis and the smallest fix. Each unverified item named, with what would be needed to verify (CI, prod, browser, GPU, etc.) and the assumed risk.

### 4. Verdict
- **proven** — every required item passes
- **partial** — every Core item passes; some Important items unverified with stated risk
- **failed** — at least one Core item fails; route to `/work` or earlier phase

### 5. Handoff
Block per `/artifact-protocol`, pointing at `/docs` (when proven or partial-with-acceptance) or the responsible earlier phase (when failed).

## Rules

- Do not mark a task complete without proving it works for what the user asked.
- Use the tightest feedback loop available.
- Read errors; never swallow.
- Separate `ran` from `inferred`. "Tests pass locally" is not "this works in production".
- Three failed fixes means the model of the bug is wrong; stop and re-derive (route to `/debug` or back to a design phase).
- If something cannot be verified in this environment, say so explicitly and name what is unverified.

## Anti-patterns

- "Compiles, looks good." — type-check is not proof of behavior.
- Catch-and-ignore around a failing assertion.
- Re-running a flaky test until it passes.
- Verifying the happy path only.
- Claiming success when an integration test was skipped.

## Composition

References: `/test-plan`, `/performance`, `/security`, `/observability`, `/example`, `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Dijkstra, Codex computer-use & browser docs).

## Final response

End with exactly:

> Verification complete. Continue to `/docs`.
