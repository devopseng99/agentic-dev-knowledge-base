---
title: "Building an AI Agent Harness from Scratch: The Architecture Between LLM and Agent"
url: https://dev.to/thedailyagent/building-an-ai-agent-harness-from-scratch-the-architecture-between-llm-and-agent-5gg6
author: The Daily Agent
category: ai-agent-architecture
---

# Building an AI Agent Harness from Scratch: The Architecture Between LLM and Agent

**Author:** The Daily Agent
**Published:** April 30, 2026
**Series:** Building Production AI Agents (Part 21 of 26)

---

## Overview

The article argues that what distinguishes a functional AI agent from a simple LLM interface isn't the model itself, but the orchestration layer surrounding it. The author emphasizes: "Give Claude Sonnet or GPT-4o a chat interface and you get conversational AI. Wrap it in a loop that can call external tools, maintain state across turns, enforce budget limits, and validate its own outputs -- and you get an agent."

---

## Core Components of an Agent Harness

### 1. **Minimal Agent Harness Architecture**

```python
import json
from typing import Callable, Any
from dataclasses import dataclass, field

@dataclass
class Tool:
    name: str
    description: str
    parameters: dict  # JSON Schema
    fn: Callable

class AgentHarness:
    def __init__(self, model, system_prompt: str = ""):
        self.model = model
        self.system_prompt = system_prompt
        self.tools: dict[str, Tool] = {}
        self.max_iterations = 10

    def register_tool(self, tool: Tool):
        self.tools[tool.name] = tool

    def tool_list(self) -> list[dict]:
        return [
            {"type": "function", "function": {
                "name": t.name, "description": t.description,
                "parameters": t.parameters,
            }}
            for t in self.tools.values()
        ]

    def run(self, user_input: str) -> str:
        messages = [
            {"role": "system", "content": self.system_prompt},
            {"role": "user", "content": user_input},
        ]
        for i in range(self.max_iterations):
            response = self.model.chat(
                messages=messages, tools=self.tool_list() if self.tools else None,
            )
            if not response.tool_calls:
                return response.content
            messages.append(response.message)
            for call in response.tool_calls:
                tool = self.tools.get(call.function.name)
                if not tool:
                    result = f"Error: Unknown tool '{call.function.name}'"
                else:
                    try:
                        args = json.loads(call.function.arguments)
                        result = tool.fn(**args)
                    except Exception as e:
                        result = f"Error: {type(e).__name__}: {e}"
                messages.append({"role": "tool", "content": str(result), "tool_call_id": call.id})
        return "Max iterations reached."
```

---

### 2. **Tool Registry with Validation**

```python
class ToolRegistry:
    def __init__(self):
        self.tools: dict[str, Tool] = {}
        self.call_counts: dict[str, int] = {}

    def register(self, tool: Tool):
        self.tools[tool.name] = tool
        self.call_counts[tool.name] = 0

    def validate_call(self, tool_name: str, arguments: dict) -> tuple[bool, str]:
        if tool_name not in self.tools:
            return False, f"Unknown tool: {tool_name}"
        schema = self.tools[tool_name].parameters
        for field in schema.get("required", []):
            if field not in arguments:
                return False, f"Missing required parameter: {field}"
        for arg_name, arg_value in arguments.items():
            if arg_name not in schema.get("properties", {}):
                return False, f"Unexpected parameter: {arg_name}"
        return True, "OK"

    def execute(self, tool_name: str, arguments: dict) -> Any:
        self.call_counts[tool_name] += 1
        return self.tools[tool_name].fn(**arguments)
```

**Problem Addressed:** Schema validation catches 60-70% of tool-call errors before they reach application code.

---

### 3. **Intelligent Memory Management**

```python
import tiktoken
from dataclasses import dataclass

@dataclass
class MemoryConfig:
    max_context_tokens: int = 64_000
    keep_recent_messages: int = 8
    always_preserve_system: bool = True

class AgentMemory:
    def __init__(self, config: MemoryConfig):
        self.config = config
        self.messages: list[dict] = []
        self.encoder = tiktoken.encoding_for_model("gpt-4o")

    def add(self, role: str, content: str, **kwargs):
        self.messages.append({"role": role, "content": content, **kwargs})

    def get_messages(self) -> list[dict]:
        total = sum(len(self.encoder.encode(m.get("content", ""))) + 4 for m in self.messages)
        if total <= self.config.max_context_tokens:
            return self.messages
        return self._compress()

    def _compress(self) -> list[dict]:
        keep = self.config.keep_recent_messages
        system_msg = None
        if self.config.always_preserve_system:
            system_msgs = [m for m in self.messages if m["role"] == "system"]
            if system_msgs:
                system_msg = system_msgs[0]
        recent = self.messages[-keep:]
        old = self.messages[:-keep]
        if not old:
            return [system_msg] + recent if system_msg else recent
        old_text = "\n".join(f"[{m['role']}]: {m.get('content', '')[:200]}" for m in old)
        summary = " | ".join([line[:100] for line in old_text.split("\n") if any(kw in line.lower() for kw in ["tool:", "result:", "error:"])][:10])
        compressed = [{"role": "system", "content": f"[EARLIER CONTEXT: {summary}]"}]
        if system_msg:
            compressed = [system_msg] + compressed
        compressed.extend(recent)
        return compressed
```

**Problem Addressed:** Uses a "hot-cache pattern" to prevent context window bloat during extended conversations.

---

### 4. **Budget Enforcement**

