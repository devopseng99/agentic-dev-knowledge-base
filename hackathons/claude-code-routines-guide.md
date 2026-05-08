# Claude Code Routines & Scheduling — Complete Guide

How to schedule automated tasks (like the dev.to article collection pipeline) using Claude Code's four independent automation layers.

---

## Overview: Four Automation Layers

| Layer | Tool | Runs On | Persistence | Min Frequency | Best For |
|-------|------|---------|------------|---------------|----------|
| **Cloud Routines** | `/schedule` skill | Anthropic infra | Forever | 1 hour | Unattended production, GitHub/API triggers |
| **Desktop Tasks** | Desktop App UI | Your machine | Until deleted | 1 minute | Local file access, dev workflows |
| **Session Loops** | `/loop` skill | Your machine | 7 days | 1 minute | Active-session polling |
| **Hooks** | `settings.json` | Your machine | Always on | Event-driven | Deterministic rules (always run) |

---

## Layer 1: Cloud Routines (Permanent, Unattended)

Cloud Routines run on **Anthropic's infrastructure** — no laptop required.

### Three Trigger Types

#### A. Schedule Triggers (Cron-based)
```
/schedule daily PR review at 9am
/schedule every 2 hours check deployment status
/schedule clean up feature flag in one week
/schedule weekly /devto-collect on Sundays at 4am
```
- Preset: hourly, daily, weekdays, weekly
- Custom cron via `/schedule update`
- **Minimum interval: 1 hour**
- Runs may start up to 30 minutes after scheduled time (load distribution)
- One-off runs (specific timestamp) are exempt from daily cap

#### B. API Triggers (HTTP endpoint)
Each routine gets a dedicated HTTPS endpoint:
```bash
curl -X POST https://api.anthropic.com/v1/claude_code/routines/{routine_id}/fire \
  -H "Authorization: Bearer sk-ant-oat01-xxxxx" \
  -H "anthropic-beta: experimental-cc-routine-2026-04-01" \
  -H "Content-Type: application/json" \
  -d '{"text": "Deploy finished — verify cluster health"}'
```
Ideal for: CI/CD pipelines, error alerting, internal tooling.

#### C. GitHub Event Triggers (Webhooks)
Reacts to: `pull_request` (opened, closed, labeled, synchronized) and `release` events.

Filter by:
- Author, title, body, base/head branch, labels, draft status
- Regex: `.*hotfix.*` matches PRs with "hotfix" in title

### Key Properties
- **No permission prompts** — runs in `bypassPermissions` mode
- **Full tool access** — bash, file edits, MCP connectors
- **Fresh git clone** each run (from default branch)
- **Branch protection** — only pushes to `claude/*`-prefixed branches by default
- **Daily cap** — check at claude.ai/settings/usage

### Usage for dev.to Pipeline
```
/schedule
```
→ Create routine: name `devto-weekly-refresh`, prompt `/devto-collect`, cron `weekly on Sundays`

---

## Layer 2: Desktop Scheduled Tasks (Local, Persistent)

Runs on **your machine** with full local file/tool access. Requires Desktop app open.

### Setup
Desktop App → **Routines** → **New routine** → **Local**

### Configuration
- **Name:** lowercase kebab-case, unique
- **Instructions:** your prompt (same as CLI)
- **Schedule:** Manual | Hourly | Daily (time picker) | Weekdays | Weekly
- **Working folder:** Required (Desktop prompts to trust it)
- **Isolated worktree:** each run gets its own git worktree
- **Permission mode:** per-task + allow rules from `~/.claude/settings.json`

### Behavior
- Fires independently while app is open
- Staggered a few minutes (same task always gets same deterministic offset)
- Checks schedule every minute
- **Does NOT run** when app is closed, computer sleeps, or is off

### Catch-up on Wake
- On launch/wake, checks last 7 days
- Runs **one** catch-up for the most recently missed time
- Discards older missed runs

