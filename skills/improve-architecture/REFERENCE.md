# Improve Architecture Reference

Use this only when ranking architecture improvement candidates.

## Candidate Score

Score each candidate privately in `.context/improve-architecture.md`:

| Factor | Question |
|---|---|
| Correctness | Does this remove a real failure mode? |
| Testability | Does this move tests to a stable boundary? |
| Coupling | Does this reduce file/module churn? |
| Depth | Does the module hide real complexity? |
| Reversibility | Can this ship in small steps? |

## Operator Rule

Chat gets only the top 1-3 candidates. The full scoring table belongs in `.context/`.
