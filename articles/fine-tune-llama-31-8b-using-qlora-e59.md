---
title: "Fine-Tune Llama 3.1 8B using QLORA"
url: "https://dev.to/koyeb/fine-tune-llama-31-8b-using-qlora-e59"
author: "alisdairbr (Koyeb)"
category: "huggingface-llm-agents"
---
# Fine-Tune Llama 3.1 8B using QLORA
**Author:** alisdairbr (Koyeb)  **Published:** October 2, 2024

## Overview
This tutorial demonstrates how to adapt large language models for specialized knowledge domains. The guide walks developers through fine-tuning Meta's Llama 3.1 8B model using QLORA (a memory-efficient training technique) on custom documentation — specifically Apple's MLX framework. The workflow includes dataset generation using OpenAI's API, model adaptation via Jupyter Notebook on GPU infrastructure, and deployment using vLLM.

## Key Concepts
- QLORA Training — memory-efficient fine-tuning method reducing GPU requirements
- Dataset Generation — using LLMs to create QA pairs from documentation
- LoRA Adapters — lightweight parameter updates merged with base models
- Serverless GPU Deployment — vLLM integration for production inference

## Code Examples

### Environment Setup
```bash
git clone https://github.com/koyeb/finetune-llama-on-koyeb.git
cd finetune-llama-on-koyeb
python3 -m venv venv
source ./venv/bin/activate
pip install datasets==2.16.1 openai==1.42.0 tqdm
huggingface-cli login
```

### Dataset Generation
```bash
export OPENAI_API_KEY='your-key'
python generate_dataset.py --input mlx/docs/build/text \
  --output apple-mlx-qa.jsonl --model gpt-4o \
  --repo koyeb/Apple-MLX-QA
```

### Model Inference with LoRA Adapter
```python
import torch
from peft import PeftModel
from transformers import AutoModelForCausalLM, AutoTokenizer

model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-3.1-8B-Instruct", torch_dtype=torch.bfloat16
)
tokenizer = AutoTokenizer.from_pretrained(
    "meta-llama/Llama-3.1-8B-Instruct"
)
model = PeftModel.from_pretrained(
    model, "koyeb/Meta-Llama-3.1-8B-Instruct-Apple-MLX-Adapter"
).to("cuda")

ids = tokenizer.apply_chat_template(
    [
        {"role": "system", "content": "You are a helpful AI assistant..."},
        {"role": "user", "content": "How do you transpose a matrix?"}
    ],
    tokenize=True,
    add_generation_prompt=True,
    return_tensors="pt"
).to("cuda")

output = model.generate(input_ids=ids, max_new_tokens=256,
                        temperature=0.5)
print(tokenizer.decode(output.tolist()[0][len(ids):]))
```

### Production Deployment
```bash
curl https://YOUR-SERVICE-URL.koyeb.app/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "Expert MLX assistant..."},
      {"role": "user", "content": "How to transpose?"}
    ],
    "temperature": 0.3
  }'
```
