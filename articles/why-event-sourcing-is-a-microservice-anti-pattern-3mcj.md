---
title: "Why Event Sourcing is a Microservice Communication Anti-Pattern"
url: "https://dev.to/olibutzki/why-event-sourcing-is-a-microservice-anti-pattern-3mcj"
author: "Oliver Libutzki"
category: "immutable-arch-rust-flink"
---
# Why Event Sourcing is a Microservice Communication Anti-Pattern
**Author:** Oliver Libutzki  **Published:** June 28, 2019

## Overview
Event Sourcing is valuable as a local persistence strategy within a Bounded Context, but using it for inter-service communication creates problematic coupling identical to shared databases. Publishing Event Sourcing events across service boundaries exposes persistence implementation details as public API.

## Key Concepts
Core argument: "Your persistence becomes your public API. Every time a Bounded Context adjusts its persistent data, we have to deal with a public API change."

Key distinction:
- **Domain Events**: Business-level occurrences understood by domain experts — appropriate for inter-service communication
- **Event Sourcing events**: Implementation details for state persistence — must stay internal to Bounded Context

Two solutions for inter-service communication:

**1. Open Host Service with Published Language**
Publish a single Domain Event containing all data consumers might need. Example: `OrderAccepted` event from an Order context.

**2. Customer/Supplier Pattern**
Publish multiple specialized events per consumer:
- `InvoiceOrderAccepted` (contains invoice-relevant data)
- `DeliveryOrderAccepted` (contains delivery-relevant data)

Services can internally use Event Sourcing while publishing different events externally, maintaining separation of concerns.

References: Eberhard Wolff, Greg Young, DDD resources.
