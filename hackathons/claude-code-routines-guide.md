# Claude Code Routines & Scheduling Guide

How to automate recurring tasks like the dev.to article collection pipeline using Claude Code's built-in scheduling primitives.

---

## Overview: Three Scheduling Tiers

| Tier | Tool | Persistence | Limit | Best For |
|------|------|------------|-------|----------|
| **In-session cron** | `CronCreate` | Session only (dies when Claude exits) | 7 days | Development, testing, within-session polling |
| **Durable cron** | `CronCreate` + `durable: true` | Survives restarts via `.claude/scheduled_tasks.json` | 7 days | Medium-term recurring jobs |
| **Remote trigger** | `RemoteTrigger` + `/schedule` skill | Anthropic cloud, survives forever | No limit | Production scheduled agents |

---

## Tier 1: In-Session Cron (`CronCreate`)

Schedules a prompt to fire at a cron interval **while Claude is open and idle**.

### Basic usage
```
CronCreate(
  cron: "0 3 * * *",          # 3am daily
  prompt: "/devto-collect",   # fires the skill
  recurring: true
)
```

### Example: Schedule daily article refresh
Ask Claude:
> "Schedule the devto-collect skill to run every day at 3am"

Claude will call `CronCreate` with `cron: "57 2 * * *"` (offset to avoid :00 spike).

### List/cancel jobs
```
CronList()     # see all scheduled jobs + their IDs
CronDelete(id: "job-id-here")
```

### Limitations
- **Session-only by default**: if you close Claude, the job dies
- **7-day auto-expiry**: recurring jobs fire a final time then auto-delete
- **Idle-only**: won't fire if Claude is mid-conversation
- To survive restarts: add `durable: true` — saves to `.claude/scheduled_tasks.json`

---

## Tier 2: Durable Cron (Survives Restarts)

Same as Tier 1 but persisted to disk. Claude reloads jobs on startup.

```
CronCreate(
  cron: "17 3 * * 0",    # Sundays at 3:17am
  prompt: "/devto-collect 'new agent frameworks' 'MCP updates'",
  recurring: true,
  durable: true           # <-- persists to .claude/scheduled_tasks.json
)
```

**File location**: `~/.claude/scheduled_tasks.json`

Still has the 7-day expiry limit — good for weekly runs.

---

## Tier 3: Remote Triggers (Production Scheduling)

For truly persistent, long-running schedules that survive indefinitely. Uses the claude.ai cloud trigger API.

### Using the `/schedule` skill
```
/schedule
```
This invokes the built-in schedule skill which can:
- **Create** a new scheduled trigger with a cron expression
- **List** existing triggers
- **Update** a trigger's cron or prompt
- **Run** a trigger immediately (one-shot test)

### Using `/loop` for polling
```
/loop 30m /devto-collect
```
Runs `/devto-collect` every 30 minutes while Claude is open. Good for active collection sessions.

Interval examples:
- `/loop 5m /check-status`
- `/loop 1h /devto-collect`
- `/loop 24h /devto-collect "weekly refresh"`

### RemoteTrigger API directly
```json
POST /v1/code/triggers
{
  "name": "devto-weekly-refresh",
  "cron": "0 4 * * 0",
  "prompt": "/devto-collect",
  "enabled": true
}
```
Claude calls this via `RemoteTrigger(action: "create", body: {...})`.

---

## Practical Recipes for the dev.to Pipeline

### Recipe 1: Weekly new article collection
Ask Claude once:
> "Schedule /devto-collect to run every Sunday at 4am, durable"

Claude creates:
```
CronCreate(cron: "7 4 * * 0", prompt: "/devto-collect", recurring: true, durable: true)
```

### Recipe 2: Monthly deep collection on new topics
> "Every 1st of the month at 2am, run /devto-collect with the latest AI agent topics"

```
CronCreate(
  cron: "23 2 1 * *",
  prompt: "/devto-collect 'latest agent frameworks 2026' 'new MCP servers' 'LLM routing patterns'",
  recurring: true,
  durable: true
)
```

### Recipe 3: On-demand refresh right now
> "/devto-collect"

Runs the skill immediately — no scheduling needed.

### Recipe 4: Remote persistent schedule via /schedule skill
```
/schedule
```
Then follow the prompts to create a remote trigger that runs `/devto-collect` weekly.

---

## Hooks for Automation (Event-Driven)

Claude Code hooks fire automatically on tool events — useful for post-processing.

**File:** `~/.claude/settings.json` or `.claude/settings.local.json`

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "cd /var/lib/rancher/ansible/db/rd-main/rd-fine-10000-devto && git add articles/ && git diff --cached --quiet || git commit -m 'Auto-commit: new articles $(date +%Y-%m-%d)'"
          }
        ]
      }
    ]
  }
}
```

This auto-commits new articles after every Bash tool use. Combine with a scheduled `/devto-collect` for a fully autonomous pipeline.

### Hook event types
| Event | Fires when |
|-------|-----------|
| `PreToolUse` | Before any tool call |
| `PostToolUse` | After any tool call completes |
| `Notification` | On task completion notifications |
| `Stop` | When Claude finishes a response |

---

## Full Autonomous Pipeline Setup

To run the dev.to collection fully autonomously (no human needed):

### 1. Create the skill (already done)
`~/.claude/skills/devto-collect.md` — defines the `/devto-collect` command.

### 2. Schedule it
```
/schedule
```
Create a remote trigger: `cron: "0 4 * * 0"` (Sundays 4am), prompt: `/devto-collect`.

### 3. Add auto-commit hook
In `.claude/settings.local.json`:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "cd /var/lib/rancher/ansible/db/rd-main/rd-fine-10000-devto && git add articles/ && git diff --cached --quiet || git commit -m 'Auto: new devto articles'"
      }]
    }]
  }
}
```

### 4. Auto-push hook (optional)
Add a `Stop` hook that pushes after each collection run completes.

### 5. Verify
```
CronList()        # check in-session jobs
/schedule         # check remote triggers
```

---

## Key Constraints Summary

| Constraint | Value |
|-----------|-------|
| Session cron auto-expiry | 7 days |
| Durable cron auto-expiry | 7 days |
| Remote trigger expiry | None (permanent until deleted) |
| Cron fires during | Idle REPL only (not mid-conversation) |
| Jitter added by scheduler | Up to 10% of period (max 15 min) |
| Recommended cron minutes | Avoid :00 and :30 (use :07, :17, :23, etc.) |

---

## Quick Reference

| Goal | Command |
|------|---------|
| Run collection now | `/devto-collect` |
| Run on specific topics | `/devto-collect "topic1" "topic2"` |
| Schedule weekly (session) | Ask: "Schedule /devto-collect weekly at 4am" |
| Schedule weekly (durable) | Same + `durable: true` |
| Schedule permanently | `/schedule` then configure remote trigger |
| Repeat every N minutes | `/loop 30m /devto-collect` |
| List scheduled jobs | `CronList()` |
| Cancel a job | `CronDelete(id: "...")` |
| View remote triggers | `/schedule` → list |
