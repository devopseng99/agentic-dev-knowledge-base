---
title: "How to Build a Simple AI Agent with Langflow and Composio"
url: "https://dev.to/datastax/how-to-build-a-simple-ai-agent-with-langflow-and-composio-13d4"
author: "melienherrera"
category: "langflow-agent"
---

# How to Build a Simple AI Agent with Langflow and Composio

**Author:** melienherrera (DataStax)
**Published:** February 10, 2025

## Overview

Tutorial demonstrating how to build an AI agent that manages Google Calendar by combining Langflow (visual low-code AI application builder) with Composio (integration platform providing access to hundreds of tools).

## Key Concepts

### Prerequisites

- DataStax Langflow account
- Composio account
- OpenAI account with API key

### Setup Steps

1. Retrieve Composio API key from dashboard
2. Navigate to Apps section, locate Google Calendar integration
3. Complete authentication through Google sign-on
4. Create new Langflow flow using "Simple Agent" template
5. Input OpenAI API key into Agent component (defaults to gpt-4o-mini)
6. Drag Composio bundle from left navigation
7. Connect to Agent component via Tool linking points
8. Configure Composio with API key and select GOOGLECALENDAR app
9. Select available actions (Create, Update, Delete, Retrieve events)

### Testing

Example query: "Can you check if I have availability for January 28, 2025 at 3pm? If it's free, schedule a meeting with Bob."

The agent determines which tools to utilize and executes calendar operations, with events appearing in the user's actual Google Calendar.
