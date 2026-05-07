---
title: "Serverless AI Agents on Civo: Replacing Docker with WebAssembly (Spin) and Rust"
url: "https://dev.to/devnotes/serverless-ai-agents-on-civo-replacing-docker-with-webassembly-spin-and-rust-20ch"
author: "Aarav Rana"
category: "rust-go-java-agents"
---

# Serverless AI Agents on Civo: Replacing Docker with WebAssembly (Spin) and Rust
**Author:** Aarav Rana
**Published:** January 17, 2026

## Overview
Compiles Rust AI agents into Wasm modules (~2.5MB binaries) deployed on Civo K3s via SpinKube. Cold starts drop from ~14.2s (Docker) to ~0.04s (WASM). Demonstrates a sentiment analysis agent using Llama 2.

## Key Concepts

```rust
use spin_sdk::http::{IntoResponse, Request, Response};
use spin_sdk::llm;

const MODEL: llm::InferencingModel = llm::InferencingModel::Llama2Chat;

fn handle_request(req: Request) -> anyhow::Result<impl IntoResponse> {
    let body = req.body();
    let input_text = str::from_utf8(body).unwrap_or("");
    let prompt = format!("Analyze the sentiment: '{}'", input_text);
    let result = llm::infer(MODEL, &prompt)?;
    Ok(Response::builder()
        .status(200)
        .header("Content-Type", "application/json")
        .body(format!(r#"{{"sentiment": "{}"}}"#, result.text.trim()))
        .build())
}
```

```bash
spin build  # 2.5MB Wasm binary
spin registry push ghcr.io/RanaAarav/CIVO-Spin-AI-Agent
kubectl apply -f k8s-deployment.yaml
```
