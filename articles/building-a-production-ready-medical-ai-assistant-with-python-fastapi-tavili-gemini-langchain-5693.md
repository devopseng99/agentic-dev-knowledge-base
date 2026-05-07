---
title: "Building a Production-Ready Medical AI Assistant with Python FastAPI, Tavili, Gemini & LangChain"
url: "https://dev.to/fonyuygita/building-a-production-ready-medical-ai-assistant-with-python-fastapi-tavili-gemini-langchain-5693"
author: "Fonyuy Gita"
category: "ai-agent-fastapi"
---

# Building a Production-Ready Medical AI Assistant with Python FastAPI, Tavili, Gemini & LangChain

**Author:** Fonyuy Gita
**Published:** September 30, 2025

## Overview
Demonstrates constructing MediCare AI, a specialized medical assistant addressing healthcare access challenges in Cameroon through bilingual support (English/French) and AI-powered analysis capabilities including medical query responses, document text extraction, lab result analysis, and medical research discovery.

## Code Examples

### Configuration Management (Python)

```python
from pydantic_settings import BaseSettings
from pydantic import Field
from langchain_google_genai import ChatGoogleGenerativeAI
from functools import lru_cache

class Settings(BaseSettings):
    google_api_key: str = Field(..., description="Google Gemini API key")
    tavily_api_key: str = Field(..., description="Tavily API key")
    host: str = Field(default="0.0.0.0")
    port: int = Field(default=8000)
    gemini_model: str = Field(default="gemini-2.0-flash-exp")
    temperature: float = Field(default=0.7, ge=0.0, le=2.0)
    max_tokens: int = Field(default=2048, ge=100, le=8192)

    class Config:
        env_file = ".env"

@lru_cache()
def load_google_llm():
    return ChatGoogleGenerativeAI(
        model=settings.gemini_model,
        google_api_key=settings.google_api_key,
        temperature=settings.temperature,
        max_output_tokens=settings.max_tokens,
        convert_system_message_to_human=True
    )
```

### Chat Chain (Python)

```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

def create_chat_chain(language: str = "en"):
    llm = load_google_llm()

    system_message = """You are MediCare AI, a medical AI assistant for Cameroon.
Your responsibilities:
- Provide accurate, evidence-based medical information
- Explain medical concepts in simple terms
- Always recommend consulting qualified healthcare professionals
IMPORTANT: You are NOT a doctor. Never provide definitive diagnoses."""

    prompt = ChatPromptTemplate.from_messages([
        ("system", system_message),
        ("user", "{user_question}")
    ])

    chain = prompt | llm | StrOutputParser()
    return chain
```

### Analysis Chain with Pydantic Output (Python)

```python
from langchain_core.output_parsers import PydanticOutputParser
from pydantic import BaseModel

class MedicalAnalysis(BaseModel):
    summary: str
    key_findings: list[str]
    recommendations: list[str]
    next_steps: list[str]

def create_analysis_chain(language: str = "en"):
    llm = load_google_llm()
    parser = PydanticOutputParser(pydantic_object=MedicalAnalysis)

    prompt = ChatPromptTemplate.from_messages([
        ("system", "You are a medical AI assistant analyzing medical records."),
        ("user", "Analyze this medical record:\n{medical_text}\n\n{format_instructions}")
    ])

    prompt = prompt.partial(format_instructions=parser.get_format_instructions())
    chain = prompt | llm | parser
    return chain
```

### Gemini Vision Service (Python)

```python
from langchain_core.messages import HumanMessage
import base64

class GeminiService:
    def __init__(self):
        self.vision_llm = load_google_vision_llm()

    def extract_text_from_image(self, image_bytes: bytes):
        image_b64 = base64.b64encode(image_bytes).decode('utf-8')

        message = HumanMessage(
            content=[
                {"type": "text", "text": "Extract ALL text from this medical document..."},
                {"type": "image_url", "image_url": f"data:image/jpeg;base64,{image_b64}"}
            ]
        )

        response = self.vision_llm.invoke([message])
        return response.content
```
