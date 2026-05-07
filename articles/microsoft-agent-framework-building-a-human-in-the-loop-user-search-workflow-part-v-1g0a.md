---
title: "Microsoft Agent Framework Building a Human-in-the-Loop User Search Workflow: Part-V"
url: "https://dev.to/sreeni5018/microsoft-agent-framework-building-a-human-in-the-loop-user-search-workflow-part-v-1g0a"
author: "Seenivasa Ramadurai"
category: "agent-ui-frameworks"
---

# Microsoft Agent Framework Building a Human-in-the-Loop User Search Workflow: Part-V
**Author:** Seenivasa Ramadurai
**Published:** October 13, 2025

## Overview
HITL system using Microsoft Agent Framework with pause-resume capabilities and event-driven interactions for user search workflows.

## Key Concepts
- RequestInfoMessage/RequestInfoExecutor for typed request structures
- RequestInfoEvent for async human responses
- WorkflowBuilder for graph construction
- Flow: name request -> AI search -> human selection -> targeted search -> formatted output
- Search types: Professional (LinkedIn), social media, comprehensive multi-source
- Python with Tavily API, Pydantic models, async/await patterns
