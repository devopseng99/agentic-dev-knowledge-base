---
title: "Building a Document Reader AI Tool During My Internship at Agno"
url: "https://dev.to/hriday_patel_fc9018170287/building-a-document-reader-ai-tool-during-my-internship-at-agno-25g0"
author: "Hriday Patel"
category: "ai-agent-pdf"
---

# Building a Document Reader AI Tool During My Internship at Agno

**Author:** Hriday Patel
**Published:** August 28, 2025

## Overview
An AI-powered document processing tool built with the Agno framework that handles PDFs, CSVs, DOCX files, and images for educational document analysis.

## Key Concepts

Agno is a framework for building high-performance, multi-modal AI agents supporting text, image, audio, and video processing.

## Code Example

```python
import os
import PIL.Image
import google.generativeai as genai
from textwrap import dedent
from agno.agent import Agent
from agno.models.google import Gemini

def _config_genai():
    api_key = YOUR_API_KEY
    if not api_key:
        raise RuntimeError("Set GEMINI_API_KEY env var.")
    genai.configure(api_key=api_key)
    return genai.GenerativeModel('gemini-2.0-flash')

def get_text_from_image(file_path):
    """Extract text/description from an image using Gemini."""
    try:
        model = _config_genai()
        img = PIL.Image.open(file_path)
        resp = model.generate_content(img)
        return {"text": getattr(resp, "text", str(resp))}
    except Exception as e:
        return {"error": str(e)}

Smart_Advise_student = Agent(
    model=_gemini(),
    instructions=dedent("""
    You analyze messy text extracted from PDFs/DOCX/Images.
    Parse marks/topics, summarize performance, give topic
    explanations, classify, and recommend next steps.
    """),
)
```

### Technologies Used
- Agno AGI framework
- Google Generative AI (Gemini)
- PyPDF2 and pdfplumber
- python-docx, Pandas
- OpenCV and Tesseract OCR
