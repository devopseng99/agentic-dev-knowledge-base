---
title: "How to Build a Perplexity-like Chatbot in Slack"
url: "https://dev.to/composiodev/how-to-build-a-perplexity-like-chatbot-in-slack-533j"
author: "Sunil Kumar Dash"
category: "ai-agent-slack-bot"
---

# How to Build a Perplexity-like Chatbot in Slack

**Author:** Sunil Kumar Dash
**Published:** July 16, 2024

## Overview
Build an AI-powered Slack chatbot that searches the internet and provides researched responses with citations, similar to Perplexity AI. Uses Composio for tool integration, LlamaIndex for agent orchestration, and OpenAI GPT-4o for reasoning.

## Key Concepts

The system operates through: Slack message event -> Event listener triggers -> AI agent processes with web search tools (Exa, Tavily, Firecrawl) -> Response posted to thread.

## Code Examples

### Setup

```python
python -m venv slack-agent
cd slack-agent
source bin/activate
```

```bash
pip install composio-core composio-llamaindex
pip install llama-index-llms-openai python-dotenv
```

### Initialize Tools and Agent

```python
import os
from dotenv import load_dotenv
from composio_llamaindex import Action, App, ComposioToolSet
from composio.client.collections import TriggerEventData
from llama_index.core.agent import FunctionCallingAgentWorker
from llama_index.core.llms import ChatMessage
from llama_index.llms.openai import OpenAI

load_dotenv()

llm = OpenAI(model="gpt-4o")

BOT_USER_ID = os.environ["SLACK_BOT_ID"]
RESPOND_ONLY_IF_TAGGED = True

composio_toolset = ComposioToolSet()
composio_tools = composio_toolset.get_tools(
    apps=[App.CODEINTERPRETER, App.EXA, App.FIRECRAWL, App.TAVILY]
)
```

### Define Agent

```python
prefix_messages = [
    ChatMessage(
        role="system",
        content="You are an integration agent executing requests using available tools."
    )
]

agent = FunctionCallingAgentWorker(
    tools=composio_tools,
    llm=llm,
    prefix_messages=prefix_messages,
    max_function_calls=10,
    allow_parallel_tool_calls=False,
    verbose=True,
).as_agent()
```

### Event Listener and Message Handler

```python
listener = composio_toolset.create_trigger_listener()

@listener.callback(filters={"trigger_name": "slackbot_receive_message"})
def callback_new_message(event: TriggerEventData) -> None:
    payload = event.payload
    user_id = payload.get("event", {}).get("user", "")

    if user_id == BOT_USER_ID:
        return

    message = payload.get("event", {}).get("text", "")

    if RESPOND_ONLY_IF_TAGGED and f"<@{BOT_USER_ID}>" not in message:
        print("Bot not tagged, ignoring message")
        return

    channel_id = payload.get("event", {}).get("channel", "")
    ts = payload.get("event", {}).get("ts", "")
    thread_ts = payload.get("event", {}).get("thread_ts", ts)

    result = agent.chat(message)
    print(result)
    composio_toolset.execute_action(
        action=Action.SLACKBOT_CHAT_POST_MESSAGE,
        params={
            "channel": channel_id,
            "text": result.response,
            "thread_ts": thread_ts,
        },
    )

listener.listen()
```
