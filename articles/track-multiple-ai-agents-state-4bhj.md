---
title: "Track Multiple AI Agents State"
url: "https://dev.to/aidenwong/track-multiple-ai-agents-state-4bhj"
author: "Aiden Wong"
category: "event-driven-agents"
---

# Track Multiple AI Agents State

**Author:** Aiden Wong
**Published:** April 20, 2026

## Overview
While monitoring a single long-running task is straightforward, tracking multiple agents across different tools presents distinct challenges. This article explores four approaches from manual terminal watching to dedicated companion tools.

## Key Concepts

### The Multi-Agent Tracking Problem
1. Each IDE has its own event model (Claude Code hooks, Cursor MCP events, VS Code extension APIs)
2. Identifying which agent is the bottleneck among several running simultaneously
3. Context-switching costs to monitor progress
4. Notification fatigue from traditional alert systems

The optimal solution makes state ambient -- visible at a glance without demanding attention.

## Approach 1: Watch the Terminal (Manual)
Zero setup, works universally, but doesn't scale beyond 2 agents.

## Approach 2: Terminal Bells and Shell Hooks

```zsh
precmd() {
  if [ $? -ne 0 ]; then
    osascript -e 'display notification "Command failed" with title "Shell"'
  else
    osascript -e 'display notification "Command done" with title "Shell"'
  fi
}
```

Claude Code hooks example:

```json
{
  "hooks": {
    "Stop": [
      {
        "type": "command",
        "command": "osascript -e 'display notification \"Claude done\" with title \"AgentBell\"'"
      }
    ]
  }
}
```

## Approach 3: Polling Scripts + Menu Bar Utilities

```bash
#!/bin/bash
# claude-status.5s.sh -- refreshes every 5 seconds
if pgrep -f "claude" > /dev/null; then
  echo "Claude running"
else
  echo "Claude idle"
fi
```

## Approach 4: Dedicated Menu Bar Companion (AgentBell)

Integration matrix across Claude Code (native hooks), Cursor (MCP server), Codex (hook scripts), Windsurf (MCP server), VS Code (MCP server with extension).

## Recommendations

- Single agent: Shell hooks (Approach 2)
- Script-comfortable, polling-tolerant: SwiftBar custom polling (Approach 3)
- Multiple agents across IDEs: AgentBell (Approach 4) for reclaimed attention
- Universal principle: Make state ambient -- visible without demanding attention
