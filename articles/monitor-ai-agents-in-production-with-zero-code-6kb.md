---
title: "Monitor AI Agents in Production with Zero Code"
url: "https://dev.to/aws/monitor-ai-agents-in-production-with-zero-code-6kb"
author: "Elizabeth Fuentes L"
category: "ai-agent-observability"
---

# Monitor AI Agents in Production with Zero Code

**Author:** Elizabeth Fuentes L
**Published:** November 5, 2025
**Updated:** April 15, 2026

## Overview

This tutorial demonstrates how to implement production monitoring for AI agents using Amazon Bedrock AgentCore Observability without writing instrumentation code. The solution provides automatic visibility into agent behavior, performance, and operational health.

## Key Problem Statement

After deploying production AI agents, developers face critical questions: How do you trace agent decisions? What happens with inconsistent behavior? How do you detect performance degradation? Traditional infrastructure monitoring fails to reveal whether AI makes effective decisions—requiring specialized observability.

## Core Concepts

### AgentCore Observability Hierarchy

The system uses a three-tier structure:

1. **Sessions** - Complete interaction contexts from initialization to termination, showing engagement patterns and performance over time
2. **Traces** - Single request-response cycles capturing execution paths, tool invocations, resource utilization, and error information
3. **Spans** - Discrete, measurable operations with defined start/end times, forming hierarchical parent-child relationships within traces

### Service Overview

| Service | Purpose | Features |
|---------|---------|----------|
| AgentCore Runtime | Serverless execution | Automatic observability |
| AgentCore Memory | Cross-session persistence | Built-in span tracking |
| AgentCore Gateway | API management | Tool invocation monitoring |
| AgentCore Identity | Credential management | Access logging |
| AgentCore Observability | Production monitoring | OpenTelemetry traces, metrics, dashboards |

## Implementation Steps

### 1. CloudWatch Setup (5 Minutes)

1. Open CloudWatch Console
2. Navigate to Application Signals -> Transaction Search
3. Enable Transaction Search
4. Check "ingest spans as structured logs"
5. Set indexing percentage to 1% (free tier)
6. Wait 10 minutes for spans to become searchable

### 2. Verify Observability Status

Run: `agentcore status`

The command confirms agents automatically send session metrics, trace data with spans, performance metrics (latency, duration, tokens), and error tracking.

### 3. Access GenAI Observability Dashboard

Navigate CloudWatch Console -> GenAI Observability -> Bedrock AgentCore tab

The dashboard displays:
- Total agents count
- Session and trace metrics
- Error and throttle rates
- Customizable time filters

### 4. Analyze Agent Performance

Three specialized views provide different insights:

**Agents View** displays all agents (Runtime and non-Runtime), agent-specific metrics, session/trace counts, error rates, and performance graphs.

**Sessions View** shows session duration, request counts, errors, engagement patterns, and timelines—filterable by session ID, agent, time range, duration, or error status.

**Traces View** provides detailed trace information, complete span breakdowns, waterfall visualizations, tool sequences, and error stack traces.

### 5. Examine Individual Traces

Click any Trace ID to view:
- Tree structure of operations (spans) with parent-child relationships
- Waterfall chart displaying execution timeline
- Identification of sequential/parallel operations and bottlenecks
- Error points

Click individual spans for three information tabs:
- **Attributes** - Operation metadata, input parameters, output results
- **Events** - Significant occurrences with timestamps
- **Duration and Status** - Start/end times, total duration, success/error status

## Extended Observability Configuration

For Memory, Gateway, Identity, and Built-in Tools, manually configure log destinations following AWS documentation.

**AgentCore Memory** tracks: Latency, Invocations, System/User Errors, Throttles, Creation Count

**AgentCore Gateway** monitors: Invocations, Latency, Duration, TargetExecutionTime, Throttles, Errors, TargetType

**AgentCore Identity** measures: WorkloadAccessTokenFetch, ResourceAccessTokenFetch, ApiKeyFetch metrics

**Built-in Tools** monitors: Code Interpreter and Browser invocations, takeover events, resource usage (CPU, Memory)

## Key Advantages

- Zero development overhead—automatic instrumentation for Runtime agents
- Complete visibility across sessions, traces, spans, and metrics
- Pre-built CloudWatch GenAI Observability dashboards
- Framework-agnostic compatibility (Strands Agents, LangChain, CrewAI, custom code)
- OpenTelemetry standard format for flexibility
- Production-grade reliability and scalability

## Learning Outcomes

Users master production observability for AI agents without instrumentation code, understand the observability hierarchy, navigate the GenAI dashboard, analyze trace details with waterfall visualizations, extend observability to all AgentCore services, and leverage OpenTelemetry standards.

## Related Series

Part 1: Deploy Production AI Agents with Amazon Bedrock AgentCore in 2 Commands
Part 2: Bring AI Agents with Long-Term Memory into Production in Minutes
Part 3: Monitor AI Agents in Production Without New Development *(this article)*
