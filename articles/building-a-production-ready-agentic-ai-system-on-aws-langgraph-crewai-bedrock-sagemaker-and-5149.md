---
title: "Building a Production-Ready Agentic AI System on AWS (LangGraph, CrewAI, Bedrock, SageMaker, and EKS)"
url: "https://dev.to/aws-builders/building-a-production-ready-agentic-ai-system-on-aws-langgraph-crewai-bedrock-sagemaker-and-5149"
author: "Supratip Banerjee"
category: "aws-agents"
---

# Building a Production-Ready Agentic AI System on AWS
**Author:** Supratip Banerjee
**Published:** March 15, 2026

## Overview
Enterprise-grade agentic AI combining LangGraph for reasoning orchestration, CrewAI for agent collaboration, Bedrock for foundation models, and SageMaker for custom ML predictions on EKS.

## Key Concepts

### LangGraph State and Graph

```python
from typing import TypedDict, List
from langgraph.graph import StateGraph

class AgentState(TypedDict):
    user_query: str
    plan: str
    research_notes: List[str]
    risk_score: float
    final_answer: str

graph = StateGraph(AgentState)
graph.add_node("plan", planner.run)
graph.add_node("research", researcher.run)
graph.add_node("validate", validator.run)
graph.add_node("respond", responder.run)
graph.add_edge("plan", "research")
graph.add_edge("research", "validate")
graph.add_edge("validate", "respond")
graph.set_entry_point("plan")
agent_app = graph.compile()
```

### CrewAI Agent Definitions

```python
from crewai import Agent

planner = Agent(role="Planner", goal="Break query into actionable steps", backstory="Senior system architect")
researcher = Agent(role="Researcher", goal="Gather accurate information", backstory="Meticulous analyst")
validator = Agent(role="Validator", goal="Check correctness and compliance", backstory="Risk expert")
responder = Agent(role="Responder", goal="Produce clear final response", backstory="Technical communicator")
```

### Bedrock and SageMaker Integration

```python
bedrock = boto3.client("bedrock-runtime", region_name="us-east-1")

def bedrock_call(prompt: str) -> str:
    response = bedrock.invoke_model(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        body=json.dumps({"messages": [{"role": "user", "content": prompt}], "max_tokens": 600})
    )
    return json.loads(response["body"].read())["content"][0]["text"]

sagemaker = boto3.client("sagemaker-runtime")

def get_risk_score(features: dict) -> float:
    response = sagemaker.invoke_endpoint(
        EndpointName="risk-scoring-endpoint",
        ContentType="application/json", Body=json.dumps(features)
    )
    return json.loads(response["Body"].read())["risk_score"]
```
