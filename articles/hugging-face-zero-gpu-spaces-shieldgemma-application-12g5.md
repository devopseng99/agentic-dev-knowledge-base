---
title: "Hugging Face Zero GPU Spaces: ShieldGemma Application"
url: "https://dev.to/pi19404/hugging-face-zero-gpu-spaces-shieldgemma-application-12g5"
author: "Prashant Iyenga"
category: "huggingface-llm-agents"
---
# Hugging Face Zero GPU Spaces: ShieldGemma Application
**Author:** Prashant Iyenga  **Published:** September 9, 2024

## Overview
This article explains Hugging Face's ZeroGPU feature, a beta hardware option enabling efficient GPU allocation for Gradio applications. The author demonstrates implementing ShieldGemma2 (a content safety model) across private and public Spaces, with techniques for managing rate limits through IP token caching.

## Key Concepts
- ZeroGPU Architecture — uses Nvidia A100 GPUs (40GB vRAM) with dynamic allocation/release rather than persistent assignment
- Decorator Pattern — `@spaces.GPU` marks functions requiring GPU access
- Rate Limiting — platform uses `X-IP-Token` headers to prevent single-user GPU hogging
- Client Caching — LRU cache stores up to 15 Gradio clients per unique IP token
- Duration Configuration — adjustable GPU time limits (default 60s) to optimize queue priority

## Code Examples

### GPU Decorator
```python
import spaces

@spaces.GPU
def my_inference_function(input_data, output_data, mode, max_length,
                         max_new_tokens, model_size):
    # function implementation
    pass
```

### Gradio Client Connection
```python
from gradio_client import Client

API_TOKEN = os.getenv("API_TOKEN")
client = Client("pi19404/ai-worker", hf_token=API_TOKEN)
result = client.predict(
    input_data="Hello!!",
    output_data="Hello!!",
    mode="scoring",
    max_length=150,
    max_new_tokens=1024,
    model_size="2B",
    api_name="/my_inference_function"
)
print(result)
```

### Client Caching with IP Token
```python
from collections import OrderedDict

client_cache = OrderedDict()
MAX_CACHE_SIZE = 15
default_client = Client("pi19404/ai-worker", hf_token=API_TOKEN)

def get_client_for_ip(ip_address, x_ip_token):
    if x_ip_token is None:
        x_ip_token = ip_address

    if x_ip_token in client_cache:
        client_cache.move_to_end(x_ip_token)
        return client_cache[x_ip_token]

    new_client = Client("pi19404/ai-worker", hf_token=API_TOKEN,
                       headers={"X-IP-Token": x_ip_token})

    if len(client_cache) >= MAX_CACHE_SIZE:
        client_cache.popitem(last=False)
    client_cache[x_ip_token] = new_client

    return new_client
```

### Gradio Interface with Session State
```python
import gradio as gr

with gr.Blocks() as demo:
    gr.Markdown("## LLM Safety Evaluation")
    client = gr.State()

    with gr.Tab("ShieldGemma2"):
        input_text = gr.Textbox(label="Input Text")
        mode_input = gr.Dropdown(choices=["scoring", "generative"],
                                label="Prediction Mode")
        model_size_input = gr.Dropdown(choices=["2B", "9B", "27B"],
                                      label="Model Size")
        response_text = gr.Textbox(label="Output Text", lines=10)
        text_button = gr.Button("Submit")

        text_button.click(fn=my_inference_function,
                         inputs=[client, input_text, mode_input, model_size_input],
                         outputs=response_text)

    demo.load(set_client_for_session, None, client)

demo.launch(share=True)
```

### GPU Duration Configuration
```python
@spaces.GPU(duration=20)
def generate(prompt):
    return pipe(prompt).images
```
