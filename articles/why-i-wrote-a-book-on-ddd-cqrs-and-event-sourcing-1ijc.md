---
title: "Why I Wrote a Book on DDD, CQRS and Event Sourcing"
url: "https://dev.to/alexlawrence/why-i-wrote-a-book-on-ddd-cqrs-and-event-sourcing-1ijc"
author: "Alex Lawrence"
category: "immutable-arch-rust-flink"
---
# Why I Wrote a Book on DDD, CQRS and Event Sourcing
**Author:** Alex Lawrence  **Published:** February 3, 2021

## Overview
Personal journey from unknowingly implementing CQRS/Event Sourcing in a Session Replay tool (2013) to consciously applying DDD patterns at a startup, leading to writing a 450+ page practical guide on DDD, CQRS, and Event Sourcing in JavaScript/Node.js.

## Key Concepts
- **Session Replay tool (2013)**: User interaction events validated and persisted in a log; read side projected events into replay — accidental CQRS + ES implementation
- **Conscious application (2014+)**: Startup developing collaborative web-based meeting software with full Node.js DDD/CQRS/ES rewrite
- Key distinction learned: conceptual difference between Domain Events and Event Sourcing records
- Book grew from envisioned 150 pages to 450+ pages to provide sufficient context for readers with no prior DDD/CQRS/ES knowledge
- Uses JavaScript and Node.js for implementations

Why existing literature was insufficient: practical guidance was absent; most books assumed prior knowledge of the patterns.
