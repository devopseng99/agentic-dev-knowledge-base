---
title: "Creating Lucy: Developing an AI-Powered Slack Assistant with Memory"
url: "https://dev.to/kuba_szw/creating-lucy-developing-an-ai-powered-slack-assistant-with-memory-134o"
author: "Kuba"
category: "ai-agent-slack-bot"
---

# Creating Lucy: Developing an AI-Powered Slack Assistant with Memory

**Author:** Kuba
**Published:** May 23, 2024

## Overview
Build an AI agent named Lucy that learns from conversations and interacts through Slack. Uses Make.com for no-code orchestration, Pinecone for vector embeddings, Airtable for memory storage, and OpenAI for reasoning. Conversation memories are distilled every 8 hours from chat history into searchable vector embeddings.

## Key Concepts

### Architecture
1. **Scenario 1 (Real-time chat):** Slack webhook -> validate event -> fetch conversation history -> embed query -> search Pinecone for relevant memories -> fetch from Airtable -> GPT completion with context -> post response
2. **Scenario 2 (Memory distillation, every 8 hours):** Fetch unsynced conversation history -> GPT distills key facts -> create memory records in Airtable -> generate embeddings -> save to Pinecone

### Memory Management
- Conversation history kept only until memories are distilled
- After distillation, only memories are used for context retrieval
- Trade-off: some information may be lost during conversion

### Workflow Steps
- Messages logged to ConversationHistory with synced=false flag
- Scheduled job processes unsynced records
- GPT extracts key facts/memories
- Vector embeddings created via OpenAI API
- Pinecone stores vectors for semantic search
- Airtable stores structured memory records
