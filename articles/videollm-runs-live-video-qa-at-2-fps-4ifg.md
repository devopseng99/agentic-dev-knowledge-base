---
title: "VideoLLM runs live video QA at 2 FPS"
url: "https://dev.to/olaughter/videollm-runs-live-video-qa-at-2-fps-4ifg"
author: "Papers Mache"
category: "llm-research-evals"
---
# VideoLLM runs live video QA at 2 FPS
**Author:** Papers Mache  **Published:** May 7, 2026

## Overview
AURA enables continuous streaming video processing for real-time question answering on live feeds at 2 FPS on two 80GB accelerators, using a sliding-window history with prefix key-value cache reuse.

## Key Concepts

### The Streaming Video LLM Problem
Most video-language models operate on pre-recorded clips with pauses between inferences. Previous streaming attempts separated visual encoding from language processing, relying on caption-style outputs or explicit triggers — neither approach enables true real-time interaction.

### AURA Architecture
AURA combines a video encoder with an LLM using:
- Sliding-window history across frames
- Prefix key-value cache reuse for bounded latency
- Continuous processing without pause-and-resume cycles

### Performance Metrics
- **Sustained throughput:** 2 FPS on two 80GB accelerators
- **Stream duration:** 5 minutes continuous at 2 FPS
- **Latency:** Bounded via KV cache reuse

### Hardware Requirements
- Two 80GB GPU accelerators (e.g., A100 or H100)
- Real-time ASR and TTS support included

### Limitations
- 2 FPS insufficient for high-speed applications (sports analysis, autonomous driving require 24-60+ FPS)
- Deployment cost of two 80GB GPUs limits accessibility
- Memory pressure may increase with longer interactions
- Multi-camera feed behavior unclear

### Practical Guidance
For production deployment:
- Benchmark dense video-LLM pipelines against AURA's 2 FPS baseline
- For sub-second live responses, allocate at least two high-memory GPUs
- Adopt cache-reuse patterns to maintain predictable latency
- Consider hybrid approaches: sparse frame sampling for background + dense for detected events

### Research Significance
AURA establishes a new baseline for streaming video understanding. The 2 FPS benchmark represents the current practical frontier for real-time video-language models on available hardware.
