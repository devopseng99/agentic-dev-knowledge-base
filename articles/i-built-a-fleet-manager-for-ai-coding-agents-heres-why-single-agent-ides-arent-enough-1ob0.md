---
title: "I Built a Fleet Manager for AI Coding Agents — Here's Why Single-Agent IDEs Aren't Enough"
url: "https://dev.to/bridgeace/i-built-a-fleet-manager-for-ai-coding-agents-heres-why-single-agent-ides-arent-enough-1ob0"
author: "Bridge ACE"
category: "agent-team-coordination"
---
# I Built a Fleet Manager for AI Coding Agents — Here's Why Single-Agent IDEs Aren't Enough
**Author:** Bridge ACE  **Published:** March 17, 2026

## Overview
Bridge ACE is a self-hosted, local-first platform that coordinates multiple AI coding agents. Supports Claude Code, Codex, Qwen CLI, Gemini CLI, and LiteLLM-compatible models. Apache 2.0 licensed.

## Key Concepts

### Agent Bus via WebSocket
```python
# bridge_mcp.py
BRIDGE_HTTP = "http://127.0.0.1:9111"
BRIDGE_WS   = "ws://127.0.0.1:9112"

bridge_register(agent_id, role, engine)
bridge_send(to="Backend", content="API endpoint ready")
bridge_receive()  # WebSocket push, not polling
bridge_heartbeat()  # Background, every 30s
```

### Scope Locks
```python
bridge_scope_lock(
    paths=["BRIDGE/Frontend/chat.html"],
    reason="Redesigning chat layout"
)
```

### Approval Gates
```python
class ApprovalPolicy(Enum):
    AUTO = "auto"               # File ops, messages, code → execute immediately
    LOG = "log"                 # Web searches → log but don't block
    REQUIRE_APPROVAL = "require" # Emails, calls, purchases → human must approve
```

### Soul Engine: Persistent Agent Identity
```python
@dataclass
class SoulConfig:
    agent_id: str
    name: str
    core_truths: list[str]
    strengths: str
    communication_style: str
    boundaries: list[str]
```

### Quick Start
```bash
git clone https://github.com/Luanace-lab/bridge-ide.git
cd bridge-ide
./install.sh
./Backend/start_platform.sh
# Open http://localhost:9111
```

### 204 MCP Tools across categories
- Agent Communication, Task Management, Scope & Approval
- Browser Automation (~40 tools), Desktop Automation (~18)
- Messaging (Email, Slack, Telegram, WhatsApp)
- Knowledge & Memory, Creator Studio, Data Platform
- Git Collaboration, Infrastructure

### Key Differentiators vs Competitors
Mixed-engine team support, scope locks, approval gates, WebSocket agent bus, persistent identity, fleet management UI, self-hosted operation.