```python
from dataclasses import dataclass
import time

@dataclass
class BudgetConfig:
    max_tokens: int = 30_000
    max_tool_calls: int = 25
    max_time_seconds: float = 300.0
    max_per_tool_calls: int = 5

class BudgetEnforcer:
    def __init__(self, config: BudgetConfig):
        self.config = config
        self.tokens_used = 0
        self.tool_calls_total = 0
        self.tool_calls_per_tool: dict[str, int] = {}
        self.start_time = time.time()

    def record_tokens(self, input_tokens: int, output_tokens: int):
        self.tokens_used += input_tokens + output_tokens

    def record_tool_call(self, tool_name: str):
        self.tool_calls_total += 1
        self.tool_calls_per_tool[tool_name] = self.tool_calls_per_tool.get(tool_name, 0) + 1

    def check(self) -> str | None:
        if self.tokens_used >= self.config.max_tokens:
            return f"Token budget exceeded: {self.tokens_used} (limit {self.config.max_tokens})"
        if self.tool_calls_total >= self.config.max_tool_calls:
            return f"Tool call budget exceeded: {self.tool_calls_total}"
        if time.time() - self.start_time >= self.config.max_time_seconds:
            return "Time budget exceeded"
        for tool, count in self.tool_calls_per_tool.items():
            if count >= self.config.max_per_tool_calls:
                return f"Per-tool limit: '{tool}' called {count} times"
        return None
```

**Problem Addressed:** Four budget types prevent cost spirals: token, tool call, time, and per-tool limits.

---

### 5. **Structured Error Handling**

```python
from enum import Enum
from dataclasses import dataclass

class ErrorType(Enum):
    TRANSIENT = "transient"
    PERMANENT = "permanent"
    UNAVAILABLE = "unavailable"

@dataclass
class ToolError:
    error_type: ErrorType
    message: str
    suggestion: str

def format_tool_error(error: ToolError) -> str:
    parts = [f"[TOOL ERROR: {error.error_type.value.upper()}]"]
    parts.append(error.message)
    if error.suggestion:
        parts.append(f"Suggested action: {error.suggestion}")
    return "\n".join(parts)
```

**Problem Addressed:** Classifies errors with suggested recovery actions so the model understands context.

---

### 6. **State Persistence & Audit Logs**

```python
import json
import sqlite3
from datetime import datetime, UTC

class AgentState:
    def __init__(self, db_path: str = "agent_state.db"):
        self.db = sqlite3.connect(db_path)
        self.db.execute("""CREATE TABLE IF NOT EXISTS sessions (
            session_id TEXT PRIMARY KEY, created_at TEXT,
            last_active TEXT, user_id TEXT)""")
        self.db.execute("""CREATE TABLE IF NOT EXISTS tool_invocations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id TEXT, turn_number INTEGER,
            tool_name TEXT, arguments TEXT, result TEXT,
            success INTEGER, duration_ms INTEGER, timestamp TEXT)""")
        self.db.commit()

    def create_session(self, session_id: str, user_id: str):
        self.db.execute(
            "INSERT INTO sessions VALUES (?, ?, ?, ?)",
            (session_id, datetime.now(UTC).isoformat(), datetime.now(UTC).isoformat(), user_id))
        self.db.commit()

    def record_tool_invocation(self, session_id: str, turn: int,
                                tool: str, args: dict, result: str,
                                success: bool, duration_ms: int):
        self.db.execute(
            "INSERT INTO tool_invocations VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?)",
            (session_id, turn, tool, json.dumps(args), result,
             int(success), duration_ms, datetime.now(UTC).isoformat()))
        self.db.commit()

    def get_analytics(self, session_id: str) -> dict:
        total = self.db.execute("SELECT COUNT(*) FROM tool_invocations WHERE session_id = ?", (session_id,)).fetchone()[0]
        rate = self.db.execute("SELECT AVG(success) FROM tool_invocations WHERE session_id = ?", (session_id,)).fetchone()[0] or 0
        return {"total_invocations": total, "success_rate": round(rate * 100, 1)}
```

---

## Key Takeaways

1. **Start with the loop.** The call-observe-decide-repeat pattern is fundamental; focus on getting the harness right before optimizing the model.

2. **Validate before dispatch.** Schema validation catches the majority of errors before they reach application code.

3. **Compress context aggressively.** Keep recent messages as your hot cache, summarize old ones, and preserve the system prompt.

4. **Enforce budgets in code.** Budget enforcement is "a guarantee" while prompt-based limits are merely "a suggestion."

5. **Structure error messages.** Classification (transient/permanent/unavailable) with suggested actions helps the model make informed decisions.

6. **Log everything.** Tool invocations with arguments, results, durations, and success status enable debugging when things go wrong.

7. **Harness first, model second.** "A well-harnessed GPT-3.5 outperforms an unharnessed GPT-4o every time."

---

## Architecture Summary

```
User Input
    |
+-------------------------------+
|     Budget Enforcer           |  <- Checks before every iteration
+-------------------------------+
|     Agent Memory              |  <- Compresses old context
+-------------------------------+
|     LLM Call                  |  <- With tool definitions
+-----------------+-------------+
|   tool calls?   |   no -> return
+-----------------+
|  Tool Registry   |  <- Schema + type validation
+-------------------------------+
|  Safe Execute    |  <- Structured errors with suggestions
+-------------------------------+
|  Agent State     |  <- Log turn + tool invocation
+-------------------------------+
         loop back
```

Each component handles a single responsibility. The harness coordinates them all, with the model functioning as one node within the system rather than the central authority.
