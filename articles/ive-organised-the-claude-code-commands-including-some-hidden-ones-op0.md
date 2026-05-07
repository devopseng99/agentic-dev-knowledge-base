---
title: "I've Organised the Claude Code Commands (Including Some Hidden Ones)"
url: "https://dev.to/akari_iku/ive-organised-the-claude-code-commands-including-some-hidden-ones-op0"
author: "iku (akari_iku)"
category: "claude-code"
---

# Claude Code Commands Guide

**Author:** iku (akari_iku)
**Published:** February 14, 2026
**Updated:** March 6, 2026

## Overview

This comprehensive guide documents Claude Code features, including essential commands, hidden functionality, and advanced techniques for optimizing AI-assisted development workflows.

## Essential Commands (15 Core)

| Command | Purpose | Key Benefit |
|---------|---------|------------|
| `/rewind` | Undo code or conversation changes | Experimental safety net with auto-checkpoints |
| `/insights` | Generate usage analysis report | Identifies workflow patterns and optimization suggestions |
| `/help` | List available commands | Starting point for feature discovery |
| `/context` | Display token consumption | Prevents context overflow in extended sessions |
| `/compact` | Switch to concise response mode | Reduces token expenditure |
| `/init` | Create new project structure | Establishes CLAUDE.md and templates |
| `/usage` | Show plan and rate limits | Subscription management |
| `/clear` | Reset conversation | Clean slate for new tasks |
| `/agents` | Manage sub-agent delegation | Parallel processing capability |
| `/install-github-app` | Enable automated PR reviews | CI/CD workflow integration |
| `/cost` | Display session token statistics | Per-session budget tracking |
| `/export` | Save conversation to file | Knowledge preservation |
| `/review` | Request code evaluation | Quality assurance before PRs |
| `/pr_comments` | Access GitHub feedback | Requires GitHub integration |
| `/doctor` | Run environment diagnostics | Troubleshooting foundation |

## Hidden Features

### Plan Mode (Shift+Tab)

Enables read-only analysis before implementation: "analyze your codebase first, then decide on an approach" rather than immediate coding.

**Windows note:** v2.1.3+ has a reported bug where Shift+Tab doesn't display Plan Mode; use `/plan` command as workaround.

### /statusline

Real-time context monitoring prevents token overflow through active management.

### /resume

Load previous conversations by session ID:
```shell
claude --resume
/resume
claude --resume auth-refactor
```

### -p Launch Mode

High-speed non-interactive generation without explanations:
```shell
claude -p "explain this function"
cat logs.txt | claude -p "explain"
```

## Keyboard Shortcuts

| Shortcut | Function | Notes |
|----------|----------|-------|
| Esc (once) | Stop generation | Immediate response termination |
| Esc (twice) | Show /rewind menu | Selective code or conversation rollback |
| Shift+Tab | Cycle modes | Normal -> Auto-Accept -> Plan |
| Ctrl+G | Open editor | Multi-line input support |
| Ctrl+T | Toggle task list | Progress visualization |
| Ctrl+R | Search history | Interactive command lookup |
| Ctrl+V | Paste images | Works on Mac too |
| Alt+P | Switch model | Change during prompt entry |

## Agent Management

### /agents - Sub-Agent Basics

Delegates tasks across multiple instances for parallel processing.

### Agent Teams (Experimental)

Enable with environment variable:
```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

**Key differences from sub-agents:**
- Fully independent instances vs. parent session dependency
- Direct inter-teammate messaging
- Research preview stability level

### /tasks - Persistent Task Lists

Survives session closure; stored in `~/.claude/tasks/`:
```shell
/tasks
Ctrl+T
```

**Capabilities:** persistent storage, cross-session sharing, context compression resilience.

## Advanced Features

### /insights Report

Analyzes month-long usage history with:
- Command frequency patterns
- Custom recommendations
- Skills suggestions
- Behavioral analysis ("roast-level detail")

### Checkpointing

Automatic backup system integrated with `/rewind`:
- Auto-creates save points on every prompt
- Supports selective code-only or conversation-only restoration
- Functions as safety net for experimental edits

### Custom Slash Commands

Store in `~/.claude/commands/` (global) or `.claude/commands/` (project-level):

```markdown
# ~/.claude/commands/unit-test.md
Generate comprehensive unit tests for $ARGUMENTS.
Include edge cases and error handling.
```

Usage: `/unit-test src/utils.js`

Supports variables: `$ARGUMENTS`, `$0`, `$1`

## Output Styles

Switch modes with `/output-style`:

| Style | Characteristics | Use Case |
|-------|-----------------|----------|
| Default | Speed-focused, code-only | Maximum efficiency |
| Explanatory | Design decisions included | Intent comprehension |
| Learning | Reasoning + guided snippets | Technology education |

### Setup Custom Modes
```shell
@agent-output-mode-setup
# Generates 4 templates: Concise, Educational, Code Reviewer, Rapid Prototyping
```

## Context Management

### Auto-Compact

Automatic summarization at ~95% context capacity; preserves essential information while enabling continuation.

### Manual Compacting
```shell
/compact Keep the error handling patterns
/context
```

### Shell Injection (!)

Fetch live data within skills:
```shell
!gh pr diff
!git status
```

## Prompt Optimization Patterns

**Self-Review:** `"Grill me on changes"`

**Deep Thinking:** `"Ultra think"` -- forces deliberation

**Task Decomposition:** `"Step by step"` -- stagewise progression

**Conservative Mode:** `"Be conservative and verify before making changes"` -- reduces hallucinations

## Session Handover Techniques

**Method 1: Export + Reload**
```shell
/export handover.md
# Next session: "Read handover.md and continue"
```

**Method 2: Custom Handover Command**
```markdown
# ~/.claude/commands/handover.md
Create handover document with:
- Work summary
- Decisions made
- Incomplete tasks
- Lessons learned
Save as HANDOVER.md
```

**Method 3: /teleport**
```shell
/teleport
# Move between local and Web (claude.ai) sessions
```

## Interactive Features

### AskUserQuestion

Presents multiple choice options when Claude needs clarification; reduces vague instruction misinterpretation.

### Auto-Accept Mode

Enable with Shift+Tab to auto-approve permission confirmations; use cautiously with security awareness.

## Notable Statistics & Configuration

- **Information Currency:** Current as of February 2026
- **Auto-checkpoint Frequency:** Every prompt
- **Context Compression:** Near-instantaneous (v2.0.64+)
- **Recommended Agent Limit:** 2-3 parallel agents; 3-5 maximum runs
- **Task Persistence:** Survives context compression

## Key Takeaways

1. **Plan before executing** -- Shift+Tab's Plan Mode dramatically improves first-try success
2. **Monitor tokens aggressively** -- `/context` and `/compact` prevent expensive overruns
3. **Automate repetition** -- Custom commands eliminate prompt management overhead
4. **Leverage checkpoints** -- `/rewind` makes experimentation psychologically safe
5. **Use `/insights` monthly** -- Data-driven workflow optimization based on actual patterns
6. **Manage agents conservatively** -- Information overload increases complexity; start with 2-3
7. **Session persistence matters** -- `/tasks` and custom handover commands bridge long projects

---

**Documentation Reference:** [Official Claude Code Docs](https://code.claude.com/docs/)
