---
title: "Building Advanced AI Agents with LangChain's DeepAgents: A Hands-On Guide"
url: "https://dev.to/samadhi_patil_294a4ff7fea/building-advanced-ai-agents-with-langchains-deepagents-a-hands-on-guide-1bk4"
author: "samadhi patil"
category: "deep-agents"
---

# Building Advanced AI Agents with LangChain's DeepAgents: A Hands-On Guide

**Author:** samadhi patil
**Published:** October 29, 2025
**Tags:** #ai #langchain #python #tutorial

---

## Summary

This comprehensive guide demonstrates how to build sophisticated AI agents using LangChain's DeepAgents framework. Rather than creating simple tool-calling systems, the article shows how to construct agents capable of strategic planning, context management, task delegation, and iterative quality control.

## Key Concepts

### The Problem with Basic Agents

Traditional agents lack critical capabilities for complex workflows. They struggle with token limits, lose context mid-task, and cannot effectively delegate specialized work. The author emphasizes that "moving from demos to production AI systems" requires architectural improvements beyond simple function calls.

### DeepAgents' Four Critical Capabilities

1. **Planning Tools** - Enable agents to break down tasks strategically before execution
2. **File System Access** - Provide persistent memory outside conversation context
3. **Sub-Agent Creation** - Allow delegation to focused specialists
4. **Long-Term Memory** - Maintain state across sessions via LangGraph's Store

### The Policy Research Agent Architecture

The implementation demonstrates a three-layer system:

- **Orchestration Layer** - Main agent coordinates workflow
- **Specialization Layer** - Research and critique sub-agents handle focused tasks
- **Infrastructure Layer** - File system, LangGraph Store, and Tavily API

## Complete Implementation

### Step 1: Dependencies

```python
!pip install deepagents tavily-python langchain-google-genai langchain-openai
```

### Step 2: Configuration

```python
import os
from getpass import getpass

os.environ['TAVILY_API_KEY'] = getpass('Enter Tavily API Key: ')
os.environ['OPENAI_API_KEY'] = getpass('Enter OpenAI API Key: ')
```

### Step 3: Web Search Tool

```python
from typing import Literal
from tavily import TavilyClient

tavily_client = TavilyClient()

def internet_search(
    query: str,
    max_results: int = 5,
    topic: Literal["general", "news", "finance"] = "general",
    include_raw_content: bool = False,
):
    """Run a web search and return relevant results."""
    search_docs = tavily_client.search(
        query,
        max_results=max_results,
        include_raw_content=include_raw_content,
        topic=topic,
    )
    return search_docs
```

### Step 4: Research Sub-Agent

```python
sub_research_prompt = """
You are a specialized AI policy researcher.
Conduct in-depth research on government policies, global regulations, and ethical
frameworks related to artificial intelligence.

Your answer should:
- Provide key updates and trends
- Include relevant sources and laws (e.g., EU AI Act, U.S. Executive Orders)
- Compare global approaches when relevant
- Be written in clear, professional language

Only your FINAL message will be passed back to the main agent.
"""

research_sub_agent = {
    "name": "policy-research-agent",
    "description": "Used to research specific AI policy and regulation questions.",
    "system_prompt": sub_research_prompt,
    "tools": [internet_search],
}
```

### Step 5: Critique Sub-Agent

```python
sub_critique_prompt = """
You are a policy editor reviewing a report on AI governance.
Check the report at `final_report.md` and the question at `question.txt`.

Focus on:
- Accuracy and completeness of legal information
- Proper citation of policy documents
- Balanced analysis of regional differences
- Clarity and neutrality of tone

Provide constructive feedback, but do NOT modify the report directly.
"""

critique_sub_agent = {
    "name": "policy-critique-agent",
    "description": "Critiques AI policy research reports for completeness and accuracy.",
    "system_prompt": sub_critique_prompt,
}
```

### Step 6: Main Agent System Prompt

```python
policy_research_instructions = """
You are an expert AI policy researcher and analyst.
Your job is to investigate questions related to global AI regulation, ethics,
and governance frameworks.

1. Save the user's question to `question.txt`
2. Use the `policy-research-agent` to perform in-depth research
3. Write a detailed report to `final_report.md`
4. Optionally, ask the `policy-critique-agent` to critique your draft
5. Revise if necessary, then output the final, comprehensive report

When writing the final report:
- Use Markdown with clear sections (## for each)
- Include citations in [Title](URL) format
- Add a ### Sources section at the end
- Write in professional, neutral tone suitable for policy briefings
"""
```

### Step 7: Initialize the Deep Agent

```python
from langchain.chat_models import init_chat_model
from deepagents import create_deep_agent

# Initialize with OpenAI GPT-4o
model = init_chat_model(model="openai:gpt-4o")

# Create the deep agent
agent = create_deep_agent(
    model=model,
    tools=[internet_search],
    system_prompt=policy_research_instructions,
    subagents=[research_sub_agent, critique_sub_agent],
)
```

### Step 8: Execution

```python
query = "What are the latest updates on the EU AI Act and its global impact?"

result = agent.invoke({"messages": [{"role": "user", "content": query}]})

# View results
final_message = result['messages'][-1]['content']
print(final_message)
```

## Execution Flow

The agent follows this workflow:

1. Saves the question to persistent storage
2. Delegates research to specialized sub-agent via web search
3. Synthesizes findings into structured Markdown report
4. Invokes critique sub-agent for quality review
5. Revises based on feedback
6. Outputs professional report with proper citations

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Agent Framework | LangChain DeepAgents |
| Primary LLM | OpenAI GPT-4o |
| Alternative LLM | Google Gemini 2.5 Flash |
| Web Search | Tavily API |
| State Management | LangGraph Store |
| File Operations | Built-in Tools |
| Planning | Built-in `write_todos` |

## Key Design Patterns

### Context Management

File-based persistence prevents token overflow: "This file-based approach means the agent can handle research projects of any size without hitting token limits."

### Strategic Planning

Explicit task decomposition transforms chaotic execution into methodical workflow through the `write_todos` tool.

### Specialization

Each sub-agent has a "single, well-defined output" and dedicated toolset, maintaining focus without context pollution.

## Advantages Over Basic Agents

- Handles tasks exceeding token limits
- Supports long-running projects across sessions
- Enables quality control through review cycles
- Scales to complex, multi-stage workflows
- Works with any LLM provider (model-agnostic)

## Practical Applications

The patterns apply beyond policy research:

- Content creation with editorial review
- Code generation with testing cycles
- Data analysis with iterative exploration
- Customer service with escalation
- Report generation with synthesis

## Key Takeaways

"Architecture matters more than model choice. A well-designed agent with GPT-3.5 will outperform a poorly designed agent with GPT-4."

The framework demonstrates that sophisticated AI systems require:
- Explicit planning before execution
- Persistent state management
- Clear task delegation
- Built-in quality control
- Modular, maintainable design

This represents the evolution from reactive tool-calling to proactive, strategic agent orchestration.
