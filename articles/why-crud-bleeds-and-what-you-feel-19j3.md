---
title: "Why CRUD Bleeds (and What You Feel)"
url: "https://dev.to/matheuscamarques/why-crud-bleeds-and-what-you-feel-19j3"
author: "Matheus de Camargo Marques"
category: "immutable-arch-rust-flink"
---
# Why CRUD Bleeds (and What You Feel)
**Author:** Matheus de Camargo Marques  **Published:** March 17, 2026

## Overview
Part 1 of 5 in the "CQRS and architecture for AI agents" series. CRUD-based backends suffer when handling concurrent AI agents. Multiple agents attempting concurrent reads and writes on monolithic records cause race conditions, loss of audit trails, unpredictable behavior, and governance violations.

## Key Concepts
Four pain points signaling CRUD limitations:
1. **Highly Collaborative Environments**: Lock contention with parallel AI agents
2. **Friction in Separation of Responsibilities**: Frontend speed vs transactional validation
3. **Systems in Constant Evolution**: Display rules change faster than business rules
4. **Acute Pain in System Integration**: Distributed failures cascade

| Symptom | CRUD Impact | AI Agent Impact |
|---------|------------|-----------------|
| Schema impedance | Normalization/denormalization conflicts | Delays in RAG context retrieval, degrading agent reasoning |
| Lock contention | Reduced concurrent transaction throughput | Failures in parallel execution loops; API timeouts breaking LLM reasoning |
| Intention opacity | Generic operations mask business intent | Inability to audit why agents made critical decisions |
| Failure coupling | Slow writes disable read availability | External tool failures paralyze agent observation |

Three core pathologies:
- **Schema Optimization Conflicts**: Write needs normalization, reads need denormalization
- **Asymmetric Scalability**: Modern read-to-write ratios are 1000:1; complex reads lock writes
- **Intention Opacity**: Generic UPDATE operations mask business intent
