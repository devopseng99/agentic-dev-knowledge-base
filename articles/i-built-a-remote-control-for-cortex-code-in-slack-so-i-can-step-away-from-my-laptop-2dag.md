---
title: "I built a remote control for Cortex Code in Slack so I can step away from my laptop"
url: "https://dev.to/snowflake/i-built-a-remote-control-for-cortex-code-in-slack-so-i-can-step-away-from-my-laptop-2dag"
author: "Dash (Snowflake)"
category: "ai-agent-slack-bot"
---

# I built a remote control for Cortex Code in Slack so I can step away from my laptop

**Author:** Dash (Snowflake)
**Published:** April 13, 2026

## Overview
A Slack-based remote control for Snowflake's Cortex Code CLI (AI coding agent). The bridge enables receiving notifications and sending instructions via Slack DMs while the agent executes tasks in the terminal. Built with ~300 lines of Python plus a shell wrapper with zero external dependencies.

## Key Concepts

### Design
- Socket Mode (no public URLs required)
- File-based inbox system (inbox_{session_id}.json)
- Metadata routing for multi-session support
- Background sidecar process architecture

### Architecture
- config.py: Configuration and session management with keychain integration
- bridge.py: Socket Mode bot handling inbound messages
- notify.py: Outbound messaging with color-coded DMs
- bin/coco-bridge: Shell wrapper with full command suite

## Code Examples

### Configuration with Keychain

```python
BRIDGE_DIR = Path.home() / ".cortex-slack-bridge"
INBOX_FILE = BRIDGE_DIR / "inbox.json"
PID_FILE = BRIDGE_DIR / "bridge.pid"

KEYCHAIN_SERVICE = "coco-slack-bridge"

def keychain_get(key: str) -> str | None:
    try:
        result = subprocess.run(
            ["security", "find-generic-password", "-s", KEYCHAIN_SERVICE, "-a", key, "-w"],
            capture_output=True, text=True, timeout=5,
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    return None
```

### Bridge Message Handler

```python
@app.event("message")
def handle_dm(event, say):
    user = event.get("user")
    if subtype or user != target_user:
        return

    _append_inbox({
        "type": "reply",
        "text": event.get("text", ""),
    })

    say("Message sent to CoCo CLI. Awaiting response...")
```

### Audit Trail

```python
def _log_history(entry: dict, direction: str):
    try:
        record = {**entry, "direction": direction, "logged_at": time.time()}
        with open(HISTORY_FILE, "a") as f:
            f.write(json.dumps(record) + "\n")
    except Exception:
        pass
```

### Session Metadata for Outbound Messages

```python
metadata = {
    "event_type": "cortex_bridge",
    "event_payload": {"session_id": sid},
}
```

### Installation

```shell
git clone https://github.com/iamontheinet/cortex-code-cli-slack-bridge.git \
  ~/Apps/cortex-code-cli-slack-bridge
cd ~/Apps/cortex-code-cli-slack-bridge
python3 -m venv .venv
.venv/bin/pip install -e .
```

### Skill Installation

```shell
mkdir -p ~/.snowflake/cortex/skills/slack-bridge
cp skill/SKILL.md ~/.snowflake/cortex/skills/slack-bridge/SKILL.md
```

### Hook Configuration

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/Users/YOUR_USERNAME/.cortex-slack-bridge/start-hook.sh",
            "timeout": 10,
            "enabled": true
          }
        ]
      }
    ]
  }
}
```

### Command Suite
- `coco-bridge start` / `stop` / `status`
- `coco-bridge send "message"` / `send "msg" --type success`
- `coco-bridge confirm "question"` (approval buttons)
- `coco-bridge inbox` / `history` / `logs`
- `coco-bridge setup-keychain` / `clear-keychain`
