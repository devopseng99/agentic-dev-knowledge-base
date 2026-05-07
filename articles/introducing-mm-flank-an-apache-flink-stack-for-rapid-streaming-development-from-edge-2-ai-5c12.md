---
title: "Introducing Mm FLaNK... An Apache Flink Stack for Rapid Streaming Development From Edge 2 AI"
url: "https://dev.to/tspannhw/introducing-mm-flank-an-apache-flink-stack-for-rapid-streaming-development-from-edge-2-ai-5c12"
author: "Timothy Spann"
category: "flink-kafka-agents"
---

# Mm FLaNK: Apache Flink Stack for Edge to AI
**Author:** Timothy Spann
**Published:** November 27, 2019

## Overview
End-to-end IoT streaming stack: MXNet + MiNiFi + Flink + NiFi + Kafka + Kudu. Demonstrates data pipeline from edge ingestion through AI processing to storage.

## Key Concepts

### Data Flow
NiFi ingests IoT JSON -> Kafka topic -> Flink processes/validates -> Second Kafka topic -> NiFi stores to Kudu

### Flink Filter Example

```java
public static class NotNullFilter implements FilterFunction {
    @Override public boolean filter(String string) throws Exception {
        if (string == null || string.isEmpty() || string.trim().length() <= 0)
            return false;
        return true;
    }
}
```

### Stack Components
- Apache NiFi: Data ingestion and routing
- Apache Kafka: Event streaming backbone
- Apache Flink: Stream processing on YARN
- Apache Kudu: Storage layer
- Cloudera SMM: Monitoring consumer lag, brokers, topics
