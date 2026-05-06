---
name: interface
description: "Design every interface (API, CLI, config, event, error, module) after /state-model, before /value-map. Uses usage-first examples, DX / AX pressure, compatibility analysis, and misuse prevention. Use when the user types /interface, when a public surface is being defined or changed, or when a misuse pattern is suspected. Writes 10-interface.md and hands off to /value-map."
---

# /interface

Interfaces are how repeated behavior gets locked in. This phase makes interfaces easy to learn, hard to misuse, and stable across changes.

## When this fires

- The user types `/interface`
- A new public API, CLI, config schema, event shape, or error hierarchy is being defined
- A misuse pattern is suspected (callers reaching past the API, error messages that name the symptom, examples that demonstrate the wrong path)

## Position in the workflow

Previous: `/state-model`. Next: `/value-map`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/09-state-model.md` named writers, readers, lifecycle
- The contract's invariants and acceptance criteria are concrete

## Stance

Apply Joshua Bloch's bar (easy to learn, hard to misuse, easy to read, powerful, extensible, appropriate to audience), Hyrum's Law (every observable behavior will be depended on — design observable surface deliberately), and `/core-field-guides` (Developer experience, Agent experience).

Usage-first: write the call site first, then the definition.

## Interface kinds

Cover every applicable kind:

- **Code API** — function signatures, types, schemas, error model
- **CLI** — flags, subcommands, exit codes, stdout/stderr contract
- **HTTP / RPC** — paths, methods, request/response schemas, status codes
- **Event / message** — topic, schema, ordering, delivery semantics
- **Config** — file format, validation authority, defaults, env vars
- **Error** — error types, messages, recovery instructions
- **Module surface** — exports, barrel files, re-exports
- **Documentation surface** — README, docstrings, examples, learnings

## Required output

Write `<run-dir>/10-interface.md`:

### 1. Usage examples (lead with these)
The smallest, most-canonical call site, written before the type. Two or three examples: happy path, error path, integration with sibling module.

### 2. Public surface
For each interface kind in scope:

- exact signature / schema / shape
- one-sentence purpose
- which invariant it preserves
- which volatile decision it hides

### 3. Compatibility model
SemVer policy, deprecation window, migration mechanism. What counts as breaking, what does not. (See Hyrum's Law: observable behavior is the contract.)

### 4. Misuse prevention
For each tempting misuse:

- what a caller might do wrong
- what would happen
- the mechanism that prevents or surfaces it (type, schema, runtime check, lint rule, error message)

### 5. Error model
Each error type:

- name
- when it is thrown / returned
- recovery instructions (in the message and in the docs)
- whether it crosses which boundary

No silent fallbacks. No catch-and-ignore. Errors carry the fix.

### 6. Defaults and configuration
Defaults documented, justified, and reversible. Configuration validation cites the schema authority from `/state-model` or `/dedupe`.

### 7. DX / AX checks
Apply `/core-field-guides` (Developer experience, Agent experience). One-line answer for each:

- Time to first success?
- Where does the canonical example live?
- What error surface tells the agent how to fix the call?
- Are AGENTS / docs / tests aligned?

### 8. Handoff
Block per `/artifact-protocol`, pointing at `/value-map`.

## Rules

- Usage examples first.
- Every interface preserves a stated invariant or hides a stated decision.
- Errors instruct the recovery; they never just describe the symptom.
- No silent defaults that mask operational failure.
- Every public symbol has one canonical example.
- Every config field has its validation authority named.
- SemVer (or the project's stated equivalent) is explicit.

## Anti-patterns

- Big option bags whose fields' interactions are undocumented.
- Two ways to do the same thing without a stated reason for both.
- Examples that import private modules.
- Errors that say "something went wrong" without naming the boundary, the value, and the fix.
- Defaults that are different in dev vs prod without justification.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Boundaries, DX, AX), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Bloch, Hyrum's Law, SemVer, Stylos & Myers, Diátaxis).

## Final response

End with exactly:

> Interfaces locked. Continue to `/value-map`.
