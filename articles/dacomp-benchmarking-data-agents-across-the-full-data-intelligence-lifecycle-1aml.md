---
title: "DAComp: Benchmarking Data Agents across the Full Data Intelligence Lifecycle"
url: "https://dev.to/paperium/dacomp-benchmarking-data-agents-across-the-full-data-intelligence-lifecycle-1aml"
author: "paperium"
category: "llm-research-evals"
---
# DAComp: Benchmarking Data Agents across the Full Data Intelligence Lifecycle
**Author:** paperium  **Published:** May 4, 2026

## Overview
DAComp introduces a comprehensive benchmark for evaluating AI agents across the full data intelligence lifecycle — from raw data ingestion through analysis, visualization, and insight generation — rather than testing isolated data skills.

## Key Concepts

### The Data Intelligence Lifecycle
DAComp evaluates agents on end-to-end data tasks spanning:
1. **Data Ingestion** — Reading, parsing, and normalizing diverse data formats (CSV, JSON, SQL, Excel)
2. **Data Cleaning** — Detecting and handling missing values, outliers, duplicates
3. **Data Analysis** — Statistical analysis, correlation discovery, hypothesis testing
4. **Visualization** — Generating appropriate charts and figures for data patterns
5. **Insight Generation** — Translating analytical findings into actionable summaries
6. **Report Writing** — Producing structured reports combining analysis and visualizations

### Why Lifecycle Evaluation Matters
Prior data agent benchmarks test individual skills (SQL generation, visualization) in isolation. Real data intelligence tasks require chaining these capabilities correctly — errors in early stages propagate through the pipeline.

### Benchmark Design Principles
- **End-to-end evaluation** — Scores the complete pipeline output, not intermediate steps
- **Diverse data domains** — Financial, scientific, social, and operational datasets
- **Realistic noise** — Real-world data quality issues included (not clean toy datasets)
- **Multi-format inputs** — Agents must handle any data format without human pre-processing

### Key Findings from Initial Evaluation
1. **Single-step agents fail** at multi-step pipelines even when each step is individually capable
2. **Error propagation** is the primary failure mode — early mistakes compound downstream
3. **Visualization quality** is the weakest link for current LLM agents
4. **Domain specificity** matters — agents strong on financial data may fail on scientific data with different conventions

### Implications for Agent Development
DAComp reveals that data intelligence capability cannot be decomposed into independent skills — agents need holistic training on complete pipelines, not just individual operations.
