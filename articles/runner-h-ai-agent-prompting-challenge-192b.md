---
title: "Doctor's Assistant: AI agent that makes doctor's life easier"
url: "https://dev.to/keyr_syntax/runner-h-ai-agent-prompting-challenge-192b"
author: "keyr Syntax"
category: "healthcare-ai"
---
# Doctor's Assistant: AI agent that makes doctor's life easier
**Author:** keyr Syntax  **Published:** July 6, 2025

## Overview
Runner H "AI Agent Prompting" Challenge submission demonstrating an AI-powered oncology assistant. Accepts cancer diagnoses and retrieves current medical guidelines, delivering structured information including required diagnostics, treatment protocols, prognosis estimates, post-treatment surveillance plans, and critical medical considerations compiled into downloadable PDF documents.

## Key Concepts
- Medical AI Integration leveraging Runner H to automate guideline research for oncologists
- Guideline Synthesis referencing standard protocols (NCCN, ASCO, ESMO) with version tracking
- Structured Output organizing complex medical data into professional PDF formats
- Source Attribution: explicit citation of consulted guidelines
- Live Demo: https://runner.hcompany.ai/chat/7e5393f6-b50a-4ecb-afab-d5b4f7b208c2/share

```plaintext
You are a medical AI assistant for oncologists. The doctor
will provide a Cancer diagnosis (e.g., "Stage III breast
cancer"). Your mission is to search the latest standard
oncology guidelines (e.g., NCCN, ASCO, ESMO) online and
provide the following answers for the provided cancer
diagnosis:

1. Imaging & laboratory tests recommended for the given
diagnosis.
2. Recommended treatment options (first-line, second-line,
surgical/radiation/medical treatment options).
3. Estimated survival (prognosis) for the given cancer
patient
4. Follow-up and surveillance plan post treatment.
5. Key cautions, contraindications, or critical
considerations...
```
