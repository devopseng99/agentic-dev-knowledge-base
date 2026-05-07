---
title: "Why I built my own Dota 2 AI coach instead of using existing ones"
url: "https://dev.to/brightgir/why-i-built-my-own-dota-2-ai-coach-instead-of-using-existing-ones-51c8"
author: "brightgir"
category: "gaming-agents"
---
# Why I built my own Dota 2 AI coach instead of using existing ones
**Author:** Victoria (brightgir)  **Published:** May 6, 2026

## Overview
Victoria developed a custom AI coaching application for Dota 2 rather than using existing solutions like Keenplay. The tool integrates with the game via GSI (Game State Integration) to provide real-time tactical advice through an overlay and supports in-game queries without alt-tabbing. Built as open-source in Go with a RAG pipeline for contextual advice.

## Key Concepts
- **Game State Integration (GSI)**: JSON data stream from Dota 2 containing hero, items, and map state — feeds live game data to the AI system
- **RAG (Retrieval-Augmented Generation) pipeline**: Contextual advice grounded in a Dota 2 knowledge base, not just raw LLM inference
- **BERT embeddings and vector search**: Powers knowledge retrieval for accurate Dota 2 mechanics lookups
- **DeepSeek LLM**: Selected for cost-efficiency and quality balance over more expensive frontier models
- **Open-source implementation in Go**: Full backend written in Go for performance and distribution ease
- **Custom prompt engineering**: Structured prompts generate Dota 2 knowledge base content
- **Real-time overlay**: Delivers advice inside the game without alt-tabbing disruption

## GitHub Repository
https://github.com/BrightGir/dota-ai-coach
