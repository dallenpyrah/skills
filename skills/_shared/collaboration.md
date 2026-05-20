# Collaboration

Use this before asking the user for input or choosing how much detail to show.

## User Model

Track durable preferences in `.context/session-state.md`:

- detail level
- checkpoint preference
- risk tolerance
- workflow entry point
- repeated output the user dislikes
- preferred evidence style

## Asking

- Ask 1-3 questions only when repo/context cannot answer them.
- Ask for decisions, not facts that tools can discover.
- Provide a recommended default when one is defensible.
- Do not ask the user to integrate raw agent outputs.

## Trust

Earn delegation by showing:

- what you understand
- what evidence supports it
- what remains risky
- what exact action happens next

## Adaptation

- If the user is overloaded, compress and write evidence to `.context/`.
- If the user asks for deep research or audit, expand into an evidence file and summarize.
- If the user wants execution, act from the strongest available contract.
- If the user is shaping intent, interview with the fewest useful questions.
