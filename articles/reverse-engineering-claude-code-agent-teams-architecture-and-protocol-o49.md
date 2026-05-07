---
title: "Reverse-Engineering Claude Code Agent Teams: Architecture and Protocol"
url: "https://dev.to/nwyin/reverse-engineering-claude-code-agent-teams-architecture-and-protocol-o49"
author: "nwyin"
category: "agent-research-testing"
---
# Reverse-Engineering Claude Code Agent Teams: Architecture and Protocol
**Author:** nwyin  **Published:** March 23, 2026

## Overview
Documents the internal architecture of Claude Code's Agent Teams feature through official documentation analysis, on-disk artifact examination, and binary analysis of version 2.1.47. Reveals a decentralized, file-based coordination system where multiple Claude Code instances collaborate on shared tasks.

## Key Concepts
- **Decentralized Architecture:** "The entire coordination layer is file-based. The filesystem at `~/.claude/` is the sole coordination substrate"
- **Team Structure:** Lead agent plus flat peer teammates, each running as separate CLI processes
- **Task Management:** Individual JSON files per task with `.lock` for concurrency control and `.highwatermark` for auto-incrementing IDs
- **Messaging System:** JSON inbox arrays using append-and-poll delivery; nested JSON payloads
- **Message Types:** task_assignment, plan_approval_request, shutdown_request, broadcast, and idle_notification
- **Context Isolation:** "Each teammate starts fresh with only the spawn prompt as context"
- **Quality Gates:** Hook system supporting shell commands, LLM prompts, and multi-turn sub-agents
- **Token Economics:** Agent teams consume approximately 7× more tokens than standard sessions
- **Task Dependencies:** Blocking/blocked-by relationships prevent task claiming until prerequisites complete

## Code Examples

```json
{
  "members": [
    { "name": "team-lead", "agentId": "abc-123", "agentType": "leader" },
    { "name": "researcher", "agentId": "def-456", "agentType": "general-purpose" }
  ]
}
```

```json
{
  "id": "1",
  "subject": "Hunt for bugs across the codebase",
  "status": "completed",
  "owner": "bug-hunter",
  "blocks": [],
  "blockedBy": []
}
```

```json
{
  "from": "team-lead",
  "text": "{\"type\":\"task_assignment\",\"taskId\":\"1\",\"subject\":\"Phase 2\"}",
  "timestamp": "2026-02-18T02:37:16.890Z",
  "read": false
}
```
