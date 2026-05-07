---
title: "Building Swarm-based agents with AG2"
url: "https://dev.to/ag2ai/building-swarm-based-agents-with-ag2-aj8"
author: "Yiran Wu, Mark Sze"
category: "agent-sdks"
---

# Building Swarm-based agents with AG2
**Author:** Yiran Wu, Mark Sze
**Published:** December 18, 2024

## Overview
Implementation of OpenAI's Swarm framework in AG2 for multi-agent orchestration with handoffs, context variables, and human-in-the-loop support.

## Key Concepts

### Swarm Orchestration with Handoffs
```python
from autogen import initiate_swarm_chat, SwarmAgent, ON_CONDITION, AFTER_WORK

customer_service.register_hand_off(
    hand_to=[
        ON_CONDITION(refund_specialist, "After verification, transfer"),
        AFTER_WORK(AfterWorkOption.REVERT_TO_USER)
    ]
)

chat_result, context_variables, last_speaker = initiate_swarm_chat(
    initial_agent=customer_service,
    agents=[customer_service, refund_specialist, payment_processor],
    user_agent=user,
    messages="Customer requesting refund"
)
```

- Hand-offs: Agents transfer control to other agents smoothly
- Context Variables: Shared memory updated via function calls
- Human-in-the-Loop: UserProxyAgent allows swarm agents to revert back for clarification
