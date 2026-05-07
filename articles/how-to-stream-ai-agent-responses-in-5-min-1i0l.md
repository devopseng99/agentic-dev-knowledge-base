---
title: "Stop Waiting 30 Seconds: How to Stream AI Agent Output in Python"
url: "https://dev.to/thedailyagent/how-to-stream-ai-agent-responses-in-5-min-1i0l"
author: "The Daily Agent"
category: "streaming"
---

# Stop Waiting 30 Seconds: How to Stream AI Agent Output in Python

**Author:** The Daily Agent
**Date Published:** March 16, 2026
**Tags:** #ai #python #programming #tutorial

## Overview

This article addresses the poor user experience of blocking AI agent calls that pause for extended periods before dumping text output. The author demonstrates how to implement streaming responses using the OpenAI Agents SDK, delivering both text tokens and tool events in real time.

## Core Problem

"Your agent calls three tools, thinks for 20 seconds, then dumps a wall of text. The user stares at a blank screen the entire time."

Two critical issues emerge:
- **Perceived latency:** Long waits feel interminable to users
- **Timeout risk:** Extended runs trigger HTTP gateway timeouts (30-60 seconds)

## Solution: Basic Implementation

```python
import asyncio
from agents import Agent, Runner, function_tool
from openai.types.responses import ResponseTextDeltaEvent


@function_tool
def lookup_price(ticker: str) -> str:
    """Look up the current price of a stock."""
    prices = {"AAPL": "$198.50", "GOOG": "$176.30", "TSLA": "$245.10"}
    return prices.get(ticker.upper(), f"No data for {ticker}")


agent = Agent(
    name="StockAssistant",
    instructions="You help users check stock prices. Use the lookup_price tool.",
    tools=[lookup_price],
)


async def main():
    result = Runner.run_streamed(agent, input="What's the price of AAPL and GOOG?")

    async for event in result.stream_events():
        if event.type == "raw_response_event" and isinstance(event.data, ResponseTextDeltaEvent):
            print(event.data.delta, end="", flush=True)
        elif event.type == "run_item_stream_event":
            if event.item.type == "tool_call_item":
                print(f"\n>> Calling tool...")
            elif event.item.type == "tool_call_output_item":
                print(f">> Tool returned: {event.item.output}")
            elif event.item.type == "message_output_item":
                pass  # Already streaming via raw events above

    print()  # Final newline


if __name__ == "__main__":
    asyncio.run(main())
```

**Installation:**
```bash
pip install openai-agents
export OPENAI_API_KEY="sk-..."
python stream_agent.py
```

## Event Types

Three event categories drive streaming functionality:

- **`raw_response_event`:** Fires for each token generated, enabling token-by-token text output
- **`run_item_stream_event`:** Fires when complete items finish (tool calls, outputs, messages), providing structured milestones
- **`agent_updated_stream_event`:** Fires during agent handoffs in multi-agent setups

## Web Application Integration (FastAPI + SSE)

```python
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
from agents import Agent, Runner
from openai.types.responses import ResponseTextDeltaEvent

app = FastAPI()

agent = Agent(
    name="Assistant",
    instructions="You are a helpful assistant.",
)


@app.get("/stream")
async def stream_response(query: str):
    async def event_generator():
        result = Runner.run_streamed(agent, input=query)
        async for event in result.stream_events():
            if event.type == "raw_response_event" and isinstance(
                event.data, ResponseTextDeltaEvent
            ):
                yield f"data: {event.data.delta}\n\n"
            elif event.type == "run_item_stream_event":
                if event.item.type == "tool_call_item":
                    yield f"data: [TOOL_CALL]\n\n"
                elif event.item.type == "tool_call_output_item":
                    yield f"data: [TOOL_RESULT:{event.item.output}]\n\n"
        yield "data: [DONE]\n\n"

    return StreamingResponse(event_generator(), media_type="text/event-stream")
```

## Performance Comparison

| Metric | `Runner.run()` | `Runner.run_streamed()` |
|--------|---|---|
| Time to first visible output | 10-30s | 1-2s |
| Connection timeout risk | High | Low |
| User perception | "Is it broken?" | "It's working on it" |
| Implementation complexity | 1 line | ~10 extra lines |

## Key Takeaways

- Streaming reduces perceived latency from 10-30 seconds to 1-2 seconds for initial output
- `Runner.run_streamed()` replaces blocking calls, returning results immediately
- Token-level streaming combined with structured event handling creates superior user experiences
- Server-Sent Events enable seamless integration with web frontends
- Streaming maintains connection stability, avoiding gateway timeouts
