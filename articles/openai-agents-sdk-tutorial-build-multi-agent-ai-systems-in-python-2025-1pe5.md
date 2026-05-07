---
title: "OpenAI Agents SDK Tutorial: Build Multi-Agent AI Systems in Python (2025)"
url: https://dev.to/akhileshpothuri/openai-agents-sdk-tutorial-build-multi-agent-ai-systems-in-python-2025-1pe5
author: Akhilesh Pothuri
category: ai-agents-python
---

# OpenAI Agents SDK Tutorial: Build Multi-Agent AI Systems in Python (2025)

**Author:** Akhilesh Pothuri
**Published:** April 28, 2026

---

## Overview

This comprehensive guide addresses the limitations of single-prompt AI systems and introduces OpenAI's Agents SDK as a solution for building autonomous, multi-agent workflows. The article emphasizes moving beyond isolated chatbot interactions to create AI systems that can plan, coordinate, and execute complex tasks.

---

## Key Problems Addressed

The article identifies a critical gap in current AI development: "single prompts are incredible for isolated tasks, but the moment you need AI to plan, remember, and coordinate — to actually work like a capable assistant rather than a brilliant amnesiac — the cracks show fast."

Single-prompt limitations include:
- Inability to maintain context across multiple steps
- No autonomous decision-making capabilities
- Poor performance on multi-step workflows
- Lack of tool integration for real-world actions

---

## Core Concepts

### The Agent Loop
The foundational pattern consists of five repeating steps:
1. **Think** — Assess goals and available information
2. **Decide** — Determine next action and required tools
3. **Act** — Execute API calls or tool functions
4. **Observe** — Evaluate results
5. **Repeat** — Continue until task completion

### Building Blocks

**Agents**: LLM instances with defined roles, boundaries, and accessible resources. Think of them as specialized employees with specific job descriptions.

**Tools**: Python functions that enable agents to interact with external systems. Rather than merely describing capabilities, agents can execute them directly.

**Handoffs**: Transfer mechanisms between agents. A triage agent might route a customer service request to a billing specialist rather than attempting to handle all domains.

---

## Framework Comparison

| Use Case | Recommended | Rationale |
|----------|-------------|-----------|
| Simple tool-calling with OpenAI models | OpenAI Agents SDK | Minimal dependencies, native integration |
| Multi-provider support, complex RAG | LangGraph | Ecosystem flexibility, model agnostic |
| Multi-agent debate scenarios | AutoGen | Conversation orchestration capabilities |
| Rapid prototyping | LangChain | Abstract layer, pre-built integrations |
| Production systems (OpenAI commitment) | OpenAI Agents SDK | First-party support |

**Key distinction**: "LangChain's abstraction layer enables swapping models mid-project, while OpenAI's SDK prioritizes simplicity and direct integration."

---

## Production Requirements

### Guardrails
Input and output validation mechanisms preventing:
- Prompt injection attacks
- Off-topic requests
- Personally identifiable information exposure
- Unauthorized external actions

**Critical principle**: Never auto-send external communications (emails, API calls). Require human approval or secondary agent verification.

### Tracing & Observability
Comprehensive logging of:
- Every LLM API call
- Tool invocations
- Handoff decisions
- Structured export to monitoring platforms

### Cost Management
Essential patterns include:
- Aggressive caching of identical operations
- Model tiering (GPT-4o for reasoning, GPT-4o-mini for summarization)
- Hard loop limits via `max_turns` configuration

---

## Code Example: Email Triage System

### Basic Agent with Tools

```python
from agents import Agent, function_tool, Runner
import json

@function_tool
def fetch_emails(limit: int = 10) -> list[dict]:
    """Fetch unread emails from inbox."""
    return [{"id": "1", "from": "boss@company.com",
             "subject": "Q3 Report", "body": "..."}]

classifier = Agent(
    name="EmailClassifier",
    model="gpt-4o-mini",
    instructions="""Categorize emails as: URGENT, NEEDS_RESPONSE,
                   FYI, or SPAM. Return structured JSON with
                   email_id and category.""",
    tools=[fetch_emails],
    output_type={"email_id": str, "category": str}
)
```

### Multi-Agent Pipeline with Handoffs

```python
summarizer = Agent(
    name="Summarizer",
    model="gpt-4o-mini",
    instructions="Summarize emails marked URGENT or NEEDS_RESPONSE in 2 sentences max."
)

drafter = Agent(
    name="ResponseDrafter",
    model="gpt-4o",
    instructions="Draft professional responses. Match the sender's tone."
)

classifier.handoffs = [summarizer]
summarizer.handoffs = [drafter]
```

### Input Guardrails

```python
from agents import input_guardrail, GuardrailFunctionOutput

@input_guardrail
async def check_for_pii(ctx, agent, input_text):
    """Prevent processing emails with sensitive data markers."""
    sensitive_patterns = ["SSN:", "password:", "credit card:"]
    if any(pattern.lower() in input_text.lower()
           for pattern in sensitive_patterns):
        return GuardrailFunctionOutput(
            output_info={"reason": "Sensitive data detected"},
            tripwire_triggered=True
        )
    return GuardrailFunctionOutput(output_info={},
                                   tripwire_triggered=False)

drafter.input_guardrails = [check_for_pii]

async def main():
    result = await Runner.run(classifier, input="Process my inbox")
    print(result.final_output)
```

---

## When to Use Agents vs. Traditional Code

### Agent Use Cases
- Multi-step research workflows requiring iterative data gathering
- Customer service ticket routing and escalation
- Automated review processes with human checkpoints

### Avoid Agents When
- Simple single-prompt Q&A suffices
- Latency is critical (each loop adds 1-3 seconds)
- Perfect deterministic accuracy is required

**Design principle**: "Start with a single agent. Give it tools. Only split when you hit a clear wall—like needing fundamentally different models or system prompts for subtasks."

---

## Key Takeaways

1. **Structure over magic** — Guardrails, handoffs, and tracing distinguish production systems from prototypes

2. **Resist over-architecture** — Begin with one agent and only decompose when evidence justifies splitting

3. **Human-in-the-loop as feature** — Production systems benefit from knowing when to request guidance rather than proceeding autonomously

---

## Context

The article positions the OpenAI Agents SDK within broader industry trends, noting that frameworks like LangChain and CrewAI accumulated tens of thousands of GitHub stars before OpenAI released its solution. The SDK addresses genuine developer demand for "a production-ready, first-party solution that just works with OpenAI's models."