### Pre-approve Permissions
Click **Run now** immediately after creating, approve any permission prompts, click **Always allow** — prevents future stalls.

### Edit on disk
`~/.claude/scheduled-tasks/<task-name>/SKILL.md` — changes take effect on next run.

---

## Layer 3: Session Loops (`/loop`)

Runs while **Claude Code session is open**. Good for active-session automation.

### Three Modes

#### A. Fixed Interval
```
/loop 5m check if the deployment finished
/loop 30m /devto-collect
/loop every 2 hours run test suite
```
Units: `s` (seconds, rounded to nearest minute), `m`, `h`, `d`

#### B. Dynamic Interval
```
/loop check whether CI passed and address review comments
```
Claude chooses delay (1 min to 1 hour) based on activity — shorter while build is active, longer when quiet.

#### C. Bare Loop (Built-in maintenance)
```
/loop
/loop 15m
```
Default: continue unfinished work → tend PR (comments, CI, merge conflicts) → cleanup.
Override with `.claude/loop.md` or `~/.claude/loop.md`.

### One-time Reminders
```
remind me at 3pm to push the release branch
in 45 minutes, check whether integration tests passed
```
Single-fire task, auto-deletes after running.

### Task Management
```
what scheduled tasks do I have?     → calls CronList
cancel the deploy check job         → calls CronDelete(id: "...")
```

Or directly:
- `CronCreate(cron: "*/30 * * * *", prompt: "/devto-collect", recurring: true)`
- `CronList()` — see all jobs with IDs
- `CronDelete(id: "job-id")` — cancel

### Key Constraints
| Constraint | Value |
|-----------|-------|
| Auto-expiry (recurring) | 7 days after creation |
| Auto-expiry (one-shot) | After firing once |
| Max tasks per session | 50 |
| Fires during | Idle REPL only — not mid-conversation |
| All times | **Local timezone** (not UTC) |
| Jitter (recurring) | Up to 30 min after scheduled time (or half interval for sub-hourly) |
| Jitter (one-shot at :00/:30) | Up to 90 sec early |

### Cron Quick Reference
| Expression | Meaning |
|-----------|---------|
| `*/5 * * * *` | Every 5 minutes |
| `7 * * * *` | Every hour (at :07) |
| `17 9 * * *` | Every day at 9:17am |
| `23 4 * * 0` | Sundays at 4:23am |
| `0 9 * * 1-5` | Weekdays at 9am |

**Avoid `:00` and `:30`** — pick `:07`, `:17`, `:23`, etc. to reduce API spike overlap.

### Restoring After Session Close
```bash
claude --resume    # restores unexpired tasks (within 7 days)
claude --continue  # same
```
Background Bash and Monitor tasks are NOT restored on resume.

---

## Layer 4: Hooks (Always-On, Deterministic)

Hooks fire **automatically** at fixed lifecycle points — no LLM judgment. Configured in `settings.json`.

### Hook Events

| Event | Fires When | Common Uses |
|-------|-----------|-------------|
| `PreToolUse` | Before tool call | Block dangerous commands, validate, inject creds |
| `PostToolUse` | After tool succeeds | Auto-format, metrics, update cache |
| `PostToolUseFailure` | After tool fails | Log, retry, escalate |
| `PostToolBatch` | After batch of parallel tools | Inject conventions once |
| `Stop` | Session ends | Save state, cleanup, final notifications |
| `SessionStart` | Session begins | Load env, initialize |
| `UserPromptSubmit` | Before prompt processing | Inject context, log |
| `Notification` | Status messages | Desktop alerts, Slack, PagerDuty |

### Hook Types

```json
// 1. Shell command
{ "type": "command", "command": "prettier --write {{file_path}}" }

// 2. Async (fire-and-forget)
{ "type": "command", "command": "curl https://metrics.example.com", "async": true }

// 3. HTTP webhook
{ "type": "http", "url": "https://hooks.slack.com/services/YOUR/WEBHOOK", "async": true }

// 4. Prompt-based (Claude evaluates)
{ "type": "prompt", "prompt": "Should we allow this bash command?" }
```

