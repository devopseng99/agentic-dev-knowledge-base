---
title: "Building Swarm-based agents with AG2"
url: "https://dev.to/ag2ai/building-swarm-based-agents-with-ag2-aj8"
author: "AG2 Blogger (Yiran Wu, Mark Sze)"
category: "swarm-agent-openai"
---

# Building Swarm-based agents with AG2

**Author:** AG2 Blogger (Yiran Wu, Mark Sze)
**Published:** December 18, 2024

## Overview
AG2's implementation of OpenAI's Swarm orchestration pattern with additional features: simple tool/handoff registration, transitions beyond tool calls, and built-in human-in-the-loop via UserProxyAgent. Complete refund management system example.

## Key Concepts

### Handoff Registration

```python
responder.register_hand_off(
    hand_to=[
        ON_CONDITION(weather, "If you need weather data, hand off to Weather_Agent"),
        ON_CONDITION(travel_advisor, "If you have weather data, hand off to Travel_Advisor_Agent"),
        AFTER_WORK(AfterWorkOption.REVERT_TO_USER),
    ]
)
```

### Swarm-Level After Work

```python
history, context, last_agent = initiate_swarm_chat(
    initial_agent=responder,
    agents=my_list_of_swarm_agents,
    max_rounds=30,
    messages=messages,
    after_work=AFTER_WORK(AfterWorkOption.TERMINATE)
)
```

### Handoff Priority Order
1. Tool call returns a swarm agent
2. Pre-defined ON_CONDITION handoff (LLM-chosen)
3. Agent-level AFTER_WORK handoff
4. Swarm-level AFTER_WORK handoff

### Complete Refund Management System

```python
from autogen import initiate_swarm_chat, SwarmAgent, SwarmResult, ON_CONDITION, AFTER_WORK, AfterWorkOption
from autogen import UserProxyAgent

llm_config = {...}

context_variables = {
    "passport_number": "",
    "customer_verified": False,
    "refund_approved": False,
    "payment_processed": False
}

def verify_customer_identity(passport_number: str, context_variables: dict) -> str:
    context_variables["passport_number"] = passport_number
    context_variables["customer_verified"] = True
    return SwarmResult(values="Customer identity verified", context_variables=context_variables)

def approve_refund_and_transfer(context_variables: dict) -> str:
    context_variables["refund_approved"] = True
    return SwarmResult(values="Refund approved", context_variables=context_variables, agent=payment_processor)

def process_refund_payment(context_variables: dict) -> str:
    context_variables["payment_processed"] = True
    return SwarmResult(values="Payment processed successfully", context_variables=context_variables)

customer_service = SwarmAgent(
    name="CustomerServiceRep",
    system_message="""You are a customer service representative.
      First verify identity, then transfer to refund specialist.""",
    llm_config=llm_config,
    functions=[verify_customer_identity],
)

refund_specialist = SwarmAgent(
    name="RefundSpecialist",
    system_message="Review the case, approve the refund, then transfer to payment processor.",
    llm_config=llm_config,
    functions=[approve_refund_and_transfer],
)

payment_processor = SwarmAgent(
    name="PaymentProcessor",
    system_message="Process the refund payment and provide confirmation.",
    llm_config=llm_config,
    functions=[process_refund_payment],
)

satisfaction_surveyor = SwarmAgent(
    name="SatisfactionSurveyor",
    system_message="Ask customer to rate their experience.",
    llm_config=llm_config,
)

customer_service.register_hand_off(
    hand_to=[
        ON_CONDITION(refund_specialist, "After verification, transfer to refund specialist"),
        AFTER_WORK(AfterWorkOption.REVERT_TO_USER)
    ]
)

payment_processor.register_hand_off(
    hand_to=[AFTER_WORK(satisfaction_surveyor)]
)

user = UserProxyAgent(name="User", code_execution_config=False)

chat_result, context_variables, last_speaker = initiate_swarm_chat(
    initial_agent=customer_service,
    agents=[customer_service, refund_specialist, payment_processor, satisfaction_surveyor],
    user_agent=user,
    messages="Customer requesting refund for order #12345",
    context_variables=context_variables,
    after_work=AFTER_WORK(AfterWorkOption.TERMINATE)
)
```
