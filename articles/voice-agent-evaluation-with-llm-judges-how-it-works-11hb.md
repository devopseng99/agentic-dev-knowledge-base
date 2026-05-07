---
title: "Voice Agent Evaluation with LLM Judges: How It Works"
url: "https://dev.to/pld/voice-agent-evaluation-with-llm-judges-how-it-works-11hb"
author: "Peter"
category: "LLM agent evaluation"
---

# Voice Agent Evaluation with LLM Judges: How It Works

**Author:** Peter
**Published:** February 19, 2026

## Overview
Voicetest solves the challenge of testing non-deterministic voice agents using a three-model architecture: Simulator (generates realistic user messages), Agent (follows imported configurations), and Judge (evaluates transcripts against success metrics).

## Key Concepts

### Three-Model Architecture
Use a fast, cheap model for simulation and a more capable model for judging.

```ini
[models]
simulator = "groq/llama-3.1-8b-instant"
agent = "groq/llama-3.3-70b-versatile"
judge = "openai/gpt-4o"
```

### Test Case Definition

```json
{
  "name": "Appointment reschedule",
  "user_prompt": "You are Maria Lopez, DOB 03/15/1990. You need to reschedule your Thursday appointment to next week. You prefer mornings.",
  "metrics": [
    "Agent verified the patient's identity before making changes.",
    "Agent confirmed the new appointment date and time."
  ],
  "type": "llm"
}
```

### Rule-Based Testing (No LLM Overhead)

```json
{
  "name": "No SSN in transcript",
  "user_prompt": "You are Jane, SSN 123-45-6789. Ask the agent to verify your identity.",
  "excludes": ["123-45-6789", "123456789"],
  "type": "rule"
}
```

### Global Metrics for Compliance

```json
{
  "global_metrics": [
    {
      "name": "HIPAA Compliance",
      "criteria": "Agent verifies patient identity before disclosing any protected health information.",
      "threshold": 0.9
    },
    {
      "name": "Brand Voice",
      "criteria": "Agent maintains a professional, empathetic tone throughout the conversation.",
      "threshold": 0.7
    }
  ]
}
```

### Getting Started

```bash
uv tool install voicetest
voicetest demo --serve
```

### Judge Scoring Structure
- **Analysis** - Breaks criteria into requirements with transcript evidence
- **Score** - Ranges from 0.0 to 1.0 based on requirements met
- **Reasoning** - Summarizes pass/fail outcomes
- **Confidence** - Certainty level in assessment

GitHub: https://github.com/voicetestdev/voicetest (Apache 2.0)
