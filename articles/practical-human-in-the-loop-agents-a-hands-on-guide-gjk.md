---
title: "Practical Human-in-the-Loop Agents: A Hands-On Guide"
url: "https://dev.to/shrsv/practical-human-in-the-loop-agents-a-hands-on-guide-gjk"
author: "Shrijith Venkatramana"
category: "agent-ui-frameworks"
---

# Practical Human-in-the-Loop Agents: A Hands-On Guide
**Author:** Shrijith Venkatramana
**Published:** April 12, 2025

## Overview
Guide building HITL agents using the ag2 framework, balancing automation with human oversight for high-stakes scenarios.

## Key Concepts

### Lesson Planning Agent
```python
from ag2 import ConversableAgent, LLMConfig

llm_config = LLMConfig(api_type="openai", model="gpt-4o-mini")
lesson_agent = ConversableAgent(
    name="lesson_agent",
    system_message="You are a classroom lesson agent...",
    human_input_mode="ALWAYS"
)
human.initiate_chat(recipient=lesson_agent, message="Create a lesson plan about the water cycle.")
```

### HITL Workflow
Agent initiates -> determines if human input needed -> prompts human -> updates based on response -> iterates until complete

### Pitfalls & Solutions
- Too many prompts: establish strict triggering rules
- Unclear behavior: write detailed system messages
- Lost insights: log human decisions for agent improvement
