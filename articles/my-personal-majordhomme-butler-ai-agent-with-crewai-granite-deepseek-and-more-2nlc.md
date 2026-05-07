---
title: "My personal majordhomme (butler) AI agent with CrewAI, Granite, DeepSeek and more"
url: "https://dev.to/aairom/my-personal-majordhomme-butler-ai-agent-with-crewai-granite-deepseek-and-more-2nlc"
author: "Alain Airom"
category: "deepseek-ai-agent"
---

# My personal majordhomme (butler) AI agent with CrewAI, Granite, DeepSeek and more

**Author:** Alain Airom (Ayrom)
**Published:** March 16, 2025

## Overview
A personal AI agent project built using CrewAI framework with multiple language models (DeepSeek R1, IBM Granite) that detects keywords in conversations to offer contextual services like weather forecasting and image analysis.

## Key Concepts

### Models Used
- DeepSeek R1 for general conversation
- IBM Granite 3.2 2B for tool execution
- IBM Granite Vision 3.2 2B for image analysis

### Setup
```bash
python3.12 -m venv crewai_env
source crewai_env/bin/activate
```

**Dependencies:** streamlit, crewai, python-dotenv, requests, huggingface_hub, Pillow, spacy, langchain_community, langchain, langchain_huggingface

### Environment Variables
```bash
OPENWEATHERMAP_API_KEY="YOUR_KEY"
HUGGINGFACE_API_TOKEN="YOUR_TOKEN"
OPENAI_API_KEY="dummy_key"
```

### Agent Architecture
Three crew members handle different responsibilities:
1. General question answering
2. Weather forecasting via OpenWeatherMap API
3. Image analysis via Granite Vision

The system uses sequential processing and spaCy NER to detect city names in responses, proactively offering weather information when relevant. The Streamlit-based UI provides an interactive chat interface.
