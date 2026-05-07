---
title: "How to Build Your First AI Agent: A Step-by-Step Tutorial"
url: https://dev.to/_d7eb1c1703182e3ce1782/how-to-build-your-first-ai-agent-a-step-by-step-tutorial-415n
author: Yang Donglin
category: ai-agents-tutorial
---

# How to Build Your First AI Agent: A Step-by-Step Tutorial

**Author:** Yang Donglin
**Published:** March 20, 2026
**Tags:** #ai #machinelearning #programming #tutorial

---

## Overview

This comprehensive guide demonstrates how to construct a functional Python agent that incorporates reasoning, tool usage, memory retention across sessions, and extensibility into multi-agent architectures. The patterns apply universally across Claude, GPT-4, and open-source language models.

## Key Distinctions: Chatbots vs. Agents

A **chatbot** receives input and returns output without taking real-world actions. An **AI agent** operates within a feedback loop enabling it to:

- **Perceive** surroundings (access files, query APIs, review logs)
- **Reason** about next steps (planning, self-reflection)
- **Act** on the environment (execute code, call APIs, modify files)
- **Remember** outcomes (short-term buffers, persistent storage)

The fundamental architecture follows this pattern:
```
while goal is not achieved:
    observe the environment
    think about the next step
    take an action
    record the result
```

## Agent Architecture Framework

Four core pillars support every production agent:

1. **LLM** -- The reasoning engine determining what to do and interpreting results
2. **Tools** -- External functions the agent can invoke
3. **Memory** -- Short-term conversation context and long-term persistent storage
4. **Planning** -- Strategy layer decomposing goals and handling re-planning

---

## Implementation: Step-by-Step Build

### Step 1: Project Setup

```bash
mkdir ai-agent && cd ai-agent
python -m venv venv
source venv/bin/activate   # Windows: venv\Scripts\activate

pip install anthropic openai tiktoken rich
```

Directory structure:
```
ai-agent/
  agent/
    __init__.py
    core.py          # main agent loop
    tools.py         # tool definitions
    memory.py        # memory system
    planner.py       # planning logic
  config.py          # API keys, model settings
  main.py            # entry point
```

Configuration file (`config.py`):
```python
import os

MODEL = "claude-sonnet-4-20250514"
API_KEY = os.environ["ANTHROPIC_API_KEY"]
MAX_ITERATIONS = 20
VERBOSE = True
```

### Step 2: The Agent Loop

The agent loop serves as the core mechanism, sending messages to the language model, checking for tool invocations, executing tools, feeding results back, and repeating until completion.

```python
# agent/core.py
import anthropic
from config import MODEL, API_KEY, MAX_ITERATIONS, VERBOSE
from agent.tools import TOOL_DEFINITIONS, execute_tool
from agent.memory import MemoryStore

client = anthropic.Anthropic(api_key=API_KEY)

SYSTEM_PROMPT = """You are a helpful AI agent. You can use tools to accomplish tasks.
Think step-by-step. When you have completed the user's request, respond
with your final answer without calling any more tools."""


def run_agent(user_message: str, memory: MemoryStore) -> str:
    """Run the agent loop until completion or max iterations."""

    # Load relevant memories
    context = memory.retrieve(user_message, top_k=5)

    messages = []
    if context:
        messages.append({
            "role": "user",
            "content": f"Relevant context from previous sessions:\n{context}"
        })
        messages.append({
            "role": "assistant",
            "content": "Thanks, I'll keep that context in mind."
        })

    messages.append({"role": "user", "content": user_message})

    for iteration in range(MAX_ITERATIONS):
        if VERBOSE:
            print(f"\n--- Iteration {iteration + 1} ---")

        response = client.messages.create(
            model=MODEL,
            max_tokens=4096,
            system=SYSTEM_PROMPT,
            tools=TOOL_DEFINITIONS,
            messages=messages,
        )

        # Check stop reason
        if response.stop_reason == "end_turn":
            final_text = _extract_text(response)
            memory.store(user_message, final_text)
            return final_text

        # Process tool calls
        assistant_content = response.content
        messages.append({"role": "assistant", "content": assistant_content})

        tool_results = []
        for block in assistant_content:
            if block.type == "tool_use":
                if VERBOSE:
                    print(f"  Tool: {block.name}({block.input})")
                result = execute_tool(block.name, block.input)
                if VERBOSE:
                    print(f"  Result: {result[:200]}")
                tool_results.append({
                    "type": "tool_result",
                    "tool_use_id": block.id,
                    "content": result,
                })

        messages.append({"role": "user", "content": tool_results})

    return "Agent reached maximum iterations without completing the task."


def _extract_text(response) -> str:
    return "".join(
        block.text for block in response.content if hasattr(block, "text")
    )
```

### Step 3: Tool Definition and Implementation

