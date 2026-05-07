---
title: "pytest-aitest: Unit Tests Can't Test Your MCP Server. AI Can."
url: "https://dev.to/sbroenne/pytest-aitest-unit-tests-cant-test-your-mcp-server-ai-can-1ebn"
author: "Stefan Broenner"
category: "ai-agent-unit-testing"
---

# pytest-aitest: Unit Tests Can't Test Your MCP Server. AI Can.

**Author:** Stefan Broenner
**Published:** February 13, 2026

## Overview
A testing framework for MCP servers that validates whether LLMs can properly understand and use tool interfaces, using prompts as tests rather than code assertions.

## Key Concepts

### Code Example

```python
from pytest_aitest import Agent, Provider, MCPServer

async def test_balance_query(aitest_run):
    agent = Agent(
        provider=Provider(model="azure/gpt-5-mini"),
        mcp_servers=[MCPServer(command=["python", "-m", "my_banking_server"])],
    )
    result = await aitest_run(agent, "What's my checking balance?")
    assert result.success
    assert result.tool_was_called("get_balance")
```

### Red/Green/Refactor for AI
- **Red:** Tests fail when LLMs misunderstand tool descriptions
- **Green:** Developers improve descriptions and prompts
- **Refactor:** AI analysis identifies broader pattern issues

### Advanced Features
- Multi-model comparison with leaderboards ranked by pass rate and cost
- Multi-turn sessions preserving conversation context
- AI-powered failure analysis with recommendations
- 100+ provider support through LiteLLM

Note: Project archived; development continues in pytest-skill-engineering.
