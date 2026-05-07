---
title: "How to Build an AI Agent from Scratch Using Claude API (With Full Code)"
url: https://dev.to/dextralabs/how-to-build-an-ai-agent-from-scratch-using-claude-api-with-full-code-4b40
author: Dextra Labs
category: ai-agent-tutorial-claude
---

# How to Build an AI Agent from Scratch Using Claude API (With Full Code)

**Author:** Dextra Labs
**Published:** March 22, 2026
**Last Updated:** May 2, 2026
**Tags:** #architecture #ai #duedilligence #softwareengineering

---

## Overview

This tutorial demonstrates building a functional AI agent using Anthropic's Claude API. Rather than treating language models as simple search engines, the guide shows how to construct a ReAct (Reasoning + Acting) loop -- a pattern that enables real-world agent workflows.

---

## What You'll Build

The agent architecture accomplishes the following:

- Accepts user queries
- Determines which tools are needed
- Executes those tools and observes results
- Reasons over findings to either invoke additional tools or deliver final answers

---

## Prerequisites

```bash
pip install anthropic python-dotenv
```

Store your Claude API key in a `.env` file:
```
ANTHROPIC_API_KEY=your_key_here
```

---

## Step 1: Basic Claude API Setup

```python
import os
import anthropic
from dotenv import load_dotenv

load_dotenv()

client = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))

def ask_claude(prompt: str) -> str:
    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=1024,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )
    return message.content[0].text

print(ask_claude("What is 2 + 2? Answer in one word."))
```

---

## Step 2: Define Your Tools

Tools are represented as JSON schemas that Claude reads to decide when and how to invoke them:

```python
tools = [
    {
        "name": "calculator",
        "description": "Performs basic arithmetic. Use this for any math operations.",
        "input_schema": {
            "type": "object",
            "properties": {
                "expression": {
                    "type": "string",
                    "description": "Math expression to evaluate, e.g. '15 * 24 + 100'"
                }
            },
            "required": ["expression"]
        }
    },
    {
        "name": "web_search",
        "description": "Searches the web for current information on a topic.",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": "The search query"
                }
            },
            "required": ["query"]
        }
    },
    {
        "name": "save_to_file",
        "description": "Saves text content to a local file.",
        "input_schema": {
            "type": "object",
            "properties": {
                "filename": {"type": "string"},
                "content": {"type": "string"}
            },
            "required": ["filename", "content"]
        }
    }
]
```

Implement the underlying functions:

```python
import math

def calculator(expression: str) -> str:
    try:
        allowed = {k: v for k, v in math.__dict__.items()
                   if not k.startswith("__")}
        result = eval(expression, {"__builtins__": {}}, allowed)
        return f"Result: {result}"
    except Exception as e:
        return f"Error: {str(e)}"

def web_search(query: str) -> str:
    return (f"Search results for '{query}': "
            f"[Simulated] Top result: Relevant information about {query} "
            f"from authoritative sources. Published 2025.")

def save_to_file(filename: str, content: str) -> str:
    try:
        with open(filename, 'w') as f:
            f.write(content)
        return f"Successfully saved to {filename}"
    except Exception as e:
        return f"Error saving file: {str(e)}"

def execute_tool(tool_name: str, tool_input: dict) -> str:
    if tool_name == "calculator":
        return calculator(tool_input["expression"])
    elif tool_name == "web_search":
        return web_search(tool_input["query"])
    elif tool_name == "save_to_file":
        return save_to_file(tool_input["filename"], tool_input["content"])
    else:
        return f"Unknown tool: {tool_name}"
```

---

## Step 3: Build the ReAct Agent Loop

This is the core mechanism. The loop continues until Claude returns a final answer:

