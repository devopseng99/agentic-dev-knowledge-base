---
title: "yourcast! - personalized AI podcast app"
url: "https://dev.to/rohan140/yourcast-personalized-ai-podcast-app-3lp4"
author: "rohan"
category: "hackathons"
---

# yourcast! - personalized AI podcast app
**Author:** rohan
**Published:** November 9, 2025

## Overview
An AI-powered podcast application that curates personalized news podcasts by pulling from 200+ RSS feeds (16,000+ articles daily), deduplicating via semantic clustering, and generating 3-5 minute narrated episodes using collaborative AI agents on Google ADK.

## Key Concepts
- Multi-agent architecture using Google ADK
- Semantic clustering with google text-embedding-004
- Cosine similarity deduplication (threshold > 0.85)
- RSS feed aggregation (200+ feeds)
- Parallel text-to-speech generation (8 workers)
- Serverless: Cloud Run + Cloud SQL + Cloud Tasks
- Auto-scaling from 0 to 1000+ instances

**Live Demo:** https://yourcast-web-zprpg5fm2a-uc.a.run.app
