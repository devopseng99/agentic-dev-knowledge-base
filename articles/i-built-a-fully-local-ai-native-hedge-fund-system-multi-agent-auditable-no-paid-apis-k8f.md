---
title: "I Built a Fully Local, AI-Native Hedge Fund System (Multi-Agent, Auditable, No Paid APIs)"
url: "https://dev.to/tapesh_chandradas_5f7919/i-built-a-fully-local-ai-native-hedge-fund-system-multi-agent-auditable-no-paid-apis-k8f"
author: "Tapesh Chandra Das"
category: "ai-agent-trading-finance"
---

# I Built a Fully Local, AI-Native Hedge Fund System (Multi-Agent, Auditable, No Paid APIs)

**Author:** Tapesh Chandra Das
**Published:** April 16, 2026

## Overview

A complete trading system prototype featuring multi-agent architecture with research, strategy, and risk components. Zero paid API dependencies using yfinance, Ollama, and Alpaca. Full audit infrastructure with TraceLM execution tracing and structured logging.

## Key Concepts

### System Pipeline

Data Ingest -> Data Quality Gate -> Research Agent -> Strategy Ensemble -> Overlays -> Fund Manager -> Risk Manager -> Execution Controls -> Broker Router -> Audit + Tracing

### Performance Metrics (Current Strategy)

- Sharpe ratio: ~0.61
- CAGR: ~7.6%
- Maximum drawdown: ~-25.8%

### Notable Features

- Multi-agent architecture with research, strategy, and risk components
- Zero paid API dependencies (yfinance, Ollama, Alpaca)
- Full audit infrastructure with TraceLM execution tracing
- Production-style reliability including circuit breakers and heartbeat monitoring
- FastAPI services, Celery workers, Redis, and Postgres/TimescaleDB infrastructure

### Core Philosophy

"Systems matter more than models." The author emphasizes observability as non-negotiable for any trading system.

**GitHub Repository:** https://github.com/td-02/ai-native-hedge-fund
