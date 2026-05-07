---
title: "Running a Strands Agent on Lambda to Tag Product Reviews"
url: "https://dev.to/aws-builders/running-a-strands-agent-on-lambda-to-tag-product-reviews-131o"
author: "Martyn Kilbryde"
category: "aws-agents"
---

# Running a Strands Agent on Lambda to Tag Product Reviews
**Author:** Martyn Kilbryde
**Published:** October 26, 2025

## Overview
Minimal but useful Strands agent deployed on Lambda that accepts product reviews and outputs categorized Pros/Cons tags. Includes CDK infrastructure, defensive JSON parsing, and event-driven architecture recommendations.

## Key Concepts

### The Agent

```python
from strands import Agent

SYSTEM = """You are an e-commerce review analyst. Input is a list of short customer reviews.
Rules:
1. CONSOLIDATE similar concepts into HIGH-LEVEL themes
2. AVOID specific details: dates, personal circumstances
3. FOCUS on actionable business insights
4. Maximum 8 items per list
Return ONLY minified JSON: {"pros":[],"cons":[]}
"""

def build_agent(model_id: str):
    return Agent(system_prompt=SYSTEM, model=model_id)

def summarize_reviews(agent: Agent, reviews: list[str]) -> dict:
    prompt = "REVIEWS:\n" + "\n".join(f"- {r}" for r in reviews) + "\nReturn JSON now."
    result = agent(prompt)
    import json, re
    m = re.search(r"\{.*\}", str(result), re.S)
    try:
        data = json.loads(m.group(0)) if m else {}
    except Exception:
        data = {}
    return {"pros": data.get("pros", []), "cons": data.get("cons", [])}
```

### Lambda Handler

```python
import json, os
from agent_review import build_agent, summarize_reviews

MODEL_ID = os.getenv("MODEL_ID", "anthropic.claude-3-haiku-20240307-v1:0")
AGENT = build_agent(model_id=MODEL_ID)  # Cached between invocations

def handler(event, context):
    body = json.loads(event.get("body") or "{}")
    reviews = body.get("reviews", [])
    if not reviews or not isinstance(reviews, list):
        return {"statusCode": 400, "body": json.dumps({"error": "reviews[] required"})}
    out = summarize_reviews(AGENT, reviews)
    return {"statusCode": 200, "body": json.dumps(out)}
```

### CDK Stack

```python
from aws_cdk import Duration, aws_lambda as _lambda, aws_lambda_python_alpha as lambda_python, aws_iam as iam

fn = lambda_python.PythonFunction(
    self, "AgentFn",
    entry="lambda", index="handler.py", handler="handler",
    runtime=_lambda.Runtime.PYTHON_3_13,
    architecture=_lambda.Architecture.ARM_64,
    memory_size=256, timeout=Duration.seconds(30),
    environment={"MODEL_ID": "anthropic.claude-3-haiku-20240307-v1:0"}
)

fn.add_to_role_policy(iam.PolicyStatement(
    actions=["bedrock:InvokeModel", "bedrock:InvokeModelWithResponseStream"],
    resources=["*"]
))

url = fn.add_function_url(auth_type=_lambda.FunctionUrlAuthType.NONE)
```

### Event-Driven Production Architecture
1. Reviews land in ingestion service
2. Emit EventBridge event
3. Rule triggers agent Lambda
4. Lambda writes pros/cons to cache or table
5. Frontend reads pre-computed tags
