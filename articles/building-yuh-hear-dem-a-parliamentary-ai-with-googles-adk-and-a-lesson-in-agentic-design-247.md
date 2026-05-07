---
title: "Building Yuh Hear Dem: A Parliamentary AI with Google's ADK and a Lesson in Agentic Design"
url: "https://dev.to/hammertoe/building-yuh-hear-dem-a-parliamentary-ai-with-googles-adk-and-a-lesson-in-agentic-design-247"
author: "Matt Hamilton"
category: "hackathons"
---

# Building Yuh Hear Dem: A Parliamentary AI with Google's ADK
**Author:** Matt Hamilton
**Published:** June 19, 2025

## Overview
A hackathon project transforming 1,200+ hours of parliamentary video transcripts from Barbados into a searchable, conversational AI system using Google ADK. Features 33,000 nodes and 86,000 statements stored in MongoDB Atlas with hybrid retrieval combining vector search and knowledge graph traversal.

## Key Concepts

### Refactored Single-Agent Solution
```python
self.agent = LlmAgent(
    name="YuhHearDem",
    model="gemini-2.5-flash-preview-05-20",
    planner=BuiltInPlanner(),
    tools=[
        FunctionTool(search_parliament_hybrid),
        FunctionTool(clear_session_graph),
        FunctionTool(get_session_graph_stats),
        FunctionTool(visualize_knowledge_graph)
    ]
)
```

Critical lesson: Unreliable session state sharing in ADK's SequentialAgent (GitHub Issue #1119) led to refactoring from multi-agent to single intelligent agent with specialized function tools.

### GitHub Repository
- https://github.com/KatieM00/YuhHearDem

**Live Site:** https://yuhheardem.com
