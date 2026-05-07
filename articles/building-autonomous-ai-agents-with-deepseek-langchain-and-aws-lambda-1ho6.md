---
title: "Building Autonomous AI Agents with DeepSeek, LangChain, and AWS Lambda"
url: "https://dev.to/sohagmahamud/building-autonomous-ai-agents-with-deepseek-langchain-and-aws-lambda-1ho6"
author: "Md. Mahamudur Rahman"
category: "deepseek-ai-agent"
---

# Building Autonomous AI Agents with DeepSeek, LangChain, and AWS Lambda

**Author:** Md. Mahamudur Rahman
**Published:** March 22, 2025

## Overview
Demonstrates combining DeepSeek, LangChain, AWS Lambda, and AWS Step Functions to build scalable intelligent automation agents capable of multi-step reasoning, real-time information retrieval, and autonomous decision-making.

## Key Concepts

### Why DeepSeek for Agents
DeepSeek is an open-source LLM with 16K token context windows, enabling multi-step reasoning and advanced NLP capabilities for structured decision-making.

### Step 1: Setting Up the Environment

```python
pip install langchain boto3 sagemaker transformers fastapi uvicorn
```

**Initialize DeepSeek Model in SageMaker:**
```python
from transformers import AutoModelForCausalLM, AutoTokenizer
import sagemaker

model_name = "deepseek-ai/deepseek-llm-7b"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)

session = sagemaker.Session()
role = sagemaker.get_execution_role()
```

### Step 2: Building an AI Agent with LangChain

```python
from langchain.llms import HuggingFacePipeline
from langchain.agents import initialize_agent, AgentType
from langchain.memory import ConversationBufferMemory

llm = HuggingFacePipeline.from_model(model_name)

memory = ConversationBufferMemory(memory_key="chat_history")

agent = initialize_agent(
    llm=llm,
    tools=[],  # Tools will be added in later steps
    agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
    memory=memory
)
```

### Step 3: Enhancing the Agent with AWS Lambda Tools

```python
import boto3, json

lambda_client = boto3.client("lambda")

def stock_price_tool(query):
    response = lambda_client.invoke(
        FunctionName="GetStockPrice",
        Payload=json.dumps({"ticker": query})
    )
    return json.loads(response["Payload"].read())["price"]

agent.add_tool(stock_price_tool, name="Stock Price Checker")
```

### Step 4: AWS Step Functions Workflow

```json
{
  "StartAt": "Receive Customer Query",
  "States": {
    "Receive Customer Query": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:customer-service-bot",
      "Next": "Classify Intent"
    },
    "Classify Intent": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:classify-intent",
      "Next": "Query DeepSeek"
    },
    "Query DeepSeek": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:deepseek-response",
      "End": true
    }
  }
}
```

### Step 5: Deploying as Serverless API

```python
from fastapi import FastAPI
import requests

app = FastAPI()

@app.get("/query")
def query_agent(text: str):
    response = requests.post("https://sagemaker-endpoint-url", json={"inputs": text})
    return response.json()
```

Deployment: Package FastAPI as Lambda, expose via API Gateway, enable inference requests from external services.
