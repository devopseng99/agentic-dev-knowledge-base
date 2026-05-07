---
title: "I Built an AI Agent That Finds Jobs for Me"
url: "https://dev.to/arindam_1729/i-built-an-ai-agent-that-finds-jobs-for-me-5427"
author: "Arindam Majumder"
category: "agent-ui-frameworks"
---

# I Built an AI Agent That Finds Jobs for Me
**Author:** Arindam Majumder
**Published:** June 2, 2025

## Overview
Multi-agent AI workflow using OpenAI Agents SDK analyzing LinkedIn profiles to find job opportunities, with Streamlit UI, BrightData MCP Server for web scraping, and Nebius AI Studio for LLM access.

## Key Concepts
- Six sequential agents: LinkedIn Analyzer, Job Suggestions, URL Generator, Job Finder, URL Parser, Summary Agent
- Single-task agents prevent confusion and hallucinations
- BrightData MCP Server enables real-time web scraping without blocks
- Streamlit frontend for profile input and markdown result display
- Async Python pipeline passing each agent's output as next agent's input
