---
title: "How to Add Tools to a PydanticAI Agent in 10 Min"
url: "https://dev.to/nebulagg/how-to-add-tools-to-a-pydanticai-agent-in-10-min-2d41"
author: "The Daily Agent"
category: "agent-sdks"
---

# How to Add Tools to a PydanticAI Agent in 10 Min
**Author:** The Daily Agent
**Published:** March 15, 2026

## Overview
Practical tutorial on adding weather tools to a PydanticAI agent with dependency injection, automatic tool chaining, and structured output.

## Key Concepts

```python
import httpx
from dataclasses import dataclass
from pydantic import BaseModel
from pydantic_ai import Agent, RunContext

@dataclass
class Deps:
    http_client: httpx.Client

class CityWeather(BaseModel):
    city: str
    temperature_f: float
    summary: str
    recommendation: str

agent = Agent(
    "openai:gpt-4o-mini",
    deps_type=Deps,
    output_type=CityWeather,
    instructions="You help users check weather conditions.",
)

@agent.tool
def get_coordinates(ctx: RunContext[Deps], city: str) -> str:
    response = ctx.deps.http_client.get(
        "https://geocoding-api.open-meteo.com/v1/search",
        params={"name": city, "count": 1},
    )
    data = response.json()
    result = data["results"][0]
    return f"{result['name']}: lat={result['latitude']}, lon={result['longitude']}"

@agent.tool
def get_weather(ctx: RunContext[Deps], latitude: float, longitude: float) -> str:
    response = ctx.deps.http_client.get(
        "https://api.open-meteo.com/v1/forecast",
        params={"latitude": latitude, "longitude": longitude, "current": "temperature_2m,wind_speed_10m", "temperature_unit": "fahrenheit"},
    )
    data = response.json()["current"]
    return f"Temperature: {data['temperature_2m']}F, Wind: {data['wind_speed_10m']} km/h"

result = agent.run_sync("What's the weather like in Tokyo?", deps=Deps(http_client=httpx.Client()))
```
