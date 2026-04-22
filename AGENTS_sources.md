# AGENTS.md sources

Citations for the rules in `AGENTS.md`. Kept separate so the main file stays under the lost-in-the-middle threshold (models attend best to start and end of context, poorly to the middle).

## Simplification

- **Richard Feynman** — the Feynman technique: if you cannot explain it in plain English, you do not understand it. Basis for rule #10.
- **Barbara Minto**, *The Pyramid Principle* — answer first, then supporting arguments, then evidence. Basis for rules #1 and #7.
- **Aristotle** (originated) / **Elon Musk** (popularized) — first-principles reasoning: strip assumptions, rebuild from fundamentals. Basis for rules #2 and #9.
- **Sean Goedecke**, "To get better at technical writing, lower your expectations" (seangoedecke.com/technical-communication) — compress to one sentence whenever possible; readers stop early. Basis for rules #1, #8, #12.
- **Wellspoken**, "Communication Skills for Software Engineers" — zoom out, then in: impact first, mechanism on request; frame as trade-off analysis. Basis for rules #3 and #7.
- **Mark Rodseth**, "Using First Principle Thinking to Stress Test Your Technical Architecture" — Socratic / 5 Whys decomposition; distrust analogy. Basis for rules #2 and #9.
- **William Zinsser**, *On Writing Well* — strip filler, prefer concrete nouns, kill hedging. Basis for rules #4, #5, #11.
- **Amazon six-pager culture** — a decision that needs more than six pages isn't a decision yet. Basis for rule #8.

## Verification Loop

- **Boris Cherny** (Anthropic, Claude Code) — "Never mark a task complete without proving it works." The single highest-leverage constraint on an agentic session.
- [Claude Code feedback-loop guidance](https://claudefa.st/blog/guide/development/feedback-loops) — basis for rule #7 (when stuck in a fix loop, restate the problem).

## Design for Simplicity

- **Rich Hickey**, *Simple Made Easy* — simple ≠ easy; complect; compose, don't complect.
- **John Ousterhout**, *A Philosophy of Software Design* — narrow interface / powerful implementation; pull complexity downward; information hiding; deep vs. shallow modules.

## File-design heuristics (informing the structure of AGENTS.md itself)

- **Alex Efimenko (dev.to)**, "I Analyzed a Lot of AI Agent Rules Files. Most Are Making Your Agent Worse." — three-question audit (config-discoverable? tooling-enforceable? would removal cause wrong decisions?); rules for writing rules.
- **Arize AI**, "Optimizing Coding Agent Rules" — SWE-bench Lite ruleset-optimization study showing 53→79% pass-rate gain when the rules file explicitly invokes skills; 10–15% accuracy gain on GPT-4.1 from rule optimization alone.
- **ETH Zurich**, "Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?" (Feb 2026, 138 repos) — human-written rules +4% success, bloated/LLM-generated rules −3% success and +20% inference cost; ~100-line cap recommended.
- **postalcoder (Hacker News, "AGENTS.md outperforms skills in our agent evals")** — first-person framing ("I will follow X") scored 3/3 vs imperative ("Follow X") 0/3 across replicated small-N trials; conjecture: matches training-distribution internal monologue.
- **Cong Yu et al. (DAPLab Columbia)**, "Your AI Agent Doesn't Care About Your README" (Mar 2026) — agents use concrete file paths, commands, and entry points; ignore generic advice and high-level overviews.
- **Cursor**, "Best practices for coding with agents" — only add a rule after observing repeated agent failure; specific instructions outperform generic ones.
- **OpenAI Codex**, "Custom instructions with AGENTS.md" — recommends keeping agent context files to ~100 lines.
- **Linux Foundation / Agentic AI Foundation** — current AGENTS.md spec stewardship; cross-tool standard parsed by Cursor, Copilot, Codex, Factory, and others.
