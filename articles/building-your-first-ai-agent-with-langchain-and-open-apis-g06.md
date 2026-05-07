---
title: "Building Your First AI Agent with LangChain and Open APIs"
url: "https://dev.to/santhoshvijayabaskar/building-your-first-ai-agent-with-langchain-and-open-apis-g06"
author: "Santhosh Vijayabaskar"
category: "langchain-tutorial"
---

# Building Your First AI Agent with LangChain and Open APIs

**Author:** Santhosh Vijayabaskar
**Date Published:** October 24, 2024 (Edited October 27, 2024)
**Tags:** #agentai #tutorial #automation #ai

---

## Overview

This tutorial introduces developers to AI agents using LangChain and demonstrates how to integrate real-time data from open APIs. The guide walks through building a weather-aware chatbot that leverages OpenAI's GPT models combined with live weather data.

## Key Concepts

### What is an AI Agent?
According to the article, "AI Agents are like a supercharged virtual assistant that's always ready to help." These systems leverage large language models like GPT-3 or GPT-4 to work autonomously, handling tasks from data retrieval to content creation and conversation.

### What is LangChain?
The tutorial describes LangChain as "a developer-friendly framework that connects AI models (like GPT-3 or GPT-4) with external tools and data." Benefits include ease of integration, scalability, and strong community support.

---

## Step-by-Step Implementation

### Step 1: Environment Setup

**Install Python packages:**
```shell
python --version
pip install langchain
pip install openai
```

**Create virtual environment:**
```shell
python -m venv langchain-env
source langchain-env/bin/activate  # Mac/Linux
# or for Windows:
langchain-env\Scripts\activate
```

### Step 2: Build Basic AI Agent

```python
from langchain.llms import OpenAI

# Initialize the model
llm = OpenAI(api_key="your-openai-api-key")

# Define a prompt for the agent
prompt = "What is the weather like in New York today?"

# Get the response from the AI agent
response = llm(prompt)
print(response)
```

### Step 3: Connect to Weather API

**Get an API key from OpenWeather and integrate live data:**

```python
import requests
from langchain.llms import OpenAI

def get_weather(city):
    api_key = "your-openweather-api-key"
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"
    response = requests.get(url).json()

    # Extract relevant data
    temp = response['main']['temp']
    description = response['weather'][0]['description']
    return f"The current temperature in {city} is {temp}C with {description}."

# Integrate with LangChain
llm = OpenAI(api_key="your-openai-api-key")
city = "New York"
weather_info = get_weather(city)
prompt = f"Tell me about the weather in {city}: {weather_info}"

response = llm(prompt)
print(response)
```

### Step 4: Deploy as API with FastAPI

```python
from fastapi import FastAPI
from langchain.llms import OpenAI
import requests

app = FastAPI()

def get_weather(city):
    api_key = "your-openweather-api-key"
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"
    response = requests.get(url).json()
    temp = response['main']['temp']
    description = response['weather'][0]['description']
    return f"The weather in {city} is {temp}C with {description}."

llm = OpenAI(api_key="your-openai-api-key")

@app.get("/ask")
def ask_question(city: str):
    weather = get_weather(city)
    prompt = f"Tell me about the weather in {city}: {weather}"
    response = llm(prompt)
    return {"response": response}
```

Access the API at: `http://localhost:8000/ask?city=New York`

---

## Key Takeaways

1. **LangChain simplifies AI integration** with external systems and APIs
2. **Live data enhances agent capabilities** beyond static language model responses
3. **FastAPI enables easy deployment** of agents as accessible web services
4. **Real-world applications** demonstrate practical utility of AI agent architecture

## Next Steps

The author suggests exploring advanced features including conversation memory management and multi-agent systems for complex task handling.
