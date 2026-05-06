---
name: research-bibliography
description: "Citation library for the compound-engineering workflow: classic and current sources on skill construction, modularity, domain modeling, interfaces, concurrency, security, testing, observability, and agent verification. Use when a skill says 'see research-bibliography', when justifying a design choice with a primary source, or when the user asks for the canonical reference on a topic."
---

# /research-bibliography

Citation library. Other skills cite this one instead of restating sources inline. When in doubt, prefer primary sources over blog posts; cite the URL alongside the claim.

## When this fires

- A skill says "see research-bibliography" or "anchor:" with a topic
- A design choice needs a primary source instead of habit
- The user asks for the canonical reference on modularity, domain modeling, concurrency, observability, etc.

## Skill construction and progressive disclosure

- Anthropic, *Agent Skills — Best Practices* — progressive disclosure, concise SKILL.md, on-demand `references/` and `scripts/`. <https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices>
- Anthropic, *Agent Skills — Overview* — three-level loading model, frontmatter contract, when to fork vs inline. <https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview>
- Claude Code, *Skills* — Claude Code-specific skill format and invocation. <https://code.claude.com/docs/en/skills>
- `anthropics/skills` — reference skill repo (e.g., `skill-creator`). <https://github.com/anthropics/skills>
- OpenAI Codex, *Skills* — directory layout and required SKILL.md frontmatter. <https://developers.openai.com/codex/skills>
- Agent Skills Spec — relative file references from skill root, avoid deep chains. <https://agentskills.io/specification>

## Architecture, boundaries, abstraction

- Parnas, *On the Criteria To Be Used in Decomposing Systems into Modules* (1972) — modules hide design decisions likely to change. <https://wstomv.win.tue.nl/edu/2ip30/references/criteria_for_modularization.pdf>
- Parnas, *Information Distribution Aspects of Design Methodology* (1971). <https://cseweb.ucsd.edu/~wgg/CSE218/Parnas-IFIP71-information-distribution.PDF>
- Liskov, *Data Abstraction and Hierarchy* (1987) — subtyping constraints. <https://www.cs.tufts.edu/~nr/cs257/archive/barbara-liskov/data-abstraction-and-hierarchy.pdf>
- Ousterhout, *A Philosophy of Software Design* — deep modules, information hiding. <https://web.stanford.edu/~ouster/cgi-bin/aposd2ndEdExtract.pdf>

## Domain modeling and state

- Evans, *Domain-Driven Design Reference* — ubiquitous language, bounded context. <https://www.domainlanguage.com/wp-content/uploads/2016/05/DDD_Reference_2015-03.pdf>
- Fowler, *BoundedContext*. <https://martinfowler.com/bliki/BoundedContext.html>
- Wlaschin, *Domain Modeling Made Functional* — illegal states unrepresentable. <https://pragprog.com/titles/swdddf/domain-modeling-made-functional/>
- Harel, *Statecharts: A Visual Formalism for Complex Systems* (1987). <https://www.state-machine.com/doc/Harel87.pdf>

## Interface and developer experience

- Bloch, *How to Design a Good API and Why it Matters* — easy to learn, hard to misuse. <https://research.google.com/pubs/archive/32713.pdf>
- Hyrum's Law — observable behavior is the contract. <https://www.hyrumslaw.com/>
- Semantic Versioning 2.0.0. <https://semver.org/>
- Stylos & Myers, API usability research. <https://ppig.org/files/2006-PPIG-18th-stylos.pdf>
- Diátaxis — tutorials, how-to, reference, explanation. <https://diataxis.fr/>

## Concurrency, reliability, distributed behavior

- Hoare, *Communicating Sequential Processes* (1978). <https://www.cs.cmu.edu/~crary/819-f09/Hoare78.pdf>
- Lamport, *Time, Clocks, and the Ordering of Events* (1978). <https://lamport.azurewebsites.net/pubs/time-clocks.pdf>
- Stripe, idempotent requests. <https://docs.stripe.com/api/idempotent_requests>
- Dean & Barroso, *The Tail at Scale* (2013). <https://research.google/pubs/the-tail-at-scale/>

## Security

- Saltzer & Schroeder, *The Protection of Information in Computer Systems* (1975) — economy of mechanism, fail-safe defaults, complete mediation, open design, separation, least privilege, least common mechanism, psychological acceptability. <https://users.ece.cmu.edu/~adrian/630-f05/readings/saltzer-schroeder-protection_information.pdf>
- NIST SP 800-218 SSDF. <https://csrc.nist.gov/pubs/sp/800/218/final>
- OWASP Top 10 for LLM Applications. <https://owasp.org/www-project-top-10-for-large-language-model-applications/>

## Testing, refactoring, deletion

- Dijkstra, *Notes on Structured Programming* — testing shows presence of bugs, not absence. <https://www.cs.utexas.edu/~EWD/transcriptions/EWD02xx/EWD249/EWD249.html>
- Claessen & Hughes, *QuickCheck* — property-based testing. <https://www.cs.tufts.edu/~nr/cs257/archive/john-hughes/quick.pdf>
- Google Testing Blog, *Just Say No to More End-to-End Tests*. <https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html>
- Fowler, *Refactoring* — behavior-preserving transformation, code smells. <https://martinfowler.com/books/refactoring.html>
- Beck, *Tidy First* — separate structure changes from behavior changes. <https://tidyfirst.substack.com/p/structure-and-behavior>

## Observability and performance

- OpenTelemetry. <https://opentelemetry.io/>
- Google Dapper tracing. <https://research.google.com/archive/papers/dapper-2010-1.pdf>
- Brendan Gregg, USE method — utilization, saturation, errors. <https://www.brendangregg.com/usemethod.html>

## Agent verification and tooling

- Codex computer use — when GUI operation is the only verification path. <https://developers.openai.com/codex/app/computer-use>
- Codex in-app browser — local dev servers, untrusted page content. <https://developers.openai.com/codex/app/browser>

## Composition

This is a citation library, not a method skill. Workflow skills cite specific entries by topic. Method content lives in `/first-principles`, `/game-theory`, `/core-field-guides`, `/artifact-protocol`, `/issue-capture`, `/compound-workflow`.

## Final response

When invoked directly, end with:

> Bibliography loaded. Cite specific entries when justifying a design decision.
