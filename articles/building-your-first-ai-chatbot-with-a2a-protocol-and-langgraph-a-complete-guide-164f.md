---
title: "Building Your First AI Chatbot with A2A Protocol and LangGraph: A Complete Guide"
url: "https://dev.to/sreeni5018/building-your-first-ai-chatbot-with-a2a-protocol-and-langgraph-a-complete-guide-164f"
author: "Seenivasa Ramadurai"
category: "building chatbot agent"
---

# Building Your First AI Chatbot with A2A Protocol and LangGraph: A Complete Guide

**Author:** Seenivasa Ramadurai
**Published:** February 8, 2026

## Overview

A comprehensive guide to creating an AI chatbot using LangGraph with the A2A (Agent-to-Agent) protocol, enabling different AI systems to discover and communicate with each other seamlessly.

## Key Concepts

### A2A Protocol Components

1. **Agent Card** - Published at `/.well-known/agent-card.json`, describes capabilities
2. **Message Exchange** - Bidirectional communication between client and agent
3. **Agent Executor** - Bridge between A2A protocol layer and business logic

### LangGraph Agent Definition

```python
from typing import Annotated
from langchain_core.messages import BaseMessage, HumanMessage
from langchain_openai import ChatOpenAI
from langgraph.graph import END, START, StateGraph
from langgraph.graph.message import add_messages
from typing_extensions import TypedDict


class ChatState(TypedDict):
    messages: Annotated[list[BaseMessage], add_messages]


def model_node(state: ChatState) -> dict:
    model = ChatOpenAI(model="gpt-4o-mini", temperature=0.7)
    response = model.invoke(state["messages"])
    return {"messages": [response]}


def build_chatbot_agent():
    builder = StateGraph(ChatState)
    builder.add_node("model", model_node)
    builder.add_edge(START, "model")
    builder.add_edge("model", END)
    return builder.compile()


chatbot_agent = build_chatbot_agent()
```

### A2A Agent Executor

```python
from a2a.server.agent_execution import AgentExecutor, RequestContext
from a2a.server.events import EventQueue
from a2a.utils import new_agent_text_message
from langchain_core.messages import HumanMessage
from agent import chatbot_agent


class ChatbotAgentExecutor(AgentExecutor):
    async def execute(self, context: RequestContext, event_queue: EventQueue) -> None:
        user_input = context.get_user_input()
        if not user_input.strip():
            await event_queue.enqueue_event(
                new_agent_text_message("Please send a non-empty message.")
            )
            return

        messages = [HumanMessage(content=user_input)]
        result = chatbot_agent.invoke({"messages": messages})
        last = result["messages"][-1]
        reply = last.content if hasattr(last, "content") else str(last)
        await event_queue.enqueue_event(new_agent_text_message(reply))

    async def cancel(self, context: RequestContext, event_queue: EventQueue) -> None:
        raise NotImplementedError("cancel not supported")
```

### A2A Server Setup

```python
import uvicorn
from a2a.server.apps import A2AStarletteApplication
from a2a.server.request_handlers import DefaultRequestHandler
from a2a.server.tasks import InMemoryTaskStore
from a2a.types import AgentCapabilities, AgentCard, AgentSkill
from agent_executor import ChatbotAgentExecutor

def main() -> None:
    skill = AgentSkill(
        id="chat",
        name="Chat",
        description="Chat with the LangGraph chatbot.",
        tags=["chat", "chatbot", "langgraph"],
        examples=["Hello", "What is the weather?", "Tell me a joke"],
    )

    agent_card = AgentCard(
        name="LangGraph Chatbot (A2A)",
        description="Simple chatbot powered by LangGraph and the A2A protocol.",
        url="http://localhost:9999/",
        version="0.1.0",
        default_input_modes=["text"],
        default_output_modes=["text"],
        capabilities=AgentCapabilities(streaming=True),
        skills=[skill],
    )

    request_handler = DefaultRequestHandler(
        agent_executor=ChatbotAgentExecutor(),
        task_store=InMemoryTaskStore(),
    )

    a2a_app = A2AStarletteApplication(
        agent_card=agent_card,
        http_handler=request_handler,
    )
    app = a2a_app.build()
    uvicorn.run(app, host="0.0.0.0", port=9999)

if __name__ == "__main__":
    main()
```

### A2A Client

```python
import asyncio
from uuid import uuid4
import httpx
from a2a.client import A2ACardResolver, A2AClient
from a2a.client.helpers import create_text_message_object
from a2a.types import MessageSendParams, SendMessageRequest

BASE_URL = "http://localhost:9999"

async def send_one(client: A2AClient, text: str) -> str:
    user_message = create_text_message_object(content=text)
    params = MessageSendParams(message=user_message)
    request = SendMessageRequest(id=str(uuid4()), params=params)
    response = await client.send_message(request)
    result = response.root.result
    if hasattr(result, "parts"):
        return extract_text_from_message(result)
    return str(result)

async def run_client():
    async with httpx.AsyncClient(timeout=60.0) as httpx_client:
        resolver = A2ACardResolver(httpx_client=httpx_client, base_url=BASE_URL)
        card = await resolver.get_agent_card()
        client = A2AClient(httpx_client=httpx_client, agent_card=card)

        print(f"Connected to {card.name} at {BASE_URL}")
        while True:
            user_input = input("You: ").strip()
            if user_input.lower() == "exit":
                break
            reply = await send_one(client, user_input)
            print(f"Agent: {reply}\n")

if __name__ == "__main__":
    asyncio.run(run_client())
```
