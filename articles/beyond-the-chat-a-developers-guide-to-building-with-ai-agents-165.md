---
title: "Beyond the Chat: A Developer's Guide to Building with AI Agents"
url: "https://dev.to/midas126/beyond-the-chat-a-developers-guide-to-building-with-ai-agents-165"
author: "Midas126"
category: "building chatbot agent"
---

# Beyond the Chat: A Developer's Guide to Building with AI Agents

**Author:** Midas126
**Published:** March 11, 2026

## Overview

Contrasts conversational AI with agentic systems, arguing that "the next frontier isn't about asking better questions -- it's about building AI that can execute." Covers the Reason-Act-Observe loop and builds a practical Code Review Agent.

## Key Concepts

### The Agentic Architecture - SimpleAgent Pattern

```python
class SimpleAgent:
    def __init__(self, llm, tools):
        self.llm = llm
        self.tools = tools
        self.memory = []

    def run(self, objective):
        plan = self.llm.generate_plan(objective)
        self.memory.append(f"Objective: {objective}")

        while not task_complete:
            action_spec = self.llm.decide_next_action(plan, self.memory, available_tools)
            result = self.execute_tool(action_spec['tool'], action_spec['input'])
            self.memory.append(f"Action: {action_spec['tool']}. Result: {result}")
            task_complete = self.llm.evaluate_status(objective, self.memory)
```

### Code Review Agent - Tool Definitions

```python
from langchain.tools import tool
import requests

@tool
def get_pr_diff(owner: str, repo: str, pr_number: int) -> str:
    """Fetches the diff for a GitHub Pull Request."""
    url = f"https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}"
    headers = {"Accept": "application/vnd.github.v3.diff"}
    response = requests.get(url, headers=headers)
    return response.text

@tool
def get_file_contents(owner: str, repo: str, filepath: str, ref: str = "main") -> str:
    """Fetches the contents of a specific file in a repo."""
    url = f"https://api.github.com/repos/{owner}/{repo}/contents/{filepath}?ref={ref}"
    response = requests.get(url)
    content_data = response.json()
    import base64
    return base64.b64decode(content_data['content']).decode('utf-8')
```

### Agent Instantiation with ReAct

```python
from langchain_openai import ChatOpenAI
from langchain.agents import create_react_agent, AgentExecutor
from langchain import hub

prompt = hub.pull("hwchase17/react")
llm = ChatOpenAI(model="gpt-4-turbo", temperature=0)
tools = [get_pr_diff, get_file_contents]
agent = create_react_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True, handle_parsing_errors=True)
```

### Running the Agent

```python
result = agent_executor.invoke({
    "input": "Review pull request #42 in the 'myorg/awesome-api' repository. Focus on security best practices and error handling in the changed files. Provide a summary."
})
```

### Key Challenges

1. **Hallucinated Tool Calls** - LLMs may invoke nonexistent tools. Use structured output and robust error handling.
2. **Infinite Loops** - Implement step counters and clear termination conditions.
3. **Cost & Latency** - Use smaller models for simple tasks, cache results.
