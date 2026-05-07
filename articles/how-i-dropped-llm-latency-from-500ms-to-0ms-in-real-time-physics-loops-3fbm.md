---
title: "How I dropped LLM latency from 500ms to 0ms in real-time physics loops"
url: "https://dev.to/siva_ramasrk0102_c92dc/how-i-dropped-llm-latency-from-500ms-to-0ms-in-real-time-physics-loops-3fbm"
author: "siva rama"
category: "robot-navigation"
---
# How I dropped LLM latency from 500ms to 0ms in real-time physics loops
**Author:** siva rama  **Published:** April 14, 2026

## Overview
The article presents a novel architecture for integrating large language models into real-time physics simulations. Rather than having the LLM continuously direct operations (the "Brain-Pull" model), the proposed approach inverts control: the physical system maintains local autonomy with LLM consultation only when encountering novel situations.

## Key Concepts
1. **The Problem -- Brain-Pull Bottleneck:** Traditional tool-calling architectures require the LLM to micromanage every decision, causing frozen agents or simulation pauses while awaiting API responses
2. **The Solution -- Body-Push Protocol:** The Spatial Context Protocol (SCP) shifts responsibility to the body, which operates at 60fps using a local Pattern Store, queries the LLM only for unrecognized states ("cache miss"), and caches learned patterns for future reference
3. **Muscle Memory Concept:** "Brain teaches once. Muscle remembers forever" -- establishing persistent learned behaviors locally
4. **Plexa Orchestrator:** Framework managing multiple autonomous SCP bodies simultaneously without synchronization drift

## Proof of Concept
Cart-pole balancing test:
- First loop: 27 LLM calls
- Loop 17: 0 LLM calls (complete local caching)
- Final latency: 0ms; API cost: $0

GitHub (SCP): https://github.com/srk0102/SCP
GitHub (Plexa): https://github.com/srk0102/plexa
