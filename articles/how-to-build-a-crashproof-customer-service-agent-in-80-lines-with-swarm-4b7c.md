---
title: "How to build a crashproof customer service agent in <80 lines with Swarm"
url: "https://dev.to/dbos/how-to-build-a-crashproof-customer-service-agent-in-80-lines-with-swarm-4b7c"
author: "Qian Li"
category: "swarm-agent-openai"
---

# How to build a crashproof customer service agent in <80 lines with Swarm

**Author:** Qian Li
**Published:** October 22, 2024

## Overview
Building a fault-tolerant AI-powered customer service agent using OpenAI's Swarm framework with DBOS for durable execution. The agent handles refunds and discounts, and can resume from interrupted steps after crashes -- guaranteeing no duplicate refunds or discounts.

## Key Concepts

### Swarm Agent with DBOS Step Decorators

```python
from swarm import Agent
from dbos import DBOS

def process_refund(context_variables, item_id, reason="NOT SPECIFIED"):
    """Refund an item. Ask for user confirmation before processing."""
    user_name = context_variables.get("user_name", "user")
    print(f"[mock] Refunding for {user_name}, item {item_id}, because {reason}...")
    for i in range(1, 6):
        refund_step(i)
        DBOS.sleep(1)
    print("[mock] Refund successfully processed!")
    return "Success!"

@DBOS.step()
def refund_step(step_id):
    print(f"[mock] Processing refund step {step_id}... Press Control + C to quit")

@DBOS.step()
def apply_discount():
    """Apply a discount to the user's cart."""
    print("[mock] Applying discount...")
    return "Applied discount of 11%"

refunds_agent = Agent(
    name="Refunds Agent",
    instructions="Help the user with a refund. If too expensive, offer a refund code. If they insist, process the refund.",
    functions=[process_refund, apply_discount],
)
```

### DurableSwarm - Fault-Resilient Wrapper

```python
from dbos import DBOS, DBOSConfiguredInstance
from swarm import Swarm
from swarm.repl.repl import pretty_print_messages

DBOS()

@DBOS.dbos_class()
class DurableSwarm(Swarm, DBOSConfiguredInstance):
    def __init__(self, client=None):
        Swarm.__init__(self, client)
        DBOSConfiguredInstance.__init__(self, "openai_client")

    @DBOS.step()
    def get_chat_completion(self, *args, **kwargs):
        return super().get_chat_completion(*args, **kwargs)

    @DBOS.workflow()
    def run(self, *args, **kwargs):
        response = super().run(*args, **kwargs)
        pretty_print_messages(response.messages)
        return response

DBOS.launch()
```

### Main Application

```python
from agents import refunds_agent

def main():
    client = DurableSwarm()
    print("Connecting to Durable Refund Agent")
    user_name = input("What's your name: \n")
    if user_name.strip() == "":
        return

    query = "I want to refund item 99 because it's too expensive!"
    context_variables = {"user_name": user_name}
    client.run(
        agent=refunds_agent,
        messages=[{"role": "user", "content": query}],
        context_variables=context_variables,
    )

if __name__ == "__main__":
    main()
```

### Setup

```bash
git clone https://github.com/dbos-inc/durable-swarm.git
cd examples/reliable_refund
python3 -m venv .venv
source .venv/bin/activate
pip install dbos git+https://github.com/openai/swarm.git
export PGPASSWORD=dbos
python3 start_postgres_docker.py
python3 main.py
```

### Crash Recovery Behavior
After interruption at step 3, re-running resumes from step 4 -- no duplicate refunds.