```python
# agent/tools.py
import subprocess
import json
import os
import urllib.request
import urllib.parse

TOOL_DEFINITIONS = [
    {
        "name": "calculator",
        "description": "Evaluate a mathematical expression. Use Python syntax.",
        "input_schema": {
            "type": "object",
            "properties": {
                "expression": {
                    "type": "string",
                    "description": "A Python math expression, e.g. '2 ** 10 + 3'",
                }
            },
            "required": ["expression"],
        },
    },
    {
        "name": "read_file",
        "description": "Read the contents of a file from disk.",
        "input_schema": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "Absolute or relative file path.",
                }
            },
            "required": ["path"],
        },
    },
    {
        "name": "write_file",
        "description": "Write content to a file on disk.",
        "input_schema": {
            "type": "object",
            "properties": {
                "path": {"type": "string", "description": "File path to write to."},
                "content": {"type": "string", "description": "Content to write."},
            },
            "required": ["path", "content"],
        },
    },
    {
        "name": "run_python",
        "description": "Execute a Python script and return stdout/stderr.",
        "input_schema": {
            "type": "object",
            "properties": {
                "code": {
                    "type": "string",
                    "description": "Python code to execute.",
                }
            },
            "required": ["code"],
        },
    },
    {
        "name": "web_search",
        "description": "Search the web and return top results.",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {"type": "string", "description": "Search query."}
            },
            "required": ["query"],
        },
    },
]


def execute_tool(name: str, inputs: dict) -> str:
    """Dispatch a tool call and return the result as a string."""
    try:
        if name == "calculator":
            allowed = {
                "__builtins__": {},
                "abs": abs, "round": round, "min": min, "max": max,
                "pow": pow, "sum": sum,
            }
            import math
            allowed.update(vars(math))
            result = eval(inputs["expression"], allowed)
            return str(result)

        elif name == "read_file":
            with open(inputs["path"], "r", encoding="utf-8") as f:
                content = f.read()
            return content[:10_000]

        elif name == "write_file":
            with open(inputs["path"], "w", encoding="utf-8") as f:
                f.write(inputs["content"])
            return f"Successfully wrote {len(inputs['content'])} chars to {inputs['path']}"

        elif name == "run_python":
            result = subprocess.run(
                ["python", "-c", inputs["code"]],
                capture_output=True, text=True, timeout=30,
                encoding="utf-8", errors="replace",
            )
            output = result.stdout + result.stderr
            return output[:5_000] or "(no output)"

        elif name == "web_search":
            return f"[Search results for '{inputs['query']}' would appear here. Integrate a real search API for production use.]"

        else:
            return f"Unknown tool: {name}"

    except Exception as e:
        return f"Tool error: {type(e).__name__}: {e}"
```

**Tool Design Principles:**

- Keep schemas precise with clear descriptions and examples
- Return strings rather than complex objects
- Truncate large outputs to preserve context window tokens
- Sandbox code execution in containers or managed environments
- Set timeouts on all network and subprocess calls

### Step 4: Memory System

```python
# agent/memory.py
import json
import os
from datetime import datetime
from pathlib import Path

MEMORY_DIR = Path("memory")
MEMORY_FILE = MEMORY_DIR / "memories.jsonl"


class MemoryStore:
    """Simple file-based memory with keyword retrieval."""

    def __init__(self):
        MEMORY_DIR.mkdir(exist_ok=True)
        if not MEMORY_FILE.exists():
            MEMORY_FILE.touch()

    def store(self, query: str, response: str, metadata: dict = None):
        """Store a memory entry."""
        entry = {
            "timestamp": datetime.now().isoformat(),
            "query": query,
            "response": response[:2000],
            "metadata": metadata or {},
        }
        with open(MEMORY_FILE, "a", encoding="utf-8") as f:
            f.write(json.dumps(entry, ensure_ascii=False) + "\n")

    def retrieve(self, query: str, top_k: int = 5) -> str:
        """Retrieve relevant memories using keyword matching."""
        if not MEMORY_FILE.exists():
            return ""

        query_words = set(query.lower().split())
        scored = []

        with open(MEMORY_FILE, "r", encoding="utf-8") as f:
            for line in f:
                if not line.strip():
                    continue
                entry = json.loads(line)
                entry_words = set(entry["query"].lower().split())
                overlap = len(query_words & entry_words)
                if overlap > 0:
                    scored.append((overlap, entry))

        scored.sort(key=lambda x: x[0], reverse=True)
        top = scored[:top_k]

        if not top:
            return ""

        parts = ["## Relevant Memories\n"]
        for score, entry in top:
            parts.append(
                f"- **{entry['timestamp'][:10]}** | Q: {entry['query'][:100]}\n"
                f"  A: {entry['response'][:300]}\n"
            )
        return "\n".join(parts)

    def store_lesson(self, topic: str, lesson: str):
        """Store a reusable lesson learned."""
        self.store(
            query=f"LESSON: {topic}",
            response=lesson,
            metadata={"type": "lesson"},
        )
```

**Production Upgrade -- Vector-Based Memory:**

