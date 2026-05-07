---
title: "Set Up Your Own AI Agent in Minutes! Clone, Run, & Deploy"
url: "https://dev.to/ramkumar-m-n/set-up-your-own-ai-agent-in-minutes-clone-run-deploy-2n92"
author: "Ramkumar M N"
category: "enterprise-clones"
---

# Set Up Your Own AI Agent in Minutes! Clone, Run, & Deploy
**Author:** Ramkumar M N
**Published:** March 3, 2025

## Overview
Explores building multiple AI agents using Fetch.ai's uAgents framework with inter-agent communication capabilities, integrating with the agentverse.ai marketplace. Demonstrates a master-slave agent architecture for decentralized coordination.

## Key Concepts

### Setup
```shell
python -m venv venv
source venv/bin/activate
pip install uagents
```

### Slave Agent 1 (slave-agent-1.py)
```python
from uagents import Agent

slave1 = Agent(name="SlaveAgent1", port=8001)

@slave1.on_message()
def handle_message(ctx, sender, msg):
    ctx.logger.info(f"[SlaveAgent1] Received message from {sender}: {msg}")
    
    with open("SlaveAgent1_address.txt", "w") as f:
        f.write(slave1.address)

if __name__ == "__main__":
    slave1.run()
```

### Slave Agent 2 (slave-agent-2.py)
```python
from uagents import Agent

slave2 = Agent(name="SlaveAgent2", port=8002)

@slave2.on_message()
def handle_message(ctx, sender, msg):
    ctx.logger.info(f"[SlaveAgent2] Received message from {sender}: {msg}")
    
    with open("SlaveAgent2_address.txt", "w") as f:
        f.write(slave2.address)

if __name__ == "__main__":
    slave2.run()
```

### Master Agent (master-agent.py)
```python
from uagents import Agent

master = Agent(name="MasterAgent", port=8003)

with open("SlaveAgent1_address.txt", "r") as f:
    slave1_address = f.read().strip()
with open("SlaveAgent2_address.txt", "r") as f:
    slave2_address = f.read().strip()

@master.on_event("start")
def send_messages(ctx):
    ctx.logger.info(f"[MasterAgent] Sending message to SlaveAgent1 ({slave1_address})")
    ctx.send(slave1_address, "Hello SlaveAgent1, this is MasterAgent!")
    ctx.logger.info(f"[MasterAgent] Sending message to SlaveAgent2 ({slave2_address})")
    ctx.send(slave2_address, "Hello SlaveAgent2, this is MasterAgent!")

if __name__ == "__main__":
    master.run()
```

### GitHub Repositories
- https://github.com/ramkumar-contactme/first-ai-agent

### Key Architecture
- Master-agent coordinates task distribution to multiple slave agents
- Fetch.ai's uAgents provides lightweight, event-driven agent implementation
- Integration with Agentverse marketplace for pre-built services
- Applications: Finance (fraud detection), healthcare (diagnostics), logistics
