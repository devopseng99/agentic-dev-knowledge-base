---
title: "War Story: We Migrated from Hugging Face Inference API to Self-Hosted LLMs and Cut Latency by 60%"
url: "https://dev.to/johalputt/war-story-we-migrated-from-hugging-face-inference-api-to-self-hosted-llms-and-cut-latency-by-60-kjb"
author: "ANKUSH CHOUDHARY JOHAL"
category: "huggingface-llm-agents"
---
# War Story: We Migrated from Hugging Face Inference API to Self-Hosted LLMs and Cut Latency by 60%
**Author:** ANKUSH CHOUDHARY JOHAL  **Published:** April 27, 2026

## Overview
A Series B fintech company's 12-person backend team migrated LLM inference from Hugging Face Inference API (HFIA) to self-hosted vLLM running on 8x NVIDIA A100 GPUs over six weeks. The migration achieved 60% latency reduction (p99: 2.8s → 1.12s), reduced monthly costs from $22k to $4.8k, and resolved throughput limitations.

## Key Concepts
- AWQ 4-bit quantization — selected over 12 tested schemes, balancing speed, accuracy (<1% loss), and memory efficiency
- Continuous Batching — vLLM's dynamic batching vs. HFIA's static approach eliminated 400-700ms latency penalty
- Operational Resilience — circuit breakers, exponential backoff retries, and health checks essential for self-hosted reliability
- Cost Analysis — self-hosted economics viable above ~5M tokens/month; achieved 78% cost reduction and 3.2-week ROI

## Performance Benchmarks

| Metric | HFIA | Self-Hosted vLLM |
|--------|------|------------------|
| p50 Latency | 1120ms | 380ms |
| p99 Latency | 2800ms | 1120ms |
| Throughput (16 concurrent) | 9.2 req/s | 29.8 req/s |
| Monthly Cost | $22,000 | $4,800 |

## Code Examples

### Benchmark Script
```python
import os
import time
import logging
from typing import List
from dataclasses import dataclass
import statistics
from huggingface_hub import InferenceClient
from openai import OpenAI

@dataclass
class BenchmarkConfig:
    model_id: str = "meta-llama/Meta-Llama-3-8B-Instruct"
    prompt: str = "Categorize this fintech transaction: Merchant: Starbucks, Amount: $5.75, Type: Debit"
    num_runs: int = 100
    timeout: int = 30
    hf_api_key: str = os.getenv("HF_API_KEY", "")
    vllm_endpoint: str = os.getenv("VLLM_ENDPOINT", "http://localhost:8000/v1")

def run_vllm_benchmark(config: BenchmarkConfig):
    client = OpenAI(base_url=config.vllm_endpoint, api_key="EMPTY")
    latencies = []
    for i in range(config.num_runs):
        start = time.perf_counter()
        response = client.chat.completions.create(
            model=config.model_id,
            messages=[{"role": "user", "content": config.prompt}],
            max_tokens=128,
            temperature=0.1,
        )
        elapsed = (time.perf_counter() - start) * 1000
        latencies.append(elapsed)
    latencies.sort()
    return statistics.median(latencies), latencies[int(0.99 * len(latencies))]
```

### Docker Compose Deployment
```yaml
version: "3.8"

services:
  vllm:
    image: vllm/vllm-openai:latest
    runtime: nvidia
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 8
              capabilities: [gpu]
    ports:
      - "8000:8000"
    command: >
      --model meta-llama/Meta-Llama-3-8B-Instruct
      --tensor-parallel-size 8
      --quantization awq
      --dtype float16
      --max-model-len 4096
      --gpu-memory-utilization 0.95
      --enable-prefix-caching
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### Circuit Breaker Pattern
```python
from circuitbreaker import circuit
from openai import OpenAI

client = OpenAI(base_url="http://vllm:8000/v1", api_key="EMPTY")

@circuit(failure_threshold=5, recovery_timeout=30)
def call_llm(prompt: str) -> str:
    response = client.chat.completions.create(
        model="meta-llama/Meta-Llama-3-8B-Instruct-AWQ",
        messages=[{"role": "user", "content": prompt}],
        max_tokens=128
    )
    return response.choices[0].message.content
```

### Quantization Comparison
```python
from vllm import LLM, SamplingParams
import time

models = [
    ("meta-llama/Meta-Llama-3-8B-Instruct-AWQ", "awq"),
    ("meta-llama/Meta-Llama-3-8B-Instruct-GPTQ", "gptq")
]

for model_id, quant in models:
    llm = LLM(model=model_id, quantization=quant, tensor_parallel_size=8)
    params = SamplingParams(max_tokens=128, temperature=0.1)
    start = time.perf_counter()
    llm.generate(["Test prompt"], params)
    print(f"{quant} latency: {(time.perf_counter()-start)*1000:.2f}ms")
```
