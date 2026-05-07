---
title: "Advanced LangGraph: Implementing Conditional Edges and Tool-Calling Agents"
url: "https://dev.to/jamesli/advanced-langgraph-implementing-conditional-edges-and-tool-calling-agents-3pdn"
author: "James Lee"
category: "langgraph-agents"
---

# Advanced LangGraph: Implementing Conditional Edges and Tool-Calling Agents

**Author:** James Lee
**Published:** November 14, 2024

## Overview

This article explores advanced LangGraph features, specifically conditional edges and tool-calling agent implementation. The author explains how to build sophisticated AI workflows with dynamic routing capabilities.

## Advanced Usage of Conditional Edges

### Multi-condition Routing

The article demonstrates creating a state-based routing system using `Literal` type hints:

```python
from typing import List, Dict, Literal
from pydantic import BaseModel
from langgraph.graph import StateGraph, END

class AgentState(BaseModel):
    messages: List[Dict[str, str]] = []
    current_input: str = ""
    tools_output: Dict[str, str] = {}
    status: str = "RUNNING"
    error_count: int = 0

def route_by_status(state: AgentState) -> Literal["process", "retry", "error", "end"]:
    """Complex routing logic"""
    if state.status == "SUCCESS":
        return "end"
    elif state.status == "ERROR":
        if state.error_count >= 3:
            return "error"
        return "retry"
    elif state.status == "NEED_TOOL":
        return "process"
    return "process"
```

### Parallel Execution

The framework supports concurrent tool execution through async operations:

```python
async def parallel_tools_execution(state: AgentState) -> AgentState:
    """Parallel execution of multiple tools"""
    tools = identify_required_tools(state.current_input)

    async def execute_tool(tool):
        result = await tool.ainvoke(state.current_input)
        return {tool.name: result}

    results = await asyncio.gather(*[execute_tool(tool) for tool in tools])

    tools_output = {}
    for result in results:
        tools_output.update(result)

    return AgentState(
        messages=state.messages,
        current_input=state.current_input,
        tools_output=tools_output,
        status="SUCCESS"
    )
```

## Complete Tool-Calling Agent Implementation

### State and Tools Definition

```python
from typing import List, Dict, Optional
from pydantic import BaseModel
from langchain.tools import BaseTool
from langchain.tools.calculator import CalculatorTool
from langchain.tools.wikipedia import WikipediaQueryRun
from langchain_core.language_models import ChatOpenAI

class Tool(BaseModel):
    name: str
    description: str
    func: callable

class AgentState(BaseModel):
    messages: List[Dict[str, str]] = []
    current_input: str = ""
    thought: str = ""
    selected_tool: Optional[str] = None
    tool_input: str = ""
    tool_output: str = ""
    final_answer: str = ""
    status: str = "STARTING"

tools = [
    Tool(
        name="calculator",
        description="Used for performing mathematical calculations",
        func=CalculatorTool()
    ),
    Tool(
        name="wikipedia",
        description="Used for querying Wikipedia information",
        func=WikipediaQueryRun()
    )
]
```

### Core Nodes Implementation

**Thinking Node:**

```python
async def think(state: AgentState) -> AgentState:
    """Think about the next action"""
    prompt = f"""
    Based on user input and current conversation history, think about the next action.
    User input: {state.current_input}
    Available tools: {[t.name + ': ' + t.description for t in tools]}
    Decide:
    1. Whether a tool is needed
    2. If needed, which tool to use
    3. What parameters to call the tool with
    Return in JSON format: {{"thought": "...", "need_tool": true/false, "tool": "...", "tool_input": "..."}}
    """
    llm = ChatOpenAI(temperature=0)
    response = await llm.ainvoke(prompt)
    result = json.loads(response)
    return AgentState(
        **state.dict(),
        thought=result["thought"],
        selected_tool=result.get("tool"),
        tool_input=result.get("tool_input"),
        status="NEED_TOOL" if result["need_tool"] else "GENERATE_RESPONSE"
    )
```

**Tool Execution Node:**

```python
async def execute_tool(state: AgentState) -> AgentState:
    """Execute tool call"""
    tool = next((t for t in tools if t.name == state.selected_tool), None)
    if not tool:
        return AgentState(
            **state.dict(),
            status="ERROR",
            thought="Selected tool not found"
        )
    try:
        result = await tool.func.ainvoke(state.tool_input)
        return AgentState(
            **state.dict(),
            tool_output=str(result),
            status="GENERATE_RESPONSE"
        )
    except Exception as e:
        return AgentState(
            **state.dict(),
            status="ERROR",
            thought=f"Tool execution failed: {str(e)}"
        )
```

**Response Generation Node:**

```python
async def generate_response(state: AgentState) -> AgentState:
    """Generate the final response"""
    prompt = f"""
    Generate a response to the user based on the following information:
    User input: {state.current_input}
    Thought process: {state.thought}
    Tool output: {state.tool_output}
    Please generate a clear and helpful response.
    """
    llm = ChatOpenAI(temperature=0.7)
    response = await llm.ainvoke(prompt)
    return AgentState(
        **state.dict(),
        final_answer=response,
        status="SUCCESS"
    )
```

### Graph Assembly

```python
workflow = StateGraph(AgentState)

workflow.add_node("think", think)
workflow.add_node("execute_tool", execute_tool)
workflow.add_node("generate_response", generate_response)

workflow.add_edge("think", "execute_tool", condition=lambda s: s.status == "NEED_TOOL")
workflow.add_edge("execute_tool", "generate_response", condition=lambda s: s.status == "GENERATE_RESPONSE")
workflow.add_edge("generate_response", "think", condition=lambda s: s.status == "SUCCESS")
```

## Key Takeaways

- **Conditional edges** enable dynamic workflow routing based on state evaluation
- **Parallel execution** leverages async operations for concurrent tool calls
- **Tool-calling agents** combine reasoning, tool selection, execution, and response generation
- LangGraph provides abstractions that simplify building complex, multi-step AI systems
- The framework supports extensibility for custom tools and logic flows
