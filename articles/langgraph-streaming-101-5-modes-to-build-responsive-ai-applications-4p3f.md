---
title: "LangGraph Streaming 101: 5 Modes to Build Responsive AI Applications"
url: "https://dev.to/sreeni5018/langgraph-streaming-101-5-modes-to-build-responsive-ai-applications-4p3f"
author: "Seenivasa Ramadurai"
category: "flink-kafka-agents"
---

# LangGraph Streaming 101: 5 Modes
**Author:** Seenivasa Ramadurai
**Published:** December 10, 2025

## Overview
Five distinct streaming modes in LangGraph for building responsive AI applications with real-time progress and intermediate results.

## Key Concepts
1. **Values mode**: Complete state snapshot at each step
2. **Updates mode**: Only changed data after each node executes
3. **Messages mode**: Token-by-token LLM output (typing effect)
4. **Custom mode**: Domain-specific events and progress indicators
5. **Debug mode**: X-ray vision into graph execution during development

Modes can be combined -- e.g., messages + updates for rich UIs showing both AI responses and backend activity. Applications include chat interfaces, progress dashboards, and transparent long-running workflows.
