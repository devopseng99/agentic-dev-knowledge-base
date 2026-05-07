---
title: "Building LearnForge: Multi-Agent AI Learning Platform on Cloud Run with Google ADK"
url: "https://dev.to/rashikakarki/building-learnforge-multi-agent-ai-learning-platform-on-cloud-run-with-google-adk-m4b"
author: "Rashika Karki"
category: "hackathons"
---

# Building LearnForge: Multi-Agent AI Learning Platform on Cloud Run with Google ADK
**Author:** Rashika Karki
**Published:** November 8, 2025

## Overview
LearnForge uses 12 specialized AI agents on Google Cloud Run and ADK to deliver personalized educational experiences. Features DatabaseSessionService for persistent state across devices, WebSocket real-time communication, and hierarchical silent orchestration.

## Key Concepts
- Polaris (Pathfinder): Goal clarification with real-time research
- Lumina (Orchestrator): Learning execution coordinator
- Content Searcher, Video Selector, Content Formatter (SequentialAgent chain)
- Sensei (teacher), Help Desk, Greeter, Flow Briefer agents
- Cloud SQL PostgreSQL with connection pooling (10 base, 5 overflow, 60s timeout)
- Firebase Authentication, Firestore, YouTube Data API v3, Google Search API
- Gemini 2.5 Flash, multi-stage Docker builds for optimized cold starts
