---
title: "From RAG to Multi-Agent AI for Job Matching"
url: "https://dev.to/reebow/from-rag-to-multi-agent-ai-for-job-matching-5d66"
author: "Tim Rutana"
category: "hackathons"
---

# From RAG to Multi-Agent AI for Job Matching
**Author:** Tim Rutana
**Published:** June 23, 2025

## Overview
A four-agent job matching system built for the Google ADK Hackathon using Java ADK on Google Cloud Run with Vertex AI and Gemini 2.0.

## Key Concepts
### Four-Agent Architecture
1. **SummarizeAgent** - Extracts resume data, prioritizes career goals over experience
2. **SearchAgent** - Queries Firebase database, constrained to prevent hallucination
3. **ScoringAgent** - Analyzes aspiration fit, skill fit, experience fit
4. **MatchmakerAgent** - Filters scores >70, ranks results, delivers personalized Markdown report

Orchestrated via SequentialAgent. Uses Google Stitch for UI mockups fed to Gemini for frontend code generation.

### GitHub Repository
- https://github.com/reebow/jobmatchai
