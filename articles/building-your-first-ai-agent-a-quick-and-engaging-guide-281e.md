---
title: "How to Build a Simple AI Agent: A Step-by-Step Guide"
url: "https://dev.to/nilavya2000/building-your-first-ai-agent-a-quick-and-engaging-guide-281e"
author: "Nilavya Das"
category: "full-code-examples"
---

# How to Build a Simple AI Agent: A Step-by-Step Guide
**Author:** Nilavya Das
**Published:** August 13, 2024

## Overview
Beginner-friendly guide to building a simple AI agent in Python with command understanding, decision making, and API integration (OpenWeatherMap).

## Key Concepts

### Command Understanding

```python
import re

def process_input(user_input):
    if re.search(r"weather", user_input.lower()):
        return "weather"
    elif re.search(r"todo", user_input.lower()):
        return "todo"
    else:
        return "unknown"
```

### Decision Making

```python
def decide_action(input_type):
    if input_type == "weather":
        return "Fetching weather data..."
    elif input_type == "todo":
        return "Adding to your to-do list..."
    else:
        return "I'm not sure how to help with that."
```

### Action Execution

```python
import requests

def get_weather():
    response = requests.get('https://api.openweathermap.org/data/2.5/weather?q=New+York&appid=your_api_key')
    weather_data = response.json()
    return f"The weather in New York is {weather_data['weather'][0]['description']}."

def execute_action(action):
    if action == "Fetching weather data...":
        return get_weather()
    else:
        return "Action not implemented."
```

### Testing

```python
user_input = input("Ask me something: ")
input_type = process_input(user_input)
action = decide_action(input_type)
response = execute_action(action)
print(response)
```
