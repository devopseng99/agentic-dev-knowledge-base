---
title: "I Built a Small Agentic Trading App. It Cost Me a Few Hours and About $0.20 Per Run."
url: "https://dev.to/ionionascu/i-built-a-small-agentic-trading-app-it-cost-me-a-few-hours-and-about-020-per-run-3ikj"
author: "Ion"
category: "ai-agent-trading-finance"
---

# I Built a Small Agentic Trading App. It Cost Me a Few Hours and About $0.20 Per Run.

**Author:** Ion
**Published:** March 13, 2026

## Overview

An agentic trading application that accepts user input, retrieves market data and news, processes context through an LLM, maintains memory from previous runs, and delivers results through email and push notifications. Each execution costs approximately $0.20 in Claude API usage.

## Key Concepts

### What It Does

The app generates concrete, actionable recommendations: "WAIT," "BUY at [price]," "SELL at [price]," or order modifications. The author maintains human control over final trading decisions.

### Technical Stack

- Claude models with Python application leveraging LangChain
- Claude Code (Opus) assisted with scaffolding
- Containerized on Kubernetes (K3s) hosted on a Raspberry Pi 5
- Executes via cronjobs
- Claude Sonnet for reasoning and recommendations

### Key Components

- Broker API integration for positions, pending orders, and history
- Tavily tool integration (through LangChain) for market news
- Dynamic prompt assembly incorporating current data and previous run summaries
- File-based memory system storing condensed run summaries
- Email and Home Assistant-based push notifications

### Architecture (8 Sequential Steps)

1. Cronjob triggers Docker execution
2. Broker API calls retrieve position data
3. Tavily retrieves market news
4. Dynamic prompt assembly
5. Claude Sonnet processes context
6. Output saved to file
7. Notifications dispatched
8. Human decision-making

### Central Thesis

"The orchestration is just code. It always was." Developers already possess sufficient tools for building AI agents without specialized frameworks. The essential requirements: an LLM API, a few REST calls, some string templating for prompts, a file system for memory, a way to send notifications, and a container runtime.
