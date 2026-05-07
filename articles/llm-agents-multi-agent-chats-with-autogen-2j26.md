---
title: "LLM Agents: Multi-Agent Chats with Autogen"
url: "https://dev.to/admantium/llm-agents-multi-agent-chats-with-autogen-2j26"
author: "Sebastian"
category: "multi-turn-conversation"
---

# LLM Agents: Multi-Agent Chats with Autogen

**Author:** Sebastian
**Published:** October 10, 2024

## Overview
Explores multi-agent conversations using the Autogen framework, covering agent types, communication patterns, and message flow structuring. Uses Ollama with LiteLLM for local LLM inference.

## Key Concepts

### Agent Types
**Stable Agents:**
- **ConversableAgent:** Default class with system prompts, human input controls, and conversation summarization
- **AssistantAgent:** ConversableAgent subclass with specific system prompts
- **UserProxy:** Represents human participants

**Contrib Agents:**
- RetrieveAssistantAgent/RetrieveUserProxyAgent (RAG)
- LlavaAgent (image processing)
- AgentEval, MathUserProxyAgent, SocietyOfMindAgent

### Communication Patterns
- Bilateral chat (two-way)
- Group chat with manager moderation

## Code Examples

### Basic Chat Setup
```python
from autogen.agentchat import ConversableAgent, UserProxyAgent

config_list = [
  {
    "model": "llama3",
    "base_url": "http://0.0.0.0:4000",
    "api_key": "ollama",
  }
]

SYSTEM_PROMPT = "You are a knowledgeable helpful assistant."

agent = ConversableAgent(
  name="agent",
  system_message=SYSTEM_PROMPT,
  human_input_mode="NEVER",
  llm_config={
    "config_list": config_list,
    "timeout": 180,
    "temperature": 0.2},
)

user = UserProxyAgent(
  name="supervisor",
  human_input_mode="ALWAYS",
  is_termination_msg=lambda x: x.get("content", "").strip().endswith("TERMINATE"),
)
```

### Chat Initialization
```python
chat = user.initiate_chat(
  agent,
  message="List 5 books about the history of humankind.",
  clear_history=False,
  is_termination_msg=lambda x: x.get("content", "").strip().endswith("TERMINATE"),
)
```

### Group Chat with Custom Speaker Selection
```python
groupchat = GroupChat(agents=[user, librarian, reviewer, editor], messages=[], max_round=6)
manager = GroupChatManager(groupchat=groupchat, llm_config={"config_list": config_list})

def next_speaker(last_speaker: AssistantAgent, groupchat: GroupChat):
    messages = groupchat.messages
    last = last_speaker.name
    nxt = None

    if len(messages) < 2:
        nxt = librarian

    match last:
        case "librarian":
            if len(messages) > 1:
                nxt = reviewer
            else:
                nxt = user
        case "reviewer":
            nxt = editor
        case "editor":
            nxt = librarian

    return nxt
```

### Installation
```bash
pip install autogen==0.2.27
```