### Configuration: `~/.claude/settings.json`
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": "prettier --write {{file_path}}" }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{{tool_input}}' | grep -q 'rm -rf' && exit 1 || exit 0"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "python3 ~/.claude/hooks/langfuse_hook.py" }
        ]
      }
    ]
  }
}
```

Exit codes: `0` = allow, `1` = deny, `2` = ask user.

**Matcher patterns:** tool name (`Bash`, `Write`, `Edit`, `^mcp__`, etc.), empty string = match all.

---

## Practical Recipes: dev.to Pipeline

### Recipe 1: Run collection now
```
/devto-collect
```
Runs the skill immediately — collects 50-100 new articles, commits, pushes.

### Recipe 2: Weekly permanent schedule (no laptop needed)
```
/schedule
```
Configure: name `devto-weekly`, cron `weekly on Sundays`, prompt `/devto-collect`.
Runs on Anthropic infra every Sunday. No machine required.

### Recipe 3: Weekly durable cron (on your machine)
Ask Claude:
> "Schedule /devto-collect every Sunday at 4am, durable"

Claude calls:
```
CronCreate(cron: "23 4 * * 0", prompt: "/devto-collect", recurring: true, durable: true)
```
Survives restarts (saved to `~/.claude/scheduled_tasks.json`), expires in 7 days.

### Recipe 4: Active-session polling (new topics)
```
/loop 2h /devto-collect "latest MCP releases" "new agent patterns"
```
Runs every 2 hours while session is open.

### Recipe 5: Auto-commit hook (fire-and-forget)
Add to `~/.claude/settings.json`:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "async": true,
        "command": "cd /var/lib/rancher/ansible/db/rd-main/rd-fine-10000-devto && git add articles/ && git diff --cached --quiet || git commit -m 'Auto: new devto articles $(date +%Y-%m-%d)'"
      }]
    }]
  }
}
```
Every new article written → auto-committed without blocking Claude.

### Recipe 6: API trigger from CI/CD
After your pipeline runs:
```bash
curl -X POST https://api.anthropic.com/v1/claude_code/routines/{routine_id}/fire \
  -H "Authorization: Bearer $ANTHROPIC_API_KEY" \
  -d '{"text": "Pipeline finished - collect new articles if any"}'
```

---

## Decision Guide

```
Need to run when laptop is closed?
  YES → Cloud Routine (/schedule)
  NO  → continue...

Need local file access (< 1 hour frequency)?
  YES → Desktop Scheduled Task
  NO  → continue...

Running during an active session?
  YES → /loop (quick, inherits session)
  NO  → Durable CronCreate

Need it to ALWAYS happen (no LLM judgment)?
  YES → Hook in settings.json
  NO  → Any of the above
```

---

## Config Files Reference

| File | Scope | Purpose |
|------|-------|---------|
| `~/.claude/settings.json` | All projects | Global hooks, permissions |
| `.claude/settings.json` | Project | Project-specific hooks, rules |
| `.claude/loop.md` | Project | Custom `/loop` default prompt |
| `~/.claude/loop.md` | User | User-level `/loop` default |
| `~/.claude/scheduled_tasks.json` | User | Durable CronCreate jobs |
| `~/.claude/scheduled-tasks/<name>/SKILL.md` | User | Desktop task definitions |

---

## Sources
- [Automate work with routines](https://code.claude.com/docs/en/routines.md)
- [Schedule recurring tasks (Desktop)](https://code.claude.com/docs/en/desktop-scheduled-tasks.md)
- [Run prompts on a schedule](https://code.claude.com/docs/en/scheduled-tasks.md)
- [Hooks guide](https://code.claude.com/docs/en/hooks-guide.md)
- [Hooks reference](https://code.claude.com/docs/en/hooks.md)
- [Agent SDK hooks](https://code.claude.com/docs/en/agent-sdk/hooks.md)
