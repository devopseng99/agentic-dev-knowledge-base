---
title: "How to remove Surfaced with Azure OpenAI in Copilot Studio Agent Response"
url: "https://dev.to/ktskumar/how-to-remove-surfaced-with-azure-openai-in-copilot-studio-agent-response-4m8c"
author: "Shantha Kumar T"
category: "cloud-agents"
---

# How to remove "Surfaced with Azure OpenAI" in Copilot Studio Agent Response
**Author:** Shantha Kumar T
**Published:** March 4, 2025

## Overview
Tutorial on removing the "Surfaced with Azure OpenAI" or "AI-generated content may be incorrect" attribution message from Copilot Studio agent responses using variable storage and manual message transmission.

## Key Concepts

### Steps to Remove Attribution
1. Add Generative Answers action to a topic with knowledge sources configured
2. Expand Advanced properties:
   - Uncheck "Send a message"
   - Select "Text only" for Save LLM response
   - Create a variable (e.g., `varAnswer`) in "Save bot response as"
3. Add a new "Send a Message" action using the formula: `Topic.varAnswer`
4. Save and test the topic

### Result
The response displays without the attribution disclaimer, presenting only the AI-generated content directly to users. The approach uses variable interception to bypass the default attribution footer.
