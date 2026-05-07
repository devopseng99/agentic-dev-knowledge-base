---
title: "Moving DeepSeek-R1 from Transformers to vLLM: A 14x Throughput Boost"
url: "https://dev.to/_eb7f2a654e97a60ae9f96e/moving-deepseek-r1-from-transformers-to-vllm-a-14x-throughput-boost-f9d"
author: "BAOFUFAN"
category: "code-optimization"
---
# Moving DeepSeek-R1 from Transformers to vLLM: A 14x Throughput Boost
**Author:** BAOFUFAN  **Published:** May 7, 2026

## Overview
Documents migrating DeepSeek-R1 LLM inference from Hugging Face Transformers to vLLM, achieving 14x throughput improvement through PagedAttention memory management and continuous batching. Key insight: Transformers allocates KV cache statically per request; vLLM uses dynamic paged allocation that eliminates memory waste and enables much larger effective batch sizes.

## Key Concepts

### Why Transformers is Slow for Inference
- Static KV cache allocation: reserves full context_length * num_heads * head_dim memory per request, even for short outputs
- No request batching: processes requests sequentially by default
- Memory fragmentation: pre-allocated but unused KV cache wastes GPU memory

### What vLLM Does Differently

**PagedAttention**: Divides KV cache into fixed-size pages (like OS virtual memory). Allocates pages on-demand instead of upfront. Enables non-contiguous physical memory for KV cache - eliminates 40-80% memory waste.

**Continuous Batching**: Instead of waiting for all requests in a batch to finish, new requests slot in as others complete. Keeps GPU utilization near 100%.

**Tensor Parallelism**: Distributes model across multiple GPUs with minimal synchronization overhead.

## Key Code Examples

```python
# Before: HuggingFace Transformers - sequential, no batching
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch

model = AutoModelForCausalLM.from_pretrained(
    "deepseek-ai/DeepSeek-R1",
    torch_dtype=torch.bfloat16,
    device_map="auto"
)
tokenizer = AutoTokenizer.from_pretrained("deepseek-ai/DeepSeek-R1")

def generate_transformers(prompt: str) -> str:
    inputs = tokenizer(prompt, return_tensors="pt").to("cuda")
    # Allocates full context_length KV cache upfront
    outputs = model.generate(**inputs, max_new_tokens=512)
    return tokenizer.decode(outputs[0], skip_special_tokens=True)

# Throughput: ~3 tokens/sec on 4x A100 80GB
```

```python
# After: vLLM - PagedAttention + continuous batching
from vllm import LLM, SamplingParams

llm = LLLM(
    model="deepseek-ai/DeepSeek-R1",
    tensor_parallel_size=4,      # Distribute across 4 GPUs
    gpu_memory_utilization=0.90, # Use 90% of GPU memory for KV cache pages
    max_model_len=32768,
)

sampling_params = SamplingParams(
    temperature=0.7,
    max_tokens=512,
)

def generate_vllm(prompts: list[str]) -> list[str]:
    # Process entire batch simultaneously with continuous batching
    outputs = llm.generate(prompts, sampling_params)
    return [output.outputs[0].text for output in outputs]

# Throughput: ~42 tokens/sec on same 4x A100 80GB - 14x improvement
```

```python
# vLLM OpenAI-compatible server for production deployment
# Start server:
# python -m vllm.entrypoints.openai.api_server \
#   --model deepseek-ai/DeepSeek-R1 \
#   --tensor-parallel-size 4 \
#   --gpu-memory-utilization 0.90 \
#   --host 0.0.0.0 --port 8000

# Query via OpenAI client:
from openai import OpenAI

client = OpenAI(base_url="http://localhost:8000/v1", api_key="not-needed")

response = client.chat.completions.create(
    model="deepseek-ai/DeepSeek-R1",
    messages=[{"role": "user", "content": "Explain attention mechanisms"}],
    max_tokens=512,
    temperature=0.7,
)
print(response.choices[0].message.content)
```

## Performance Results

| Metric | Transformers | vLLM | Improvement |
|--------|-------------|------|-------------|
| Throughput (tokens/sec) | 3 | 42 | 14x |
| GPU memory utilization | 45% | 89% | 2x better use |
| Batch size (max effective) | 1-2 | 32+ | 16-32x |
| p99 latency (single request) | 12s | 3.2s | 3.75x |

## When NOT to Use vLLM
- Models smaller than 7B on a single GPU - Transformers is simpler
- One-off inference scripts - setup overhead not worth it
- Experimental fine-tuning - Transformers has better training integration
