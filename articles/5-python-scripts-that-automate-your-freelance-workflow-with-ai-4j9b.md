---
title: "5 Python Scripts That Automate Your Freelance Workflow With AI"
url: "https://dev.to/klement_gunndu/5-python-scripts-that-automate-your-freelance-workflow-with-ai-4j9b"
author: "klement Gunndu"
category: "AI workflow automation Python"
---

# 5 Python Scripts That Automate Your Freelance Workflow With AI

**Author:** klement Gunndu
**Published:** March 17, 2026

## Overview

Five Python scripts using OpenAI's structured outputs and Pydantic models to generate real client deliverables. Each runs locally with costs under $0.01 per call using gpt-4o-mini.

## Key Concepts

### Dependencies

```
pip install openai python-docx Jinja2
```

### Core Pattern

All scripts follow identical logic:
1. Define Pydantic model for output structure
2. Call `client.chat.completions.parse()` with model as response_format
3. Access validated results via `completion.choices[0].message.parsed`
4. Pipe structured data into document generators or templates

### Script 1: Project Proposal Generator

```python
from pydantic import BaseModel
from openai import OpenAI
from docx import Document

client = OpenAI()

class Milestone(BaseModel):
    name: str
    duration_days: int
    deliverables: list[str]

class Proposal(BaseModel):
    project_name: str
    executive_summary: str
    scope: list[str]
    out_of_scope: list[str]
    milestones: list[Milestone]
    total_duration_days: int
    assumptions: list[str]

def generate_proposal(brief: str, hourly_rate: float) -> Proposal:
    completion = client.chat.completions.parse(
        model="gpt-4o-mini",
        messages=[
            {
                "role": "system",
                "content": (
                    "You are a senior freelance consultant. "
                    "Generate a professional project proposal. "
                    "Be specific about deliverables. "
                    "Keep scope items measurable."
                ),
            },
            {"role": "user", "content": brief},
        ],
        response_format=Proposal,
    )
    return completion.choices[0].message.parsed
```

### The Five Scripts

1. **Project Proposal Generator** - Scope, timeline, deliverables, and pricing from descriptions
2. **Weekly Status Report** - Converts raw notes into formatted status reports
3. **Invoice Line Item Extractor** - Structures time logs into billable line items
4. **Client Email Drafter** - Professional emails using Jinja2 templates
5. **Scope Document Generator** - Formal scope documents with priorities and exclusions
