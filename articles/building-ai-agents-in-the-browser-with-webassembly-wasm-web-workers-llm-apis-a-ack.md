---
title: "Building AI Agents in the Browser with WebAssembly (WASM) + Web Workers + LLM APIs"
url: "https://dev.to/ekwoster/building-ai-agents-in-the-browser-with-webassembly-wasm-web-workers-llm-apis-a-ack"
author: "Yevhen Kozachenko"
category: "rust-go-java-agents"
---

# Building AI Agents in the Browser with WebAssembly + Web Workers + LLM APIs
**Author:** Yevhen Kozachenko
**Published:** August 19, 2025

## Overview
Creates a browser-based AI agent using Rust compiled to WASM, running in Web Workers with LLM API integration. No backend required. Privacy-first with native-level performance.

## Key Concepts

```rust
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub async fn query_llm(prompt: String) -> Result<JsValue, JsValue> {
    let client = Client::new();
    let body = serde_json::json!({
        "model": "gpt-4",
        "messages": [{ "role": "user", "content": prompt }],
        "max_tokens": 150
    });
    let resp = client.post(api_url).bearer_auth("your-api-key").json(&body).send().await
        .map_err(|e| JsValue::from_str(&e.to_string()))?;
    let resp_text = resp.text().await.map_err(|e| JsValue::from_str(&e.to_string()))?;
    Ok(JsValue::from_str(&resp_text))
}
```

```javascript
// Web Worker integration
import init, { query_llm } from './pkg/agent.js';
self.onmessage = async (event) => {
    await init();
    const result = await query_llm(event.data);
    self.postMessage(result);
};
```
