# Using Forge Skills in Cursor and Other Agents

Forge Skills are plain Markdown — they work in any AI coding tool that can read files from a directory or project knowledge.

## Cursor

### Option 1: Project rules

Copy skill contents into Cursor's project rules (`.cursorrules` or `cursor.rules`):

```bash
# Append the meta-skill to your cursor rules
cat skills/using-forge-skills/SKILL.md >> .cursorrules
```

For the full pipeline, add the skills you use most:

```bash
cat skills/using-forge-skills/SKILL.md > .cursorrules
echo "---" >> .cursorrules
cat skills/idea-griller/SKILL.md >> .cursorrules
echo "---" >> .cursorrules
cat skills/spec-driven-development/SKILL.md >> .cursorrules
```

### Option 2: Notepad

Open Cursor Notepad (Ctrl+L → switch to Notepad). Paste the content of any SKILL.md. Reference it in your prompts: "Follow the idea-griller skill."

### Option 3: @ context

In Cursor chat, use `@file` to reference a skill:

```
@skills/idea-griller/SKILL.md

I have a new idea: [describe it]. Follow the idea-griller process.
```

## Gemini CLI

Add skills to project context via `GEMINI.md`:

```markdown
## Skills

Follow the forge skills when applicable. Key skills:

- @skills/using-forge-skills/SKILL.md — start here for skill discovery
- @skills/idea-griller/SKILL.md — for new ideas
- @skills/spec-driven-development/SKILL.md — for writing specs
```

Or use the AGENTS.md file which follows Gemini's recommended format for intent-to-skill mapping.

## GitHub Copilot / Other Tools

Paste SKILL.md content into:
- Custom instructions
- Project knowledge base
- System prompt

The skills work as prose instructions for any LLM — no special integration needed.

## Manual Invocation

In any chat interface, reference skills explicitly:

```
Follow the spec-driven-development skill from forge-skills:
[paste SKILL.md content]

My feature: [description]
```

## Tips for Non-Claude-Code Agents

- **Start with `using-forge-skills`**: The meta-skill's skill discovery flowchart helps the agent find the right skill for the task
- **Load skills on demand**: Don't load all skills at once — load the one for the current phase
- **Reference the .forge/ artifacts**: Tell the agent "check .forge/prd.md if it exists before asking questions"
- **Use AGENTS.md**: The intent-to-skill mapping in AGENTS.md is designed for agents that don't have slash command support
