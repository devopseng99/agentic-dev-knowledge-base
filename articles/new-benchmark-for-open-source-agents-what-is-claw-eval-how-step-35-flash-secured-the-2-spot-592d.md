---
title: "New Benchmark for Open-Source Agents: What is Claw-Eval? How Step 3.5 Flash Secured the #2 Spot"
url: "https://dev.to/sky_05/new-benchmark-for-open-source-agents-what-is-claw-eval-how-step-35-flash-secured-the-2-spot-592d"
author: "Sky"
category: "agent-research-testing"
---
# New Benchmark for Open-Source Agents: What is Claw-Eval? How Step 3.5 Flash Secured the #2 Spot
**Author:** Sky  **Published:** March 25, 2026

## Overview
Discusses Claw-Eval, a new evaluation framework for AI agents developed by Peking University and the University of Hong Kong. Examines why Step 3.5 Flash achieved second place, emphasizing practical task completion over theoretical knowledge.

## Key Concepts
1. **Claw-Eval Framework** — End-to-end testing of an AI Agent's ability to complete tasks in the real world; 104 real-world tasks across domains, 15 mock enterprise services with Docker sandbox isolation, human-verified results
2. **Pass³ Metric** — Tasks must pass three consecutive independent runs to count as successful; measures "dependable stability"
   - Scoring formula: `task_score = safety × (0.8 × completion + 0.2 × robustness)`
3. **Step 3.5 Flash Performance:**
   - Rank: #2 in Pass³ (56.7%)
   - Pass@3: 70.2% (tied first with GLM 5)
   - Safety score: 93.3 ±0.0 (zero variance = perfect consistency)
   - Inference speed: 100–300 tokens/second
4. **Architecture** — 196B total parameters with only 11B active (sparse MoE); Multi-Token Prediction (MTP-3) heads; approximately 1/6th cost of DeepSeek V3.2
