---
title: "Pydantic AI Tutorial: How I Build Type-Safe AI Agents That Actually Work in Production"
url: https://dev.to/jahanzaibai/pydantic-ai-tutorial-how-i-build-type-safe-ai-agents-that-actually-work-in-production-3bcp
author: Jahanzaib
category: pydantic-ai
---

# Pydantic AI Tutorial: Type-Safe AI Agents in Production

**Author:** Jahanzaib
**Published:** April 6, 2026
**Tags:** #pydanticai #python #aiagents #awsbedrock

---

## Overview

This comprehensive guide covers building production-ready AI agents using Pydantic AI, a Python framework emphasizing type safety and validated outputs. The author shares real-world deployment patterns across 14+ client systems.

## Key Takeaways

- **Type-safe outputs**: Agent responses are validated Pydantic models, not unparseable strings
- **Dependency injection**: Pass database connections and API clients cleanly via `Deps` dataclass
- **Tool decorators**: `@agent.tool` handles automatic argument validation before execution
- **Native async support**: `agent.run()` is async-first for concurrent request handling
- **AWS Bedrock integration**: Works via `BedrockConverseModel` (with streaming limitation noted)
- **Framework positioning**: Use Pydantic AI for single agents; add LangGraph for complex orchestration

---

## Core Concepts & Code Examples

### Installation

```bash
pip install pydantic-ai
pip install "pydantic-ai[bedrock]"
```

### Minimal Agent

```python
from pydantic_ai import Agent

agent = Agent(
    'anthropic:claude-haiku-4-5-20251001',
    instructions='You are a concise assistant. Answer in 2 sentences max.'
)

result = agent.run_sync('What is dependency injection?')
print(result.data)
```

### Structured Output with Validation

```python
from pydantic import BaseModel
from pydantic_ai import Agent

class CompetitorAnalysis(BaseModel):
    company_name: str
    main_strength: str
    main_weakness: str
    pricing_tier: str  # 'budget', 'mid', 'enterprise'
    verdict: str

agent = Agent(
    'anthropic:claude-haiku-4-5-20251001',
    result_type=CompetitorAnalysis,
    instructions='Analyze the company described. Be specific and honest.'
)

result = agent.run_sync(
    'Analyze Zapier as a competitor to a custom n8n deployment for enterprise clients.'
)

analysis = result.data  # type: CompetitorAnalysis
print(analysis.pricing_tier)
```

### Dependency Injection Pattern

```python
import asyncio
from dataclasses import dataclass
from pydantic_ai import Agent, RunContext

@dataclass
class Deps:
    user_id: str
    db_client: object
    api_key: str

agent = Agent(
    'anthropic:claude-haiku-4-5-20251001',
    deps_type=Deps,
    instructions='Help users look up their account information.'
)

@agent.tool
async def get_account_balance(ctx: RunContext[Deps], account_type: str) -> dict:
    """Get the account balance for a specific account type."""
    balance = await ctx.deps.db_client.query(
        'SELECT balance FROM accounts WHERE user_id = ? AND type = ?',
        ctx.deps.user_id,
        account_type
    )
    return {'balance': balance, 'currency': 'USD'}

async def main():
    deps = Deps(
        user_id='usr_abc123',
        db_client=your_db_client,
        api_key='sk-...'
    )
    result = await agent.run(
        'What is my checking account balance?',
        deps=deps
    )
    print(result.data)
```

### Tool Definition with Validation

```python
@agent.tool
async def search_knowledge_base(
    ctx: RunContext[Deps],
    query: str,
    max_results: int = 5,
    category: str | None = None
) -> list[dict]:
    """
    Search the internal knowledge base for relevant articles.

    Args:
        query: The search query string
        max_results: Maximum number of results to return (1-20)
        category: Optional category filter ('support', 'billing', 'technical')
    """
    results = await ctx.deps.search_client.query(
        query,
        limit=min(max_results, 20),
        category=category
    )
    return [{'title': r.title, 'excerpt': r.excerpt, 'url': r.url} for r in results]
```

### Error Handling with ModelRetry

```python
from pydantic_ai import ModelRetry

@agent.tool
async def get_weather(ctx: RunContext[Deps], city: str) -> dict:
    """Get current weather for a city."""
    try:
        data = await ctx.deps.weather_api.current(city)
        return {'temp_c': data.temperature, 'conditions': data.conditions}
    except CityNotFoundError:
        raise ModelRetry(f"City '{city}' not found. Try a more specific name.")
    except RateLimitError:
        raise ValueError("Weather API rate limit reached.")
```

### Concurrent Agent Processing

