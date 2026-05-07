---
title: "Event Sourcing: What It Is and Why It's Awesome"
url: "https://dev.to/barryosull/event-sourcing-what-it-is-and-why-its-awesome"
author: "Barry O Sullivan"
category: "immutable-arch-rust-flink"
---
# Event Sourcing: What It Is and Why It's Awesome
**Author:** Barry O Sullivan  **Published:** August 29, 2017

## Overview
Foundational overview of Event Sourcing: modeling systems as sequences of immutable events rather than storing only current state. Every change is captured as an immutable event creating a complete historical audit trail. MySQL used for the event store (optimized for append operations) with indexing by aggregate ID.

## Key Concepts
Shopping cart lifecycle as event sequence:
- Shopping Cart Created
- Item Added to Cart (×2)
- Item Removed from Cart
- Shopping Cart Checked-Out

Business rules enforced by replaying event subsets. To verify an item can be removed: check whether "Item Added" events exist.

Seven key benefits:
1. **Ephemeral data structures**: New projections replace old ones without migration scripts
2. **Domain alignment**: Systems model business processes as experts describe them
3. **Expressive models**: Events become first-class objects
4. **Enhanced reporting**: Full historical data enables time-travel analytics
5. **Service composition**: Events enable loose coupling between systems
6. **Database efficiency**: Append-only operations align with database optimization
7. **Technology flexibility**: Read models can use any database technology

Challenges:
1. **Eventual consistency**: Projections lag ~100ms behind events
2. **Event evolution**: Changing event schemas requires migration strategies
3. **Developer mindset shift**: Teams must reconsider state-driven approaches

Implementation: MySQL for event store with append optimization; Kafka suggested for projection processing.

Projections: cached intermediate results built asynchronously; multiple read models simultaneously, each optimized for specific queries.
