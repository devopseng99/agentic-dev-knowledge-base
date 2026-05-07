---
title: "Your AI Agent Knows What To Do… But Does It Know How To Do It?"
url: "https://dev.to/sreeni5018/your-ai-agent-knows-what-to-do-but-does-it-know-how-5836"
author: "Seenivasa Ramadurai"
category: "autonomous-operations"
---
# Your AI Agent Knows What To Do… But Does It Know How To Do It?
**Author:** Seenivasa Ramadurai  **Published:** May 6, 2026

## Overview
Most LLM applications fail not from lack of capability but from lack of procedural structure. Agents receive goals and context but lack explicit step-by-step procedures, causing inconsistent behavior and unpredictable failures. "Without a procedure, they improvise. Sometimes that works. Often it doesn't."

## Key Concepts

### AgentSkills/Procedure Skills
Structured, self-contained units encoding *how* to execute tasks. Think "standard operating procedure" rather than prompt engineering. The SKILL.md format, endorsed by Anthropic and Microsoft, represents industry convergence on this approach.

### Skill Structure Components
- **SKILL.md** — Step-by-step execution instructions with YAML frontmatter
- **scripts/** — Single-purpose automation code for repetitive tasks
- **resources/** — Domain-specific knowledge and company standards
- **assets/** — Output templates and JSON schemas

### Three Layers of Agent Architecture
1. **Prompts** — Describe what to do
2. **Tools** — Enable specific actions
3. **Skills** — Encode how and when to do things

Skills are the missing layer that most agent implementations skip.

### Progressive Disclosure
Load only necessary skills when needed, reducing token waste and improving decision consistency — "show only what's needed, when it's needed."

### Design Principles
- Write imperatives in third person ("Extract text," not "You should extract")
- Define failure states explicitly
- Keep skills small and composable
- Version skills like code (they break when updated carelessly)

### Key Insight
The gap between an agent that knows *what* to accomplish and one that reliably *accomplishes it* is filled by procedural skills. Without them, agents must re-derive execution strategies from scratch on every run, leading to inconsistency and failure.