```python
import asyncio

async def process_leads(lead_ids: list[str], deps: CRMDeps) -> list[FollowUpDraft]:
    """Process multiple leads concurrently."""
    tasks = [
        crm_agent.run(
            f'Generate a follow-up for lead {lead_id}',
            deps=deps
        )
        for lead_id in lead_ids
    ]

    results = await asyncio.gather(*tasks, return_exceptions=True)

    drafts = []
    for lead_id, result in zip(lead_ids, results):
        if isinstance(result, Exception):
            print(f"Lead {lead_id} failed: {result}")
            continue
        drafts.append(result.data)

    return drafts
```

### Multi-Turn Conversations

```python
async def chat_session(agent: Agent, deps: Deps):
    messages = []

    while True:
        user_input = input("You: ")
        if user_input.lower() == 'quit':
            break

        result = await agent.run(
            user_input,
            message_history=messages,
            deps=deps
        )

        messages = result.all_messages()
        print(f"Agent: {result.data}")
```

### AWS Bedrock Integration

```python
from pydantic_ai import Agent
from pydantic_ai.models.bedrock import BedrockConverseModel
from pydantic_ai.providers.bedrock import BedrockProvider

# String shorthand
agent = Agent('bedrock:anthropic.claude-haiku-4-5-20251001')

# Explicit configuration with region
model = BedrockConverseModel(
    'anthropic.claude-haiku-4-5-20251001',
    provider=BedrockProvider(region_name='us-east-1')
)
agent = Agent(model, instructions='...')
```

### Testing with FunctionModel

```python
from pydantic_ai.models.function import FunctionModel, ModelContext
from pydantic_ai.messages import ModelResponse, TextPart, ToolCallPart
import json

def mock_model(messages: list, info: ModelContext) -> ModelResponse:
    """Return a mock response that calls the search tool."""
    return ModelResponse(parts=[
        ToolCallPart(
            tool_name='search_knowledge_base',
            args=json.dumps({'query': 'refund policy', 'max_results': 3})
        )
    ])

def test_support_agent_calls_search():
    test_agent = support_agent.override(model=FunctionModel(mock_model))

    deps = SupportDeps(
        search_client=MockSearchClient(),
        user_id='test_user'
    )

    result = test_agent.run_sync('What is your refund policy?', deps=deps)

    assert result.data is not None
    assert isinstance(result.data, SupportResponse)
```

### Tracking Token Usage

```python
result = await agent.run(user_message, deps=deps)
usage = result.usage()
print(f"Requests: {usage.requests}, Input tokens: {usage.input_tokens}")
```

---

## Pydantic AI vs LangGraph Comparison

| Need | Pydantic AI | LangGraph |
|------|-------------|-----------|
| Single agent with tools | Yes | Overkill |
| Structured validated output | Yes, native | Needs extra wiring |
| Dependency injection | First-class | Via LangChain context |
| Complex branching logic | Gets messy | Yes, core strength |
| Checkpoint and resume | No | Yes (core feature) |
| Human-in-the-loop approval | Basic support | Robust `interrupt_before` |
| Multi-agent orchestration | Use as node inside LangGraph | Yes |

---

## Real-World Deployment Patterns

### 1. Legal Document Classifier
- **Task**: Route inbound contracts by type, jurisdiction, and risk
- **Previous approach**: Keyword matching with 200 rules (67% accuracy)
- **Pydantic AI solution**: Structured `DocumentClassification` model
- **Result**: 94% accuracy, <2 seconds per document

### 2. E-Commerce Support Triage
- **Scale**: 800-1,200 tickets/day
- **Goal**: Auto-resolve standard order status inquiries
- **Result**: 38% auto-resolution rate, 96% satisfaction on auto-resolved tickets

### 3. CRM Lead Scoring
- **Use case**: Real estate agency lead pipeline automation
- **Output**: `LeadScore` object with numeric tier, reasoning, and actions

---

## Common Production Mistakes

1. **Using `run_sync()` in async contexts**: Blocks event loops; use `await agent.run()`
2. **Business logic in Pydantic validators**: Validators execute on every retry; move DB calls to tools
3. **Over-specifying system prompts**: Trust result type validation instead of 500-word rule docs
4. **No retry limits**: Set `retries=2` and handle `UnexpectedModelBehavior` explicitly

---

## Cost Optimization Strategies

**Retry loops**: Each validation failure costs tokens. Track `result.usage()` across real calls; averages >1.2 indicate schema or prompt issues.

**Tool descriptions**: Docstrings appear in every system prompt. Keep under 50 words per tool to avoid token bloat.

**Message history growth**: Conversations beyond 10 turns become expensive. Add summarization at 8-turn mark.

---

## Additional Resources

- [Official Pydantic AI docs](https://ai.pydantic.dev/)
- [GitHub repository](https://github.com/pydantic/pydantic-ai) (16,000+ stars as of April 2026)
