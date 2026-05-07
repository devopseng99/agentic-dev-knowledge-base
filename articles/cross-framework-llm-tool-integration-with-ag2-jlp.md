---
title: "Cross-Framework LLM Tool Integration with AG2"
url: "https://dev.to/ag2ai/cross-framework-llm-tool-integration-with-ag2-jlp"
author: "Robert Jambrecic"
category: "agent-sdks"
---

# Cross-Framework LLM Tool Integration with AG2
**Author:** Robert Jambrecic
**Published:** December 30, 2024

## Overview
AG2 Interoperability module enabling integration of tools from LangChain, CrewAI, and PydanticAI into unified agent systems.

## Key Concepts

### LangChain Tool Integration
```python
from autogen.interop import Interoperability
interop = Interoperability()
ag2_tool = interop.convert_tool(tool=langchain_tool, type="langchain")
ag2_tool.register_for_execution(user_proxy)
ag2_tool.register_for_llm(chatbot)
```

### CrewAI Tool Integration
```python
crewai_tool = ScrapeWebsiteTool()
ag2_tool = interop.convert_tool(tool=crewai_tool, type="crewai")
```

### PydanticAI Tool Integration
```python
pydantic_ai_tool = PydanticAITool(get_player, takes_ctx=True)
ag2_tool = interop.convert_tool(tool=pydantic_ai_tool, type="pydanticai", deps=player)
```
