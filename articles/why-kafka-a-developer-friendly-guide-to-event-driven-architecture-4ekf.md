---
title: "Why Kafka? A Developer-Friendly Guide to Event-Driven Architecture"
url: "https://dev.to/lovestaco/why-kafka-a-developer-friendly-guide-to-event-driven-architecture-4ekf"
author: "Athreya aka Maneshwar"
category: "flink-kafka-agents"
---

# Why Kafka? A Developer-Friendly Guide to Event-Driven Architecture
**Author:** Athreya aka Maneshwar
**Published:** February 24, 2025

## Overview
Comprehensive guide to Apache Kafka with Docker setup, KafkaJS producer/consumer examples, and optimization strategies. Covers core components, partition strategies, and offset management.

## Key Concepts

### Docker Setup

```yaml
services:
  kafka:
    image: confluentinc/cp-kafka:latest
    ports:
      - "9092:9092"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
```

### Producer (KafkaJS)

```javascript
const { Kafka } = require("kafkajs");
const kafka = new Kafka({ clientId: "family-producer", brokers: ["localhost:9092"] });
const producer = kafka.producer();

async function sendMessage() {
  await producer.connect();
  const message = { id: Date.now(), content: `Message at ${new Date().toISOString()}` };
  await producer.send({
    topic: "family-topic",
    messages: [{ value: JSON.stringify(message) }],
  });
  await producer.disconnect();
}
```

### Consumer

```javascript
const consumer = kafka.consumer({ groupId: "email-group" });
async function consumeMessages() {
  await consumer.connect();
  await consumer.subscribe({ topic: "family-topic", fromBeginning: true });
  await consumer.run({
    eachMessage: async ({ message }) => {
      const msg = JSON.parse(message.value.toString());
      console.log(`Received: "${msg.content}"`);
    },
  });
}
```

### When to Use Kafka
- High-throughput real-time data processing
- Microservices decoupling
- Event-driven systems
- Reliable message delivery with persistence
- Scalable, fault-tolerant architectures

### Partition Assignment Strategies
- Range, Round Robin, Sticky, Cooperative Sticky
