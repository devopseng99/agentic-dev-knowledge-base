---
title: "Agent Factory Recap: A Deep Dive into Agent Evaluation, Practical Tooling, and Multi-Agent Systems"
url: "https://dev.to/googleai/agent-factory-recap-a-deep-dive-into-agent-evaluation-practical-tooling-and-multi-agent-systems-4pbj"
author: "Qingyue Wang"
category: "LLM agent evaluation"
---

# Agent Factory Recap: A Deep Dive into Agent Evaluation, Practical Tooling, and Multi-Agent Systems

**Author:** Qingyue Wang (Google AI)
**Published:** January 8, 2026

## Overview
This article addresses agent evaluation using Google's Agent Development Kit (ADK) and Vertex AI. Unlike traditional software testing (deterministic), agent evaluation resembles job performance reviews -- assessing autonomy, reasoning, tool use, and ability to handle unpredictable situations.

## Key Concepts

### Four Evaluation Layers
1. **Final Outcome:** Achievement of goals with focus on coherence, accuracy, and safety
2. **Chain of Thought:** Verification that agent breaks tasks into logical steps with consistent reasoning
3. **Tool Utilization:** Correct tool selection, proper parameters, efficiency (avoiding redundant API loops)
4. **Memory and Context Retention:** Information recall and conflict resolution capabilities

### Three Evaluation Methods
- **Ground Truth Checks:** Fast, cost-effective, objective but cannot capture nuance
- **LLM-as-a-Judge:** Scalable for subjective qualities but limited by model biases
- **Human-in-the-Loop:** Gold standard but slowest and most expensive

Recommended strategy: combine all three in a calibration loop.

### 5-Step Agent Evaluation Loop with ADK
1. Test and Define the "Golden Path" with test cases
2. Evaluate and Identify Failures
3. Find Root Cause using Trace view for step-by-step reasoning
4. Fix the Agent based on identified issues
5. Validate the Fix with hot-reload re-evaluation

### Three-Tier Testing Framework
- **Tier 1 (Unit Tests):** Isolated testing of smallest agent components
- **Tier 2 (Integration Tests):** Complete agent evaluation on multi-step journey tasks
- **Tier 3 (End-to-End Human Review):** Domain expert evaluation of final outputs

### Multi-Agent Evaluation Challenge
Single-agent evaluation is insufficient for multi-agent systems. Example: Agent A gathers information and hands off to Agent B. Evaluating Agent A alone may show zero completion despite successful delegation. System-level evaluation must measure handoff smoothness, context sharing, and collaboration.

### Cold Start Problem: Synthetic Data Generation
1. Generate realistic user tasks via LLM
2. Create perfect step-by-step expert solutions
3. Generate flawed attempts from weaker agents
4. Score automatically using LLM-as-a-judge comparing attempts against solutions
