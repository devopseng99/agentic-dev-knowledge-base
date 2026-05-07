---
title: "Streaming AI Agent response with AWS REST Gateway and Lambda Function"
url: "https://dev.to/aws-builders/streaming-ai-agent-response-with-aws-rest-gateway-and-lambda-function-92n"
author: "szymon-szym"
category: "serverless-agents"
---

# Streaming AI Agent response with AWS REST Gateway and Lambda Function

**Author:** szymon-szym
**Published:** December 3, 2025

## Overview
AWS Lambda now supports streaming responses through API REST Gateway. This article demonstrates streaming Bedrock model responses using Rust for optimal performance with ~100ms cold starts.

## Code Examples

### Rust Lambda Main Function

```rust
mod http_handler;
use lambda_runtime::{run, service_fn, tracing, Error};
use rig_bedrock::{client::Client, completion::AMAZON_NOVA_MICRO};

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing::init_default_subscriber();
    let aws_config = aws_config::from_env().region("us-east-1").load().await;
    let aws_client = aws_sdk_bedrockruntime::Client::new(&aws_config);
    let agent = Client::from(aws_client)
        .agent(AMAZON_NOVA_MICRO)
        .preamble("be concise")
        .temperature(0.5)
        .build();
    run(service_fn(|ev| function_handler(agent.clone(), ev))).await
}
```

### Stream Processing

```rust
tokio::spawn(async move {
    while let Some(chunk_result) = bedrock_stream.next().await {
        match chunk_result {
            Ok(chunk) => match chunk {
                MultiTurnStreamItem::StreamAssistantItem(assistant_item) => {
                    match assistant_item {
                        StreamedAssistantContent::Text(text) => {
                            if tx.send_data(Bytes::from(text.text().as_bytes().to_vec()))
                                .await.is_err() { break; }
                        }
                        _ => {}
                    }
                }
                _ => {}
            },
            Err(_) => { break; }
        }
    }
});
Ok(Response::from(rx))
```

### CDK Infrastructure (TypeScript)

```typescript
const promptIntegration = new apigw.LambdaIntegration(handler, {
    responseTransferMode: apigw.ResponseTransferMode.STREAM,
});
```

The key configuration is `responseTransferMode: apigw.ResponseTransferMode.STREAM` which enables streaming.
