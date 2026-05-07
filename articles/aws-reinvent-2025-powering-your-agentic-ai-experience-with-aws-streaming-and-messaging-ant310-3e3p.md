---
title: "AWS re:Invent 2025 - Powering your Agentic AI experience with AWS Streaming and Messaging (ANT310)"
url: "https://dev.to/kazuya_dev/aws-reinvent-2025-powering-your-agentic-ai-experience-with-aws-streaming-and-messaging-ant310-3e3p"
author: "Kazuya"
category: "flink-kafka-agents"
---

# AWS re:Invent 2025 - Powering your Agentic AI experience with AWS Streaming and Messaging
**Author:** Kazuya
**Published:** December 6, 2025

## Overview
Explores how streaming and messaging services enable agentic AI applications, featuring design patterns using Amazon Kinesis Data Streams, Amazon MSK, and Apache Flink for anomaly detection. Includes a case study from Olympics.com processing 3.2 petabytes of user actions during Paris 2024.

## Key Concepts

### Design Pattern: Real-Time Anomaly Detection (3 Tiers)
1. **Streaming Storage Layer**: Kinesis or MSK store raw data; multiple producers write in parallel
2. **Stream Processing Layer**: Apache Flink detects anomalies using rule-based thresholds or Random Cut Forests
3. **Agent Invocation Layer**: Detected anomalies trigger AI agent activation for context enrichment and autonomous decisions

### Multi-Agent Architecture
Specialized agents communicate asynchronously via Amazon SQS, functioning as microservices:
- **Interest Scorer Agent**: Validates whether anomaly warrants processing
- **Enrichment & Summary Agent**: Adds context from multiple sources
- **Channel Decisive Agents**: Regional agents with location-specific logic

### Olympics.com Case Study
- Paris 2024: 325 million users, 150x peak write volume, 3.2 petabytes of user actions
- Apache Flink detected traffic anomalies (e.g., 40% spike during penalty events)
- Milano Cortina 2026 architecture upgraded to Amazon Bedrock AgentCore with multi-agent workflow via SQS

### Key Takeaways
- "Streaming data is not a nice to have in the world of agentic AI -- it is a must"
- Messaging services (SQS, MQ) enable asynchronous agent-to-agent communication
- AgentCore provides dedicated runtime, built-in memory, and observability for production agent deployment
- Performance analysis revealed 6-second Anthropic call suggesting frontier model usage where smaller models would suffice
