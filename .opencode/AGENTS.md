# OpenCode Configuration

This directory contains OpenCode-specific agents and skills migrated from the `droid/` system.

## Structure

```
.opencode/
├── agents/           # Custom agent definitions
│   ├── smart.md      # Primary agent - main development workhorse
│   ├── rush.md       # Subagent - fast, focused tasks
│   ├── deep.md       # Subagent - deep analysis and planning
│   ├── painter.md    # Subagent - image generation/editing
│   ├── librarian.md  # Subagent - codebase research via shelf
│   ├── oracle.md     # Subagent - second opinion on complex issues
│   └── reviewer.md   # Subagent - quality gate reviews
├── skills/           # Reusable skill definitions
│   ├── caveman/      # Ultra-compressed communication mode
│   ├── debug-agent/  # Systematic evidence-based debugging
│   └── shelf/        # Code reference repository management
└── AGENTS.md         # This file
```

## Agents

| Agent | Mode | Description |
|-------|------|-------------|
| **smart** | primary | Maximum capability, unconstrained token usage. Complex architectural decisions, multi-file refactoring, debugging, feature implementation. |
| **rush** | subagent | Fast, cheap, focused. Quick edits, lookups, minor fixes. |
| **deep** | subagent | Extended thinking. Complex algorithm design, architecture planning, root cause analysis, security assessment. |
| **painter** | subagent | Image specialist. UI mockups, icons, hero images, screenshot editing. |
| **librarian** | subagent | Research specialist. Uses shelf to search reference repos and web for documentation. |
| **oracle** | subagent | Second opinion. Complex reasoning, API design review, security analysis. |
| **reviewer** | subagent | Quality gate. Reviews completed work for correctness, security, completeness. |

## Usage

### Switching Agents

**In OpenCode TUI:**
- Press `Tab` to cycle through primary agents
- Invoke subagents via the `task` tool or by mentioning them

**Via opencode CLI:**
```bash
# Start with specific agent
opencode . --agent smart

# The default agent is configured in opencode.json
```

### Using Subagents

From within a session, invoke a subagent using the `task` tool:

```
task({
  description: "Quick research task",
  prompt: "Search for examples of React useMemo patterns in the shelf repos",
  subagent_type: "librarian"
})
```

### Invoking Skills

Agents automatically see available skills and can load them:

```
skill({ name: "caveman" })  # Switch to compressed communication mode
skill({ name: "shelf" })    # Access shelf code reference repos
skill({ name: "debug-agent" })  # Enter systematic debugging mode
```

## Configuration

Agent behavior is controlled by:

1. **Frontmatter** in `.opencode/agents/*.md` - per-agent tools, permissions, mode
2. **`opencode.json`** - global agent settings, default agent, skill permissions
3. **Global config** at `~/.config/opencode/` - user-wide overrides

### Model Configuration

Models are configured in `opencode.json` at the provider level or per-agent. Example:

```json
{
  "agent": {
    "smart": {
      "model": "anthropic/claude-sonnet-4-5",
      "maxTokens": 8000
    },
    "rush": {
      "model": "openrouter/gemini-2.5-flash",
      "maxTokens": 2000
    }
  }
}
```

### Permission Patterns

Control skill access with wildcard patterns:

```json
{
  "permission": {
    "skill": {
      "*": "allow",           // Allow all by default
      "debug-agent": "ask",    // Ask before using debug-agent
      "internal-*": "deny"     // Deny any internal-* skills
    }
  }
}
```

## Migration Notes

These agents were migrated from `droid/droids/*.md`. Key format changes:

| From (droid) | To (opencode) |
|--------------|---------------|
| `name:` in frontmatter | Derived from filename |
| `model: custom:...` | Configure in opencode.json |
| `tools: ["Read", "Grep", ...]` | `tools: { read: true, grep: true, ... }` |
| No mode specified | `mode: primary` or `mode: subagent` |
| Tools as array | Tools as object with boolean values |

Skills were already in the correct format (`SKILL.md` with frontmatter) and just needed to be copied to `.opencode/skills/`.

## Source

Original droid definitions: `../droid/droids/`  
Original skill definitions: `../droid/skills/`
