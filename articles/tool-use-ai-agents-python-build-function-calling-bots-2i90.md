---
title: "Tool Use AI Agents Python: Build Function-Calling Bots"
url: https://dev.to/iniyarajan86/tool-use-ai-agents-python-build-function-calling-bots-2i90
author: Iniyarajan
category: function-calling
---

# Tool Use AI Agents Python: Build Function-Calling Bots

**Author:** Iniyarajan
**Published:** March 25, 2026

---

## Overview

This article explores building intelligent AI agents in Python that can dynamically select and execute functions based on user requests. The author challenges the misconception that AI agents are merely chatbots, positioning them instead as sophisticated systems capable of executing functions, manipulating databases, and managing complex multi-step workflows.

---

## Key Concepts

### Understanding Tool Use in AI Agents

The core principle involves "function calling" where modern language models analyze requests, determine necessary functions, extract parameters, and structure responses appropriately. The system flow includes:

1. User request submission
2. Agent reasoning and tool selection
3. Tool execution (APIs, databases, file systems)
4. Response processing and delivery

### Python Frameworks

**LangChain** emerges as the preferred choice for its extensive ecosystem and pre-built tools. Alternatives include LlamaIndex for RAG-based agents, CrewAI, and AutoGen for multi-agent systems.

---

## Code Examples

### Basic Function-Calling Agent

```python
from langchain.agents import create_openai_tools_agent, AgentExecutor
from langchain_openai import ChatOpenAI
from langchain.tools import Tool
from langchain_core.prompts import ChatPromptTemplate

# Define custom tools
def search_web(query: str) -> str:
    """Search the web for information about a query."""
    try:
        return f"Search results for '{query}': [Relevant information would be returned here]"
    except Exception as e:
        return f"Search failed: {str(e)}"

def calculate_math(expression: str) -> str:
    """Safely evaluate mathematical expressions."""
    try:
        result = eval(expression.replace('^', '**'))
        return f"Result: {result}"
    except Exception as e:
        return f"Calculation error: {str(e)}"

def write_file(filename: str, content: str) -> str:
    """Write content to a file in the current directory."""
    try:
        with open(filename, 'w') as f:
            f.write(content)
        return f"Successfully wrote to {filename}"
    except Exception as e:
        return f"File write error: {str(e)}"

# Create tools list
tools = [
    Tool(
        name="web_search",
        func=search_web,
        description="Search the web for current information about any topic"
    ),
    Tool(
        name="calculator",
        func=calculate_math,
        description="Perform mathematical calculations. Use standard math notation."
    ),
    Tool(
        name="file_writer",
        func=write_file,
        description="Write text content to a file."
    )
]

# Initialize the language model
llm = ChatOpenAI(model="gpt-4-turbo", temperature=0)

# Create the agent prompt
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant with access to tools."),
    ("user", "{input}"),
    ("placeholder", "{agent_scratchpad}")
])

# Create and configure the agent
agent = create_openai_tools_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

# Example usage
response = agent_executor.invoke({
    "input": "Calculate 15 * 23 + 87, then write the result to a file"
})
```

### Advanced Tool Orchestration

```python
from langchain.schema import AgentAction
from typing import List, Dict, Any
import asyncio
from datetime import datetime

class ResearchAgent:
    def __init__(self, llm, tools):
        self.llm = llm
        self.tools = {tool.name: tool for tool in tools}
        self.memory = []

    async def execute_research_workflow(self, topic: str) -> Dict[str, Any]:
        """Execute a multi-step research workflow with tool orchestration."""
        workflow_steps = [
            self._gather_information,
            self._analyze_data,
            self._generate_summary,
            self._create_report
        ]

        context = {"topic": topic, "findings": [], "analysis": None}

        for step in workflow_steps:
            context = await step(context)
            self.memory.append({"step": step.__name__, "context": context.copy()})

        return context

    async def _gather_information(self, context: Dict) -> Dict:
        """Use search tools to gather information."""
        search_results = self.tools["web_search"].func(context["topic"])
        context["findings"].append(search_results)
        return context

    async def _analyze_data(self, context: Dict) -> Dict:
        """Process gathered information."""
        analysis_prompt = f"Analyze findings about {context['topic']}: {context['findings']}"
        analysis = await self.llm.ainvoke([{"role": "user", "content": analysis_prompt}])
        context["analysis"] = analysis.content
        return context

    async def _generate_summary(self, context: Dict) -> Dict:
        """Create a structured summary."""
        summary_prompt = f"Create summary based on: {context['analysis']}"
        summary = await self.llm.ainvoke([{"role": "user", "content": summary_prompt}])
        context["summary"] = summary.content
        return context

    async def _create_report(self, context: Dict) -> Dict:
        """Generate final report and save to file."""
        report_content = f"""
# Research Report: {context['topic']}

## Summary
{context['summary']}

## Analysis
{context['analysis']}

## Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
"""
        filename = f"research_report_{context['topic'].replace(' ', '_')}.md"
        self.tools["file_writer"].func(filename, report_content)
        context["report_file"] = filename
        return context
```

### Memory-Enhanced Agent

```python
from langchain.memory import ConversationBufferWindowMemory
from langchain.schema import BaseMessage
import json

class MemoryEnhancedAgent:
    def __init__(self, llm, tools, memory_window=10):
        self.llm = llm
        self.tools = tools
        self.memory = ConversationBufferWindowMemory(
            k=memory_window,
            return_messages=True
        )
        self.tool_usage_history = []

    def execute_with_memory(self, user_input: str):
        """Execute agent with persistent memory of tool usage."""
        history = self.memory.chat_memory.messages
        context_prompt = self._build_context_prompt(user_input, history)
        result = self._execute_agent_step(context_prompt)

        self.memory.chat_memory.add_user_message(user_input)
        self.memory.chat_memory.add_ai_message(result["output"])

        return result

    def _build_context_prompt(self, user_input: str, history: List[BaseMessage]):
        """Build context-aware prompt with tool usage history."""
        recent_tools = self._get_recent_tool_usage()

        context = f"""
You are an AI assistant with access to tools. Here's recent context:

Recent Tool Usage:
{json.dumps(recent_tools, indent=2)}

Current Request: {user_input}

Use this context to provide informed responses.
"""
        return context

    def _get_recent_tool_usage(self, limit=5):
        """Get recent tool usage for context."""
        return self.tool_usage_history[-limit:] if self.tool_usage_history else []
```

---

## Production Deployment Considerations

- **Security:** Implement sandboxing and avoid arbitrary code execution
- **Rate Limiting:** Control API call frequency and costs
- **Monitoring:** Track tool usage patterns and performance metrics
- **Error Recovery:** Build graceful degradation when tools fail
- **Containerization:** Use Docker for consistent deployment environments

---

## FAQ Highlights

**Cost Management:** Implement rate limiting, caching for repeated queries, and budget systems for tool costs.

**Error Handling:** Use retry strategies with exponential backoff, alternative tool fallbacks, and graceful user communication.

**Testing:** Create mock tools for unit tests, use integration tests in staging, and implement comprehensive logging.

**Function Calling vs. Text:** Function calling provides superior reliability, type safety, and parameter validation compared to text-based approaches.

---

## Key Takeaway

"Modern AI agents aren't just chatbots -- they're sophisticated systems executing functions, manipulating databases, and managing complex workflows through structured tool use patterns in Python."
