---
title: "How I Built ClaimSight: A 6-Agent AI Claims System with Google ADK and Gemini"
url: "https://dev.to/pramodmisra/how-i-built-claimsight-a-6-agent-ai-claims-system-with-google-adk-and-gemini-51g1"
author: "pramodmisra"
category: "domain-agents"
---

# How I Built ClaimSight: A 6-Agent AI Claims System with Google ADK and Gemini
**Author:** pramodmisra
**Published:** March 13, 2026

## Overview
ClaimSight uses Google's Agent Development Kit (ADK) to orchestrate six specialized agents powered by Gemini 2.5 Flash for insurance claims processing through voice, vision, and fraud detection.

## Key Concepts
The six agents are: Triage Agent (verifies policies), Maya (property claims with 18 tools), Alex (auto claims), Jordan (liability claims), Fraud Sentinel (11 parallel fraud detection tools), and Weather Verifier (cross-references claims against historical weather data). The fraud detection operates across three layers: visual analysis for AI-generated images, content provenance verification through C2PA credentials, and financial verification via Plaid API.

```python
# Agent definition with ADK
triage_agent = Agent(
    name="claimsight_triage",
    model="gemini-2.5-flash",
    instruction=TRIAGE_INSTRUCTIONS,
    tools=[policy_lookup],
    sub_agents=[maya_property, alex_auto, jordan_liability, fraud_sentinel, weather_verifier],
)
```

```bash
gcloud run deploy claimsight --source . --region us-central1
```
