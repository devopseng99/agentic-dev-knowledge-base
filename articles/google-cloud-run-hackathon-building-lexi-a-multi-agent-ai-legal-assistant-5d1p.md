---
title: "Google Cloud Run Hackathon: Building Lexi — a Multi-Agent AI Legal Assistant"
url: "https://dev.to/audreyk/google-cloud-run-hackathon-building-lexi-a-multi-agent-ai-legal-assistant-5d1p"
author: "Audrey Kadjar"
category: "hackathons"
---

# Google Cloud Run Hackathon: Building Lexi — a Multi-Agent AI Legal Assistant
**Author:** Audrey Kadjar
**Published:** November 7, 2025

## Overview
Lexi is a multi-agent AI legal assistant that analyzes employment contracts (especially German law) by translating dense legal language into accessible insights. Built for the Google Cloud Run Hackathon.

## Key Concepts
### Six-Agent System
1. **RootOrchestratorAgent** - Manages agent coordination
2. **SequentialAgent** - Ensures ordered processing
3. **ClauseExtractorAgent** - Identifies contract clauses
4. **StandardClauseRetriever** - Accesses reference clauses via Firestore embeddings
5. **ComparisonAgent** - Detects deviations from standards
6. **RiskAnalysisAgent** - Explains potential issues in plain language

### Technical Stack
- LLMs: gemini-embedding-001, gemini-2.0-flash
- Storage: Firestore (embeddings)
- Deployment: Docker on Google Cloud Run
- Frontend: React with streamed JSON responses

### GitHub Repository
- https://github.com/AudreyKj/google-run-hackaton-2025-lexi
