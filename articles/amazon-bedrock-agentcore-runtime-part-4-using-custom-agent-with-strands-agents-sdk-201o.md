---
title: "Amazon Bedrock AgentCore Runtime - Part 4 Using Custom Agent with Strands Agents SDK"
url: "https://dev.to/aws-heroes/amazon-bedrock-agentcore-runtime-part-4-using-custom-agent-with-strands-agents-sdk-201o"
author: "Vadym Kazulkin"
category: "aws-agents"
---

# Amazon Bedrock AgentCore Runtime - Part 4 Using Custom Agent with Strands Agents SDK
**Author:** Vadym Kazulkin
**Published:** September 8, 2025

## Overview
Transitioning from AgentCore Starter Toolkit to Custom Agent approach with FastAPI and Docker for complete control over the HTTP interface while deploying to AgentCore Runtime. Covers FastAPI setup, Dockerization for ARM64, ECR push, and deployment scripts.

## Key Concepts

### FastAPI Custom Agent

```python
app = FastAPI(title="Custom Strands Agent Server", version="1.0.0")

class InvocationRequest(BaseModel):
    input: Dict[str, Any]

class InvocationResponse(BaseModel):
    output: Dict[str, Any]

@app.post("/invocations", response_model=InvocationResponse)
async def invoke_agent(request: InvocationRequest):
    ...

@app.get("/ping")
async def ping():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
```

### Dockerfile (ARM64)

```dockerfile
FROM --platform=linux/arm64 ghcr.io/astral-sh/uv:python3.13-bookworm-slim
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY agentcore_runtime_custom_agent_demo.py ./
COPY agent_core_utils.py ./
EXPOSE 8080
CMD ["opentelemetry-instrument", "uvicorn", "agentcore_runtime_custom_agent_demo:app", "--host", "0.0.0.0", "--port", "8080"]
```

### Deploy to AgentCore Runtime

```python
import boto3
client = boto3.client('bedrock-agentcore-control')
response = client.create_agent_runtime(
    agentRuntimeName='strands_custom_agent',
    agentRuntimeArtifact={
        'containerConfiguration': {
            'containerUri': '{YOUR_ECR_REPO_URI}'
        }
    },
    networkConfiguration={"networkMode": "PUBLIC"},
    roleArn='{YOUR_IAM_ROLE_ARN}'
)
```

### Invoke Deployed Agent

```python
agent_core_client = boto3.client('bedrock-agentcore')
payload = json.dumps({"input": {"prompt": "Give me the information about order with id 1"}})
response = agent_core_client.invoke_agent_runtime(
    agentRuntimeArn="{YOUR_RUNTIME_ARN}",
    qualifier="DEFAULT",
    payload=payload
)
```
