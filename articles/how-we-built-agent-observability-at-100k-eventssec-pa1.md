---
title: "How We Built Agent Observability at 100K Events/Sec"
url: "https://dev.to/aishiteru/how-we-built-agent-observability-at-100k-eventssec-pa1"
author: "Zeng James"
category: "ai-agent-observability"
---

# How We Built Agent Observability at 100K Events/Sec

**Author:** Zeng James
**Date Published:** April 26, 2026
**Last Modified:** April 29, 2026
**Tags:** #agents #architecture #monitoring #showdev

---

## Overview

The article describes AgentTrace, an observability infrastructure system built at Stealth to monitor AI agent workflows. The author shares learnings from three architecture iterations, schema redesigns, and a critical production incident involving silent data loss.

---

## Key Technical Sections

### 1. The Data Model: Spans and Trace Missions

Traditional distributed tracing uses spans as fundamental units. AgentTrace extends this with a "trace mission" concept—a higher-order organizational unit capturing a complete agent workflow including parent agent, purpose, involved nodes, and the full span tree.

The distinction matters for query patterns. Engineers ask different questions at different levels: workflow failures versus specific LLM call details.

### 2. Data Ingestion: Proxies Over SDKs

Rather than requiring SDK instrumentation, the system uses Envoy proxies at the network layer. Proxies intercept traffic transparently, extract relevant fields, and emit spans without agent code modifications. This eliminates friction for enterprise customers who cannot control runtime environments.

### 3. Pipeline Architecture: Collector and Processor Split

**Trace Collector:** Handles ingestion, validation, and event publication
**Trace Processor:** Consumes events, assembles spans into trace trees, writes to PostgreSQL

Separating these services prevents slow database writes from backing up the ingestion pipeline. A WebSocket hybrid approach determines trace completion: either a terminal span arrives or a timeout window with no new spans occurs—whichever comes first.

### 4. Three Iterations Toward Pub/Sub

**Iteration 1 - In-memory buffer:**
"Adequate in development, collapsed under production load" with no error recovery. Process restarts caused total data loss.

**Iteration 2 - FIFO queue:**
Improved durability and ordering but hit throughput ceiling at enterprise scale.

**Iteration 3 - GCP Pub/Sub:**
Achieved both throughput (100K+ events/second) and reliability through native fan-out, producer-consumer decoupling, and at-least-once delivery guarantees.

### 5. Schema Evolution: Moving Away from JSONB

Initial design used JSONB for nested hierarchical data. This proved problematic at scale due to slower nested queries, larger storage footprint, and weaker ACID guarantees.

**Replacement: Two-table normalized schema**

**Table 1 - Summary:**
High-frequency dashboard queries using composite primary key (Trace ID + Agent ID)

**Table 2 - Detail:**
Full drilldown data using Entity-Attribute-Value pattern with two columns:
- `Detail_Name`
- `Detail_Value`

This approach eliminates schema migrations when adding span detail types while maintaining indexed access patterns.

### 6. The Critical Incident: 87% of Records Lost

After launch, 87% of trace records became incomplete. No alerts fired. Root cause: Kubernetes pod restarts assigned new ports, stale destination mappings orphaned in-flight records.

Solution: Routing logic detecting port reassignment and reattaching active connections before data loss.

---

## Key Takeaways

1. **Agent observability requires higher-order units** beyond service-level spans to capture workflow intent and context

2. **Schema design matters more than initial intuition** suggests—flexible schemas are expensive at scale; design around actual access patterns

3. **Transparent instrumentation via proxies** eliminates adoption friction compared to SDK-based approaches

4. **Service decoupling prevents cascade failures**—separate ingestion from processing to isolate different failure modes

5. **Monitor the monitoring layer explicitly**—observability systems need their own health checks since they won't alert on their own failures

6. **Silent data loss in observability is worse than explicit failure** because it undermines the entire system's purpose
