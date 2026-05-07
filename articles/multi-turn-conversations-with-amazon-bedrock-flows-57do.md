---
title: "Multi-turn Agent conversations with Amazon Bedrock Flows"
url: "https://dev.to/aws/multi-turn-conversations-with-amazon-bedrock-flows-57do"
author: "Laura Salinas"
category: "multi-turn-conversation"
---

# Multi-turn Agent conversations with Amazon Bedrock Flows

**Author:** Laura Salinas
**Published:** March 20, 2025

## Overview
Demonstrates building multi-turn conversation agents using Amazon Bedrock Flows, which provides a drag/drop GUI to create, test and deploy workflows for AI applications supporting prompts, knowledge bases, guardrails, and agents.

## Key Concepts
- Agent node can pause flow execution and request missing data from the user
- Foundation model: Claude 3.5 Sonnet v2
- Lambda-backed action groups for flight search and booking
- Prompt node for intent classification (temperature 0.1 for determinism)
- Condition node for routing between travel booking vs destination info paths

### Travel Agent Architecture
1. **Prompt Node (user_intent):** Classifies queries as travel booking (A) or destination info (B)
2. **Condition Node (Book_or_Questions):** Routes based on classification
3. **Prompt Node (travel_guide):** Provides destination information
4. **Agent Node:** Integrates pre-created travel agent for flight bookings
5. **Flow Output Nodes:** Terminal endpoints for both pathways

Console-based configuration walkthrough, no executable code examples.