```python
# Example: ChromaDB integration
import chromadb

class VectorMemoryStore:
    def __init__(self, collection_name="agent_memory"):
        self.client = chromadb.PersistentClient(path="./memory/chroma")
        self.collection = self.client.get_or_create_collection(collection_name)
        self._counter = self.collection.count()

    def store(self, query: str, response: str, metadata: dict = None):
        self._counter += 1
        self.collection.add(
            documents=[f"Q: {query}\nA: {response}"],
            ids=[f"mem_{self._counter}"],
            metadatas=[metadata or {}],
        )

    def retrieve(self, query: str, top_k: int = 5) -> str:
        results = self.collection.query(
            query_texts=[query], n_results=top_k
        )
        if not results["documents"][0]:
            return ""
        return "\n\n".join(results["documents"][0])
```

### Step 5: Planning Layer

Basic planning wrapper:

```python
# agent/planner.py

PLANNING_PROMPT = """Before taking action, create a brief plan.

Format your plan as:
## Plan
1. [First step]
2. [Second step]
...

## Current Step
I will now execute step 1: [description]

After each tool call, update your progress:
- Step 1: DONE / FAILED
- Step 2: IN PROGRESS
- Step 3: TODO

If a step fails, revise the plan before continuing."""


def wrap_with_planning(user_message: str) -> str:
    """Wrap a user message with planning instructions."""
    return f"""{user_message}

{PLANNING_PROMPT}"""
```

Integrate into the agent loop by modifying `run_agent`:

```python
from agent.planner import wrap_with_planning

# Inside run_agent, before building messages:
user_message = wrap_with_planning(user_message)
```

**Advanced: ReAct Pattern with Extended Thinking**

```python
response = client.messages.create(
    model="claude-sonnet-4-20250514",
    max_tokens=16000,
    thinking={
        "type": "enabled",
        "budget_tokens": 10000,
    },
    system=SYSTEM_PROMPT,
    tools=TOOL_DEFINITIONS,
    messages=messages,
)
```

### Step 6: Entry Point

```python
# main.py
from agent.core import run_agent
from agent.memory import MemoryStore
from rich.console import Console

console = Console()
memory = MemoryStore()


def main():
    console.print("[bold green]AI Agent Ready[/bold green]")
    console.print("Type 'quit' to exit, 'memories' to view stored memories.\n")

    while True:
        user_input = console.input("[bold blue]You:[/bold blue] ").strip()

        if not user_input:
            continue
        if user_input.lower() == "quit":
            console.print("[dim]Goodbye![/dim]")
            break
        if user_input.lower() == "memories":
            console.print(memory.retrieve("", top_k=10) or "No memories yet.")
            continue

        console.print("[dim]Agent is thinking...[/dim]")
        result = run_agent(user_input, memory)
        console.print(f"\n[bold green]Agent:[/bold green] {result}\n")


if __name__ == "__main__":
    main()
```

Run the agent:
```bash
export ANTHROPIC_API_KEY="your-key-here"
python main.py
```

---

## Multi-Agent Systems

### Common Orchestration Patterns

**1. Manager-Worker Architecture:**
A manager decomposes tasks and delegates to specialized workers.

**2. Pipeline Pattern:**
Sequential processing where output from one agent feeds into the next.

**3. Debate/Consensus:**
Multiple agents propose solutions, critique each other, and converge on answers.

---

## Production Deployment Considerations

### 1. Cost Control
- Set hard iteration limits
- Monitor token usage per session
- Use cheaper models for simple routing
- Implement token caching

### 2. Error Handling
Implement retry logic with exponential backoff for tool failures.

### 3. Safety and Sandboxing
- Execute code in Docker containers or cloud sandboxes
- Implement permission-based tool allowlists
- Add human-in-the-loop for destructive actions
- Maintain comprehensive audit logs

### 4. Observability
Log all LLM requests, tool calls, planning decisions, and memory operations using tools like Langfuse or Braintrust.

### 5. Latency Reduction
- Stream responses
- Parallelize tool calls
- Use prompt caching

### 6. Testing Strategy
- Scenario-based tests for acceptable outputs
- Tool call assertion tests
- Regression testing with saved agent traces
- Cost and performance benchmarks

---

## Common Pitfalls to Avoid

1. **Too many tools** -- Start with 5-10, add more when necessary
2. **No iteration limits** -- Runaway loops burn budget
3. **Ignoring memory** -- Even simple file-based memory improves user experience
4. **Monolithic prompts** -- Keep base prompts short, inject context dynamically
5. **Reactive-only agents** -- Always include basic planning
6. **No human oversight** -- Build confidence thresholds and escalation paths

---

## Key Takeaways

The agent loop -- observe, reason, act, remember -- applies across all implementations. Start with a single agent with basic tools and memory, add planning prompts, then expand to multi-agent systems only when hitting clear limits. Integrate safety measures, observability, and error handling from the beginning.
