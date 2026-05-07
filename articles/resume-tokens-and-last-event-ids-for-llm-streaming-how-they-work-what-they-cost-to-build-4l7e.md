---
title: "Resume tokens and last-event IDs for LLM streaming: How they work & what they cost to build"
url: "https://dev.to/ablyblog/resume-tokens-and-last-event-ids-for-llm-streaming-how-they-work-what-they-cost-to-build-4l7e"
author: "Ably Blog"
category: "llm-streaming"
---

# Resume tokens and last-event IDs for LLM streaming

**Author:** Ably Blog
**Published:** April 13, 2026

## Overview
When connections drop mid-stream, most systems restart entirely, forcing users to re-prompt and incurring duplicate token costs. This article covers resume mechanisms for LLM streaming.

## Key Concepts

### Resume Mechanism Components
- Message identifiers (sequential, monotonically increasing)
- Client-side position tracking
- Reconnection protocol with last-received ID
- Ordered catchup delivery before live streaming resumes

### SSE Implementation
Server-Sent Events implements resume natively with automatic Last-Event-ID header handling. Limitations: unidirectional, HTTP-only, no distributed state management.

### Storage Architecture
Storing individual tokens as separate records creates performance bottlenecks. A 500-word response generates ~625 token records. The practical solution treats each AI response as a single logical message with appended tokens.

### Failure Modes
- **Duplicates:** Client-side deduplication using message IDs
- **Gaps:** Gap detection and missing-message request logic

### Multi-Device Continuity
Multi-device continuity is where connection-oriented design hits a wall. Persistent channels replace connection-based state for true cross-device support.

### Production Timeline
Teams report: Week 1 initial implementation, Month 1 edge case resolution, 6+ months incomplete multi-device reliability.
