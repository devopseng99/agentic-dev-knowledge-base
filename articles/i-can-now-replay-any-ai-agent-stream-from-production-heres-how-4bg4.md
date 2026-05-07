---
title: "I can now replay any AI agent stream from production. Here's how."
url: "https://dev.to/abhishek_chatterjee_33b9d/i-can-now-replay-any-ai-agent-stream-from-production-heres-how-4bg4"
author: "Abhishek Chatterjee"
category: "flink-kafka-agents"
---

# Replay Any AI Agent Stream from Production
**Author:** Abhishek Chatterjee
**Published:** March 30, 2026

## Overview
AgentStreamRecorder: debugging tool for AI agent SSE streaming applications. Captures event sequences for replay when production streams fail.

## Key Concepts
- Drop-in wrapper for async generators captures SSE events without affecting latency
- JSONL format: appended newline-delimited JSON, greppable and crash-safe
- Relative timestamps (elapsed since start) for portable analysis
- CLI replay tool reconstructs production streams at variable speeds
- Stateless recording: each event teed to file and re-yielded unchanged
- Solved real debugging case: tools cleared in wrong order due to parallel execution
