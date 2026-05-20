# Attention Budget

Design every skill output for limited human attention and working memory.

## Defaults

- Main response: one screen.
- Evidence in chat: three bullets max.
- Questions: 1-3 at a time.
- Tables: max five columns and eight rows.
- Paragraphs: one idea each.
- Headings: short and stable.

## Prohibited By Default

- persona transcripts
- raw logs
- exhaustive derivation
- repeated summaries
- repeated architecture restatements
- giant checklists in chat
- "show your work" narration
- generic quality sections that do not change action

## Progressive Disclosure

- Level 1: operator output in chat.
- Level 2: evidence artifact in `.context/`.
- Level 3: raw logs/source material only when requested or needed for audit.

## Compression Rule

Subtract obvious noise. Keep meaningful structure.
