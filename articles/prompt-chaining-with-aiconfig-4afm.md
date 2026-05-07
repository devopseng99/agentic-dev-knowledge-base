---
title: "Prompt Chaining with AiConfig"
url: "https://dev.to/ranjancse/prompt-chaining-with-aiconfig-4afm"
author: "Ranjan Dailata"
category: "agent-prompt-chaining"
---

# Prompt Chaining with AiConfig

**Author:** Ranjan Dailata
**Published:** December 9, 2023

## Overview

Demonstrates prompt chaining using AiConfig, a JSON-based configuration-driven application development framework. Shows a practical NYC Trip Planner example with sequential prompts.

## Key Concepts

### Prompt Chaining Pattern
Execute a series of prompts where each output feeds the next. The NYC Trip Planner uses two steps:

**Step 1:** Request 5 fun NYC attractions (named "get_activities")

**Step 2:** Generate itinerary and pricing using the previous output:
```
Generate an itinerary and pricing information ordered by geographic
location for these activities: {{get_activities.output}}
```

### Implementation
1. Download travel.aiconfig.json
2. Log into LastMileAI platform
3. Upload the config file to the Workbooks section
4. First prompt cell named "get_activities" serves as a reference variable
5. Second prompt produces itinerary data using template variable `{{get_activities.output}}`

### Template Variable Syntax
```
{{get_activities.output}}
```
This references the output of the "get_activities" prompt cell, enabling the chaining pattern without code.
