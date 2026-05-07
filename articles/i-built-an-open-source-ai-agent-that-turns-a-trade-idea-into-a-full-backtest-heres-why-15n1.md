---
title: "I built an open-source AI agent that turns a trade idea into a full backtest -- here's why"
url: "https://dev.to/ritiksuman07/i-built-an-open-source-ai-agent-that-turns-a-trade-idea-into-a-full-backtest-heres-why-15n1"
author: "Ritiksuman07"
category: "ai-agent-trading-finance"
---

# I built an open-source AI agent that turns a trade idea into a full backtest

**Author:** Ritiksuman07
**Published:** April 23, 2026

## Overview

QuantFlow is a command-line tool that converts natural language trade ideas into executable backtests with performance metrics. It addresses the fragmentation in quantitative finance tooling.

## Key Concepts

### Core Functionality

```bash
python -m quantflow run "short small-cap biotech on FDA rejection patterns" --ticker XBI --offline --verbose
```

The pipeline executes these stages:
- Extracts and scores SEC filings (10-K, 10-Q, 8-K) for thesis-relevant signals
- Analyzes Reddit sentiment and mention velocity
- Generates executable strategy rules with entry/exit conditions
- Runs deterministic backtests computing Sharpe ratio, max drawdown, Calmar, CAGR
- Exports equity curves, reports, and stores artifacts in DuckDB

### Technical Architecture - Multi-Language Stack

- **Python:** Agent logic and strategy orchestration
- **Go:** Terminal UI with Bubble Tea interface for real-time pipeline visualization
- **Rust:** Backtest engine scaffold for deterministic, low-latency execution
- **DuckDB:** Memory layer storing all runs for queryable historical analysis

### Design Philosophy

The LLM integration remains intentionally isolated in `quantflow/agents/strategy.py`. This separation maintains reproducibility -- "LLM outputs can be unpredictable. Backtest results need to be reproducible."

The backtest engine does not care about strategy origin; it executes deterministic rules.

### Installation

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python -m quantflow run "short small-cap biotech on FDA rejection patterns" --ticker XBI --offline --verbose
```

### Key Learnings

- Resisting over-engineering the AI layer early proves critical
- DuckDB's zero-setup analytical capabilities outperformed planned Postgres implementation
- Multi-language design forced clean interfaces between components

**Repository:** github.com/Ritiksuman07/quantflow
