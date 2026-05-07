---
title: "Implement a Traceable ReAct Agent Using Temporal and LangChain"
url: "https://dev.to/frederic_zhou/implement-a-traceable-react-agent-using-temporal-and-langchain-41il"
author: "Frederic Zhou"
category: "multi-cloud-durable"
---

# Implement a Traceable ReAct Agent Using Temporal and LangChain
**Author:** Frederic Zhou
**Published:** September 16, 2025

## Overview
Demonstrates integrating AI agents with Temporal workflows to make tool invocations fully observable. Unlike traditional approaches where agents call tools externally, this embeds tool calls within the workflow itself, creating complete execution traces visible in Temporal UI.

## Key Concepts

Agent workflow with embedded tool calls:

```python
@workflow.defn
class AiAgentWorkflow:
    @workflow.run
    async def run(self, query: str) -> str:
        messages = [HumanMessage(query)]
        MAX_STEPS = 8
        for _ in range(MAX_STEPS):
            ai_msg = await workflow.execute_activity(
                "llm_chat",
                messages,
                schedule_to_close_timeout=timedelta(seconds=60),
            )
            messages.append(AIMessage(**ai_msg))
            if ai_msg["tool_calls"]:
                for tool_call in ai_msg["tool_calls"]:
                    tool_call_result = await workflow.execute_activity(
                        tool_call["name"],
                        tool_call["args"]["params"],
                        schedule_to_close_timeout=timedelta(seconds=10),
                    )
                    messages.append(ToolMessage(
                        content=str(tool_call_result),
                        tool_call_id=tool_call["id"],
                    ))
            else:
                return messages[-1].content
```

Tools implemented as activities:

```python
@activity.defn
async def llm_chat(messages: list) -> str:
    llm = init_chat_model("gemini-2.0-flash", model_provider="google_genai")
    llm_with_tools = llm.bind_tools([add, division])
    response = llm_with_tools.invoke(messages)
    return response

@activity.defn
async def add(params: list[int]) -> int:
    return sum(params)
```

The Temporal UI displays every LLM reasoning step and tool call with input, output, duration, and status metrics.
