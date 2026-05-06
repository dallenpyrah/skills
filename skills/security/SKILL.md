---
name: security
description: "Run secure-by-design review after /concurrency, before /performance. Models assets, actors, trust boundaries, capabilities, secrets, auth, permissions, injection vectors, supply-chain risk, agent/tool abuse, and adversarial scenarios. Use when the user types /security, when untrusted input crosses a boundary, or when an LLM/agent has tool access. Writes 13-security.md and hands off to /performance."
---

# /security

Security is mechanism design under adversarial pressure. This phase names assets, attackers, trust boundaries, and the smallest mechanism that fails closed.

## When this fires

- The user types `/security`
- Untrusted input crosses a boundary (HTTP, DB, queue, file, model, vendor)
- An LLM or coding agent gets tool access (shell, file write, network)
- Secrets, auth, permissions, or PII are in scope
- A new external dependency is being added

## Position in the workflow

Previous: `/concurrency`. Next: `/performance`. See `/compound-workflow`.

## Preconditions

- `<run-dir>/06-boundary.md` named trust and agent boundaries
- `<run-dir>/10-interface.md` defined the public surface

## Stance

Apply Saltzer & Schroeder principles: economy of mechanism, fail-safe defaults, complete mediation, open design, separation of privilege, least privilege, least common mechanism, psychological acceptability. Apply `/game-theory` to model attackers as players with payoffs.

## Required output

Write `<run-dir>/13-security.md`:

### 1. Asset inventory
What is worth protecting:

- credentials, secrets, tokens
- PII, financial data, health data
- model outputs that influence other systems
- audit logs and integrity trails
- availability of critical paths
- reputation surfaces (UGC, model output, public APIs)

### 2. Actor / threat model
Players from `/game-theory` extended with adversaries:

- external attacker (network)
- malicious user
- compromised dependency / supply chain
- malicious agent prompt (prompt injection)
- malicious model output
- compromised insider
- vendor breach

For each, name capabilities, motivation, and primary attack surface.

### 3. Trust boundaries (re-anchored)
From `/boundary`. For each, name:

- validation authority (parser, schema, sanitizer)
- canonicalization rule
- failure-closed behavior
- audit signal

### 4. Authentication and authorization
- Who authenticates, with what credential
- Where authorization is enforced (centralized vs scattered)
- Capability tokens vs ambient authority
- Privilege escalation paths and how they are gated

### 5. Secrets management
- Where secrets live (env, vault, KMS)
- Rotation policy
- Where they appear in logs / errors / traces (must be redacted)
- How agents are prevented from reading secrets they do not need

### 6. Injection and parser surfaces
For each parser surface (SQL, shell, HTML, JSON, YAML, model prompt, file path):

- canonical parser used
- escape / encode / quote responsibility
- evidence the parser is the only path

### 7. Supply chain
- New dependencies vetted (license, advisory check, maintenance signal)
- Lockfile pinning
- Build provenance
- Pre-commit / CI scanning

### 8. Agent / tool abuse
For each agent capability (shell, file write, network call, model call):

- scope (allowed paths, hosts, commands)
- policy (what tool calls are allowed, denied, gated)
- audit (what is logged)
- recovery (how to revoke / contain)
- adversarial test scenarios

Apply OWASP LLM Top 10 categories where relevant.

### 9. Abuse cases
Per asset, name the smallest abuse scenario and the mechanism that defeats it. Write at least one adversarial test scenario per high-value asset for `/test-plan`.

### 10. Open issues
Security hazards captured per `/issue-capture`.

### 11. Handoff
Block per `/artifact-protocol`, pointing at `/performance`.

## Rules

- Defaults fail closed.
- Complete mediation: no path bypasses the check.
- Least privilege at every boundary.
- Secrets never in logs, errors, or traces.
- One canonical parser per format.
- Every agent capability has scope, policy, audit, recovery.

## Anti-patterns

- "We'll add auth later."
- A boundary check that is enforced in the client.
- Building escape strings instead of using a parser.
- Logging the full request body.
- Tools available to the agent that exceed the task's least privilege.

## Composition

References: `/first-principles`, `/game-theory`, `/core-field-guides` (Boundaries), `/artifact-protocol`, `/issue-capture`, `/compound-workflow`. Citations: `/research-bibliography` (Saltzer & Schroeder, NIST SSDF, OWASP LLM Top 10).

## Final response

End with exactly:

> Security reviewed. Continue to `/performance`.
