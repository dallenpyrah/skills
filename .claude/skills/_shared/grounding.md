# Grounding Sources

Use the strongest source that can answer the question:

| Question | Source |
|---|---|
| What exists in this repo? | `rg`, file reads, tests, package scripts |
| What code shape exists independent of spelling? | ast-grep / structural search |
| What changed before? | `git log`, `git show`, PRs, issues, review comments |
| What did this repo already learn? | `docs/learnings/`, previous review comments |
| What does the installed package do? | lockfile, `node_modules` source/types |
| What does the owner promise? | official docs |
| What is the current API shape? | Context7 or official versioned docs |
| How do real projects wire it? | public code search / `gh_grep` |
| What changed recently? | exa/web search |

Local code beats memory. Installed source beats generic docs for actual runtime behavior. Official docs beat blog posts for product semantics.
