---
title: "Building Sentinel: multi-agent cybersecurity news triage and publishing system on AWS"
url: "https://dev.to/aws-builders/building-sentinel-multi-agent-cybersecurity-news-triage-and-publishing-system-on-aws-5h5h"
author: "Benson King'ori"
category: "aws-agents"
---

# Building Sentinel: multi-agent cybersecurity news triage and publishing system on AWS
**Author:** Benson King'ori
**Published:** September 29, 2025

## Overview
AWS-native multi-agent system for autonomous cybersecurity intelligence. Uses Strands for agent orchestration, Bedrock for reasoning/embeddings/guardrails, EventBridge for scheduling, SQS for buffering, OpenSearch for semantic dedup, and DynamoDB for storage. Includes human-in-the-loop review and feature flags for phased rollout.

## Key Concepts

### Two Strands Agents
1. **Ingestor Agent:** Plans tool calls for feed processing (FeedParser, RelevancyEvaluator, DedupTool, GuardrailTool, StorageTool)
2. **Analyst Assistant Agent:** Natural language queries against collected intelligence

### Bedrock Usage
- ReAct reasoning with reflection on AgentCore
- Relevance scoring and entity extraction (CVEs, threat actors, malware)
- Executive summaries with JSON Schema validation
- Embeddings for semantic dedup via OpenSearch k-NN
- Guardrails for PII detection and format validation

### Feature Flags (SSM Parameter Store)
- `enable_agents` - Lambda vs AgentCore orchestration
- `enable_opensearch` - heuristic vs semantic dedup
- `enable_amplify` - backend-only vs full stack
- `enable_guardrails_strict` - guardrail sensitivity

### Key Learnings
1. Build deterministic pipelines before introducing agents
2. Treat agents as pluggable orchestrators over stable tools
3. Feature flags enable safe canary deployments
4. Measure SLOs rather than relying on assumptions
