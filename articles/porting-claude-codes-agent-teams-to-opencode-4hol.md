---
title: "Porting Claude Code's Agent Teams to OpenCode"
url: "https://dev.to/uenyioha/porting-claude-codes-agent-teams-to-opencode-4hol"
author: "Ugo Enyioha"
category: "multi-agent-frameworks"
---

# Building Agent Teams in OpenCode: Architecture of Multi-Agent Coordination

**Author:** Ugo Enyioha
**Published:** February 10, 2026

---

## Overview

OpenCode implements a multi-agent coordination system enabling several AI models from different providers to collaborate as teammates within a single coding session. Unlike Claude Code's leader-centric architecture, OpenCode supports peer-to-peer messaging and cross-provider teams.

## Key Architecture Decisions

### Message Passing System

OpenCode uses a two-layer messaging approach:

1. **Inbox Layer** (audit trail): Per-agent JSONL files at `team_inbox/<projectId>/<teamName>/<agentName>.jsonl`
2. **Session Injection** (delivery): Synthetic user messages delivered to recipients' active sessions

This design provides O(1) write performance versus Claude Code's O(N) JSON array approach. The system includes:

- Automatic wake-up for idle recipients
- Batched read receipts as regular team messages
- Delivery tracking with read/unread flags

```typescript
// Simplified send flow
async function send(input) {
  await Inbox.write(input.teamName, input.to, {
    id: messageId(),
    from: input.from,
    text: input.text,
    timestamp: Date.now(),
  })

  await injectMessage(targetSessionID, input.from, input.text)
  autoWake(targetSessionID, input.from)
}
```

### Spawn Mechanics

The team struggled initially with spawn blocking semantics. The solution combines fire-and-forget spawning with auto-wake messaging:

- Spawn returns immediately without awaiting completion
- Teammate executes independently in background
- Lead's prompt loop restarts automatically when receiving teammate messages

```typescript
Promise.resolve()
  .then(async () => {
    await transitionExecutionStatus(teamName, name, "running")
    return SessionPrompt.loop({ sessionID: session.id })
  })
  .then(async (result) => {
    await notifyLead(teamName, name, session.id, result.reason)
  })
  .catch(async (err) => {
    await transitionMemberStatus(teamName, name, "error")
  })

return { sessionID: session.id, label }
```

### Communication Topology

Unlike Claude Code's leader-centric design, OpenCode enables full peer-to-peer messaging. Any teammate can message any other teammate by name, reducing coordination overhead.

### Sub-Agent Isolation

Team messaging tools remain invisible to sub-agents through dual enforcement:

```typescript
const TEAM_TOOLS = [
  "team_create", "team_spawn", "team_message", "team_broadcast",
  "team_tasks", "team_claim", "team_approve_plan",
  "team_shutdown", "team_cleanup",
] as const

// Deny rules prevent access
...TEAM_TOOLS.map(t => ({
  permission: t, pattern: "*", action: "deny",
}))

// Tools hidden from interface
tools: {
  ...Object.fromEntries(TEAM_TOOLS.map(t => [t, false])),
}
```

### Dual State Machines

Two independent state machines track teammate lifecycle:

**Member Status** (coarse): ready -> busy -> shutdown_requested -> shutdown (or error)

**Execution Status** (fine-grained): 10 states tracking exact prompt loop position

This separation allows UI to display detailed progress while keeping recovery logic simple.

### Crash Recovery

Recovery follows strict ordering:

1. Register permission restoration handlers
2. Force-transition busy members to ready status
3. Inject system notification into lead session
4. Subscribe to cleanup events after recovery completes

**Key principle:** No automatic restart. Interrupted teammates become ready but idle, requiring human re-engagement to prevent runaway API consumption.

Cancellation uses three retry attempts (120ms apart) before forcing state transitions.

```typescript
for (const _ of [0, 1, 2]) {
  SessionPrompt.cancel(member.sessionID)
  await transitionExecutionStatus(teamName, memberName, "cancelling")
  await Bun.sleep(120)
  if (TERMINAL_EXECUTION_STATES.has(current?.execution_status)) break
}
```

## Testing Scenarios

1. **NFL Research**: Two Gemini agents--revealed spawn/auto-wake problems and model loop issues
2. **Super Bowl Prediction**: Four Claude Opus agents with concurrent task claiming validation
3. **Architecture Drama**: GPT-5.3 Codex, Gemini 2.5 Pro, and Claude Sonnet 4 coordinating cross-provider

## Known Limitations

- **Delivery receipts**: Best-effort only; crashes between marking read and injection cause lost notifications
- **Backpressure**: No bounded queue; fast senders can flood slow receivers (10KB message limit only)
- **Single-process**: In-memory locks prevent multi-instance deployments
- **Team isolation**: No cross-team communication primitives
- **Manual recovery**: Humans must re-engage interrupted teams

## Comparison with Claude Code

| Dimension | Claude Code | OpenCode |
|-----------|-------------|----------|
| Message storage | JSON array (O(N)) | JSONL append-only (O(1)) |
| Notification | Polling | Event-driven auto-wake |
| Communication | Leader-centric | Full mesh peer-to-peer |
| State tracking | Implicit | Two-level state machines |
| Multi-model support | Single provider | Multiple providers |
| Locking mechanism | File-based | In-memory RW locks |
| Recovery | Undocumented | Ordered bootstrap, manual restart |

## Key Takeaway

Both systems share fundamental approaches (fire-and-forget spawning, file-based inbox persistence, explicit sub-agent isolation), but diverge based on architectural constraints. OpenCode's single-process design enables event-driven messaging, atomic operations, and cross-provider teams--trading off distributed deployability for coordination simplicity.

---

**Repository:** OpenCode implementation spans PRs #12730 (core), #12731 (tools & routes), #12732 (TUI) on the `dev` branch