```python
def run_agent(user_query: str, max_iterations: int = 10) -> str:
    print(f"\n{'='*50}")
    print(f"User: {user_query}")
    print(f"{'='*50}")

    messages = [
        {"role": "user", "content": user_query}
    ]

    system_prompt = """You are a helpful AI agent with access to tools.
    Think step by step. Use tools when you need real data or calculations.
    When you have enough information, provide a clear final answer."""

    for iteration in range(max_iterations):
        print(f"\n[Iteration {iteration + 1}]")

        response = client.messages.create(
            model="claude-sonnet-4-5",
            max_tokens=4096,
            system=system_prompt,
            tools=tools,
            messages=messages
        )

        print(f"Stop reason: {response.stop_reason}")

        if response.stop_reason == "end_turn":
            final_answer = ""
            for block in response.content:
                if hasattr(block, 'text'):
                    final_answer += block.text
            print(f"\nFinal Answer: {final_answer}")
            return final_answer

        if response.stop_reason == "tool_use":
            messages.append({
                "role": "assistant",
                "content": response.content
            })

            tool_results = []
            for block in response.content:
                if block.type == "tool_use":
                    print(f"  Tool: {block.name}")
                    print(f"  Input: {block.input}")

                    result = execute_tool(block.name, block.input)
                    print(f"  Result: {result}")

                    tool_results.append({
                        "type": "tool_result",
                        "tool_use_id": block.id,
                        "content": result
                    })

            messages.append({
                "role": "user",
                "content": tool_results
            })

    return "Max iterations reached without a final answer."
```

---

## Step 4: Run the Agent

```python
if __name__ == "__main__":
    result = run_agent(
        "Calculate compound interest on $10,000 at 7% for 10 years, "
        "then save the result to 'investment.txt'"
    )

    result = run_agent(
        "Search for information about RAG architecture "
        "and summarize the key components."
    )

    result = run_agent(
        "What is the square root of 144 multiplied by the number of days "
        "in a leap year?"
    )
```

---

## Step 5: Adding Memory (Production Upgrade)

For stateful conversations across multiple queries:

```python
class AgentWithMemory:
    def __init__(self):
        self.conversation_history = []
        self.client = anthropic.Anthropic(
            api_key=os.getenv("ANTHROPIC_API_KEY")
        )

    def chat(self, user_message: str) -> str:
        self.conversation_history.append({
            "role": "user",
            "content": user_message
        })

        response = self.client.messages.create(
            model="claude-sonnet-4-5",
            max_tokens=4096,
            system="You are a helpful assistant with memory of our conversation.",
            tools=tools,
            messages=self.conversation_history
        )

        if response.stop_reason == "tool_use":
            self.conversation_history.append({
                "role": "assistant",
                "content": response.content
            })
            tool_results = []
            for block in response.content:
                if block.type == "tool_use":
                    result = execute_tool(block.name, block.input)
                    tool_results.append({
                        "type": "tool_result",
                        "tool_use_id": block.id,
                        "content": result
                    })
            self.conversation_history.append({
                "role": "user",
                "content": tool_results
            })
            return self.chat("")

        assistant_message = response.content[0].text
        self.conversation_history.append({
            "role": "assistant",
            "content": assistant_message
        })
        return assistant_message

# Usage
agent = AgentWithMemory()
print(agent.chat("My budget is $50,000. Calculate 7% annual return over 5 years."))
print(agent.chat("Now do the same calculation but for 10 years."))
```

---

## Key Takeaways

1. **ReAct Pattern**: "Think step by step. Use tools when you need real data or calculations. When you have enough information, provide a clear final answer."

2. **Message History**: Every tool call and result must be appended to maintain state across iterations -- this separates stateful agents from stateless chatbots.

3. **Tool Definitions**: Tools are JSON schemas that guide Claude's decision-making about when and how to invoke functions.

4. **Next Steps for Production**: Implement streaming responses, error handling with retries, async execution for parallel tool calls, and structured outputs using Pydantic models.

---

## Resources

- Full repository: github.com/dextralabs/claude-agent-tutorial
- Related guides: Fine-tuning Claude, Claude MCP, AI agent deployment architectures
