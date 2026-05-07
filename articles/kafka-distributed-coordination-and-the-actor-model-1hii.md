---
title: "Kafka, Distributed Coordination and the Actor Model"
url: "https://dev.to/danlebrero/kafka-distributed-coordination-and-the-actor-model-1hii"
author: "Dan Lebrero"
category: "flink-kafka-agents"
---

# Kafka, Distributed Coordination and the Actor Model
**Author:** Dan Lebrero
**Published:** April 10, 2018

## Overview
How Kafka's partitioning creates a natural leader election and distributed coordination system, mirroring the Actor Model pattern from Erlang/Clojure.

## Key Concepts
- Messages with same key go to same partition; one consumer per partition = leader election
- Single-threaded consumer mirrors Erlang actors -- eliminates synchronization concerns
- Kafka automatically distributes actor-like entities across service instances (distributed sharding)
- Request deduplication: designated partition leader processes first command, ignores duplicates via atomic putIfAbsent
- Natural fit for distributed coordination without separate consensus systems
