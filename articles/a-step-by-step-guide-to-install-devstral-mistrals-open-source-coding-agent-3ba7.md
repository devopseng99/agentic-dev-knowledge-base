---
title: "A Step-By-Step Guide to Install Devstral: Mistral's Open Source Coding Agent"
url: "https://dev.to/nodeshiftcloud/a-step-by-step-guide-to-install-devstral-mistrals-open-source-coding-agent-3ba7"
author: "Aditi Bindal"
category: "mistral-ai-agent"
---

# A Step-By-Step Guide to Install Devstral: Mistral's Open Source Coding Agent

**Author:** Aditi Bindal
**Published:** May 22, 2025

## Overview
Devstral is an agentic LLM fine-tuned on Mistral Small 3.1 for real-world software engineering tasks, scoring 46.8% on SWE-Bench Verified. This guide covers installation, serving the model with vLLM, running inference, and building a demo RGB Color Mixer app.

## Key Concepts

### Prerequisites
- GPUs: 1x H100 or 2x RTXA6000
- Disk Space: 100 GB
- RAM: At least 80 GB
- Anaconda set up

### Environment Setup

```bash
conda create -n devstral python=3.11 && conda activate devstral
pip install vllm --upgrade
python -c "import mistral_common; print(mistral_common.__version__)"
```

### Serve with vLLM

```bash
vllm serve mistralai/Devstral-Small-2505 --tokenizer_mode mistral --config_format mistral --load_format mistral --tool-call-parser mistral --enable-auto-tool-choice --tensor-parallel-size 1
```

### Inference Script

```python
import requests
import json
from huggingface_hub import hf_hub_download

url = "http://localhost:8000/v1/chat/completions"
headers = {"Content-Type": "application/json", "Authorization": "Bearer token"}

model = "mistralai/Devstral-Small-2505"

def load_system_prompt(repo_id: str, filename: str) -> str:
    file_path = hf_hub_download(repo_id=repo_id, filename=filename)
    with open(file_path, "r") as file:
        system_prompt = file.read()
    return system_prompt

SYSTEM_PROMPT = load_system_prompt(model, "SYSTEM_PROMPT.txt")
prompt = '''
Create a minimal but complete HTML + JavaScript web application contained in a single index.html file.
The app should have three sliders labeled Red, Green, and Blue, each allowing users to select values from 0 to 255.
'''

messages = [
    {"role": "system", "content": SYSTEM_PROMPT},
    {
        "role": "user",
        "content": [
            {
                "type": "text",
                "text": prompt,
            },
        ],
    },
]

data = {"model": model, "messages": messages, "temperature": 0.15}

response = requests.post(url, headers=headers, data=json.dumps(data))
print(response.json()["choices"][0]["message"]["content"])
```
