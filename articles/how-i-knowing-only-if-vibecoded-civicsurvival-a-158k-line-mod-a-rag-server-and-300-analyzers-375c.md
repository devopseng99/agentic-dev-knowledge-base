---
title: "How I, knowing only IF, vibecoded CivicSurvival: a 158K-line mod, a RAG server, and 300 analyzers"
url: "https://dev.to/valentyn_kurchenkohai_7f/how-i-knowing-only-if-vibecoded-civicsurvival-a-158k-line-mod-a-rag-server-and-300-analyzers-375c"
author: "valentyn_kurchenkohai_7f"
category: "gaming-agents"
---
# How I, knowing only IF, vibecoded CivicSurvival: a 158K-line mod, a RAG server, and 300 analyzers
**Author:** Valentyn Kurchenko-Hai  **Published:** May 6, 2026

## Overview
A developer with no formal programming background describes building a massive mod for Cities: Skylines II using AI as a primary development tool. The project involved 158,583 lines of C# code generated over ~3 months of net development time, supported by custom infrastructure including a RAG server, 300+ Roslyn analyzers, and structured AI-assisted auditing methodologies. Demonstrates the frontier of AI-assisted game modding and agent-driven software development.

## Key Concepts
- **"Vibecoding"**: Using AI as a primary coding tool without deep language syntax knowledge, balanced with architectural discipline and validation systems
- **DOTS/ECS Architecture**: Unity's Data-Oriented Technology Stack requiring specific patterns — 542 ECS systems implemented
- **CivicRAG**: Custom MCP (Model Context Protocol) server for semantic code navigation and system relationship mapping
- **Roslyn Analyzers**: 300+ custom compiler rules enforcing architectural patterns at build-time (CIVIC051, CIVIC310, etc.)
- **Semantic Threat Modeling (STM)**: Agent-based code auditing examining system boundaries, execution order, and race conditions
- **Game Design**: Total conversion adding survival mechanics (blackouts, corruption, cognitive warfare) to peaceful city-builder
- **Scale**: 158,583 lines of C#, 31,219 lines TypeScript/React, 369 UI components, 2,503 Git commits, ~9,700 audit findings

## Key Statistics
- 158,583 lines of C# (out of 700,000 generated — most discarded)
- 31,219 lines of TypeScript/React frontend
- 542 ECS systems
- 369 UI components
- 300+ custom Roslyn analyzers
- 2,503 Git commits
- ~9,700 audit findings across project history
- 895 commits in peak month (March 2026)
