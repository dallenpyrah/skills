---
name: interview
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me". Entry point of the workflow — grills on (a) the core shape of the problem and (b) the core shape of the solution direction the user has in mind.
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

Pressure on two things in sequence, but do not announce phases or enumerate probes — just keep grilling until both are clear:
- The core shape of the **problem**: what is wrong, who feels it, what must remain true.
- The core shape of the **solution direction the user has in mind** — not a full design, just where their head is at.

When both are clear, end with this exact line and stop:

> Core shape locked. Run `/architect` to ground any missing edge cases and re-derive the simplest architecture from first principles.
