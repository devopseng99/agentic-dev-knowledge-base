---
title: "Stop Loading 30 MCP Tools Into One Agent — 3 Design Patterns That Actually Work"
url: "https://dev.to/akshay_kumar_bm/stop-loading-30-mcp-tools-into-one-agent-3-design-patterns-that-actually-work-49l1"
author: "Akshay Kumar BM"
category: "agent-load-distribution"
---
# Stop Loading 30 MCP Tools Into One Agent — 3 Design Patterns That Actually Work
**Author:** Akshay Kumar BM  **Published:** March 15, 2026

## Overview
At 32K tokens of context, 11 tested models dropped below 50% of their short-context baseline. Three patterns to keep agents focused.

## Key Concepts

### Pattern 1: Sub-Agent Grouping
Organize tools by domain; orchestrator delegates to specialized sub-agents (5-8 tools each).

```python
from mcp.server.fastmcp import FastMCP

# Database sub-agent (3 tools only)
mcp = FastMCP("db-agent")

@mcp.tool()
def query_records(table: str, filters: dict = {}) -> list[dict]:
    """Query records from a table with optional filters."""
    conn = sqlite3.connect("app.db")
    where_clause = "WHERE " + " AND ".join([f"{k} = ?" for k in filters]) if filters else ""
    cursor.execute(f"SELECT * FROM {table} {where_clause}", list(filters.values()))
    columns = [d[0] for d in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]
```

Orchestrator delegates:
```python
@mcp.tool()
async def get_user_data(user_id: int) -> str:
    """Fetch user data — delegates to DB sub-agent."""
    return await call_sub_agent("db_agent_server.py", "query_records", {"table": "users", "filters": {"id": user_id}})

@mcp.tool()
async def notify_user(user_email: str, message: str) -> str:
    """Notify user — delegates to comms sub-agent."""
    return await call_sub_agent("comms_agent_server.py", "send_email", {"to": user_email, "subject": "Notification", "body": message})
```

### Pattern 2: Skill-as-Tool (Lazy Loading)
```python
@mcp.tool()
def list_skills() -> str:
    """List all available skill domains. Call this FIRST."""
    return json.dumps({name: info["description"] for name, info in SKILL_REGISTRY.items()}, indent=2)

@mcp.tool()
def discover_skill(skill_name: str) -> str:
    """Get full details for a specific skill. Call list_skills() first."""
    skill = SKILL_REGISTRY[skill_name]
    return json.dumps({"tools": skill["tools"], "usage_example": skill["example"]}, indent=2)
```

### Pattern 3: Parameterized Tool Consolidation
Combine related actions into single tools with `action` parameter. Reduces tool count by 60-70%.

```python
@mcp.tool()
def manage_ticket(
    action: Literal["create", "update", "close", "reopen", "get"],
    ticket_id: Optional[str] = None,
    title: Optional[str] = None,
    priority: Optional[Literal["low", "medium", "high"]] = None,
) -> str:
    """Manage support tickets. Use 'action' to specify operation."""
    if action == "create":
        tid = f"TKT-{str(uuid.uuid4())[:8].upper()}"
        TICKETS[tid] = {"id": tid, "title": title, "priority": priority, "status": "open"}
        return json.dumps({"created": TICKETS[tid]})
    if action == "get":
        return json.dumps(TICKETS[ticket_id])
    # ... etc
```

```python
@mcp.tool()
def manage_alert(
    action: Literal["acknowledge", "silence", "escalate", "get", "list"],
    alert_id: Optional[str] = None,
    silence_duration_minutes: Optional[int] = None,
    escalate_to: Optional[str] = None
) -> str:
    """Manage monitoring alerts."""
    if action == "silence":
        alert["status"] = "silenced"
        alert["silenced_for_minutes"] = silence_duration_minutes
        return json.dumps({"silenced": alert})
    # ...
```

### Key Takeaways
- Additional tools increase context tokens, degrading agent decision quality
- Sub-agent grouping keeps each agent's toolset focused (5-8 tools max)
- Lazy loading maintains minimal context; schemas load only on demand
- Parameterized consolidation reduces tool count by 60-70% without sacrificing capability
