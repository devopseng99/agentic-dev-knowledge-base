---
title: "Split Test AI Prompts Using Supabase & Langchain Agent"
url: "https://dev.to/grawenbh/split-test-ai-prompts-using-supabase-langchain-agent-464f"
author: "grawenbh"
category: "ai-agent-supabase"
---

# Split Test AI Prompts Using Supabase & Langchain Agent

**Author:** grawenbh
**Published:** March 28, 2026

## Overview

Describes a workflow for A/B testing different prompts for AI chatbots using Langchain and OpenAI, with Supabase for session state persistence and random assignment.

## Key Concepts

### How It Works

When a message is received, the system checks whether the session already exists in the Supabase table. If not, it randomly assigns the session to either the baseline or alternative prompt. The selected prompt feeds into a Langchain Agent using OpenAI's Chat Model, with PostgreSQL supporting multi-turn conversation memory.

### Features

- Randomized A/B split test per session
- Supabase database for session persistence
- Langchain Agent + OpenAI GPT-4o integration
- PostgreSQL memory for maintaining chat context

### Setup

Create a Supabase table named `split_test_sessions` with columns:
- session_id (text)
- show_alternative (boolean)

Add credentials for Supabase, OpenAI, and PostgreSQL. Modify the "Define Path Values" node to set baseline and alternative prompts, activate the workflow, and test both prompt paths.

### Extension Ideas

- Add tracking for conversions or feedback scores
- Modify prompt content or model settings
- Expand to multi-variant tests beyond A/B
