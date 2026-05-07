---
title: "Building a Simple Chatbot with LangGraph and Chainlit: A Step-by-Step Tutorial"
url: "https://dev.to/jamesbmour/building-a-simple-chatbot-with-langgraph-and-chainlit-a-step-by-step-tutorial-4k6h"
author: "James"
category: "agent-ui-frameworks"
---

# Building a Simple Chatbot with LangGraph and Chainlit: A Step-by-Step Tutorial
**Author:** James
**Published:** August 12, 2025

## Overview
Tutorial creating an interactive chatbot using LangGraph for graph-based workflow management and Chainlit for the chat UI, with OpenRouter API integration.

## Key Concepts

### Graph Definition
```python
from langgraph.graph import START, MessagesState, StateGraph
from langgraph.checkpoint.memory import MemorySaver

workflow = StateGraph(state_schema=MessagesState)
model = ChatOpenAI(model='google/gemini-2.5-flash-lite', temperature=0)

def call_model(state: MessagesState):
    response = model.invoke(state['messages'])
    return {'messages': response}

workflow.add_node('model', call_model)
workflow.add_edge(START, 'model')
memory = MemorySaver()
app = workflow.compile(checkpointer=memory)
```

### Chainlit Integration
```python
@cl.on_message
async def main(message: cl.Message):
    answer = cl.Message(content='')
    await answer.send()
    config = {'configurable': {'thread_id': cl.context.session.thread_id}}
    for msg, _ in app.stream(
        {'messages': [HumanMessage(content=message.content)]},
        config, stream_mode='messages',
    ):
        if isinstance(msg, AIMessageChunk):
            answer.content += msg.content
            await answer.update()
```

Run with: `chainlit run chatbot.py`
