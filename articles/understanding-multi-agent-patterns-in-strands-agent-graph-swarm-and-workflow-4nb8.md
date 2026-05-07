---
title: "Understanding Multi-Agent Patterns in Strands Agent: Graph, Swarm, and Workflow"
url: "https://dev.to/aws-builders/understanding-multi-agent-patterns-in-strands-agent-graph-swarm-and-workflow-4nb8"
author: "Hung____"
category: "swarm-orchestration"
---
# Understanding Multi-Agent Patterns in Strands Agent: Graph, Swarm, and Workflow
**Author:** Hung____  **Published:** November 21, 2025

## Overview
The Strands Agent framework provides three distinct orchestration patterns suited to different use cases, using AWS Bedrock and Amazon Nova.

## Key Concepts

### Pattern Comparison
| Pattern | Execution Flow | Best For |
|---------|---|---|
| Graph | LLM decides routing | Conditional branching |
| Swarm | Agents hand off autonomously | Collaborative problem-solving |
| Workflow | Pre-defined DAG | Repeatable processes |

### Pattern 1: Graph — Pizza Ordering System
```python
from strands import Agent, Graph
from strands.models import BedrockModel

nova_model = BedrockModel(model_id="amazon.nova-pro-v1:0", region_name="us-east-1")

graph = Graph()
graph.add_agent("order_taker", order_taker)
graph.add_agent("simple_processor", simple_processor)
graph.add_agent("custom_processor", custom_processor)
graph.add_edge("order_taker", "simple_processor")
graph.add_edge("order_taker", "custom_processor")

result = graph("I want a large pepperoni pizza")
```

### Pattern 2: Swarm — Blog Post Creation
```python
from strands import Agent, Swarm

swarm = Swarm()
swarm.add_agent("researcher", researcher)
swarm.add_agent("writer", writer)
swarm.add_agent("editor", editor)
swarm.set_entry_agent("researcher")

result = swarm("Create a blog post about AI multi-agent systems")
```

### Pattern 3: Workflow — Email Campaign Pipeline
```python
from strands import Agent, Workflow

workflow = Workflow()
workflow.add_task("load", load_agent)
workflow.add_task("segment", segment_agent)
workflow.add_task("vip_email", vip_email_agent)
workflow.add_task("regular_email", regular_email_agent)
workflow.add_task("schedule", schedule_agent)
workflow.add_dependency("segment", "load")
workflow.add_dependency("vip_email", "segment")
workflow.add_dependency("regular_email", "segment")
workflow.add_dependency("schedule", "vip_email")
workflow.add_dependency("schedule", "regular_email")

result = workflow("Create personalized email campaign")
```

### Shared State via invocation_state
```python
shared_state = {"user_id": "user123", "session_id": "sess456", "debug_mode": True}

result = graph("Analyze customer data", invocation_state=shared_state)
result = swarm("Create customer report", invocation_state=shared_state)
```

```python
@tool(context=True)
def query_customer_data(query: str, tool_context: ToolContext) -> str:
    user_id = tool_context.invocation_state.get("user_id")
    db_conn = tool_context.invocation_state.get("database_connection")
    results = db_conn.execute(query, user_id=user_id)
    return results
```

### Key Takeaways
1. Graph = Structured routing with AI-driven decisions
2. Swarm = Autonomous collaboration between specialists
3. Workflow = Fixed dependencies with parallel execution
