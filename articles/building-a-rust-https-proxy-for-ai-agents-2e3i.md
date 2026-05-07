---
title: "Building a Rust HTTPS Proxy for AI Agents"
url: "https://dev.to/jonathanfishner/building-a-rust-https-proxy-for-ai-agents-2e3i"
author: "Jonathan Fishner"
category: "rust-go-java-agents"
---

# Building a Rust HTTPS Proxy for AI Agents
**Author:** Jonathan Fishner
**Published:** March 19, 2026

## Overview
OneCLI's HTTPS MITM proxy in Rust intercepts agent API calls, decrypts credentials from encrypted vault, injects into headers, forwards requests. Chosen for zero GC pauses (<1ms overhead), memory safety for secrets handling, and Tokio/Hyper/Rustls ecosystem.

## Key Concepts

```rust
let listener = TcpListener::bind("0.0.0.0:10255").await?;
loop {
    let (stream, addr) = listener.accept().await?;
    let vault = vault.clone();
    tokio::spawn(async move {
        if let Err(e) = handle_connection(stream, addr, vault).await {
            tracing::error!(%addr, error = %e, "connection failed");
        }
    });
}
```

### Dynamic Certificate Generation
```rust
fn generate_cert_for_host(ca_key: &PrivateKey, ca_cert: &Certificate, hostname: &str) -> Result<CertifiedKey> {
    let mut params = CertificateParams::new(vec![hostname.to_string()]);
    params.is_ca = IsCa::NoCa;
    params.not_before = now_utc();
    params.not_after = now_utc() + Duration::hours(24);
    let cert = Certificate::from_params(params)?.serialize_der_with_signer(ca_cert, ca_key)?;
    // Return as rustls CertifiedKey
}
```
