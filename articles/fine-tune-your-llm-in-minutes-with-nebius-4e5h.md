---
title: "Fine-Tune Your LLM in MINUTES with Nebius"
url: "https://dev.to/arindam_1729/fine-tune-your-llm-in-minutes-with-nebius-4e5h"
author: "Arindam Majumder"
category: "llm-fine-tuning-agent"
---

# Fine-Tune Your LLM in MINUTES with Nebius

**Author:** Arindam Majumder
**Published:** March 13, 2025

## Overview

A comprehensive guide to fine-tuning LLMs using Nebius AI Studio with three approaches: Web Console (no-code), Python SDK, and cURL API. Supports 30+ models including Llama 3, Qwen, and DeepSeek R1.

## Key Concepts

### Python SDK Setup

```python
import os
from openai import OpenAI
import time

client = OpenAI(
 base_url="https://api.studio.nebius.com/v1/",
 api_key=os.environ.get("NEBIUS_API_KEY"),
)
```

### Dataset Upload

```python
training_dataset = client.files.create(
 file=open("<dataset_name>.jsonl", "rb"),
 purpose="fine-tune"
)

validation_dataset = client.files.create(
 file=open("<dataset_name>.jsonl", "rb"),
 purpose="fine-tune"
)
```

### Fine-Tuning Job Creation

```python
job_request = {
 "model": "meta-llama/Llama-3.1-8B-Instruct",
 "training_file": training_dataset.id,
 "validation_file": validation_dataset.id,
 "hyperparameters": {
  "n_epochs": 3,
  "lora": True,
 },
 "integrations": [],
}

job = client.fine_tuning.jobs.create(**job_request)
```

### Status Monitoring

```python
active_statuses = ["validating_files", "queued", "running"]
while job.status in active_statuses:
 time.sleep(15)
 job = client.fine_tuning.jobs.retrieve(job.id)
 print("current status is", job.status)
```

### cURL Fine-Tuning Request

```bash
curl 'https://api.studio.nebius.com/v1/fine_tuning/jobs' \
 -X 'POST' \
 -H 'Authorization: Bearer $NEBIUS_API_KEY' \
 -H 'Content-Type: application/json' \
 -d '{
 "model": "meta-llama/Llama-3.1-8B-Instruct",
 "training_file": "your_training_file_id",
 "validation_file": "your_validation_file_id",
 "hyperparameters": {
  "n_epochs": 3,
  "batch_size": 8,
  "learning_rate": 0.0001,
  "lora": true,
  "lora_r": 16,
  "lora_alpha": 32,
  "lora_dropout": 0.1,
  "weight_decay": 0.01
 }
}'
```

"Fine-tuning is accessible to everyone, whether they are into coding or not."
