---
title: "Agent Factory Recap: Supercharging Agents on GKE with Agent Sandbox and Pod Snapshots"
url: "https://dev.to/googleai/agent-factory-recap-supercharging-agents-on-gke-with-agent-sandbox-and-pod-snapshots-3a5e"
author: "Shir Meir Lador for Google AI"
category: "agent-sandbox"
---

# Agent Factory Recap: Supercharging Agents on GKE with Agent Sandbox and Pod Snapshots

**Author:** Shir Meir Lador for Google AI
**Published:** April 7, 2026

## Overview
Recap from Google's Agent Factory on running AI agents on GKE with Agent Sandbox (gVisor-based kernel isolation) and Pod Snapshots (near-instant sandbox restoration). Covers ADK integration and multi-tenant security.

## Key Concepts

### GKE vs Serverless for Agents
Kubernetes becomes essential for high-scale scenarios with hundreds or thousands of agents requiring granular control over deployments. Serverless works for basic agents.

### Agent Sandbox on GKE
Uses gVisor (application kernel sandbox). When agents execute code, GKE dynamically provisions isolated pods with their own kernel, network, and file system. Strict network policies enforce isolation.

### Pod Snapshots
Saves sandbox states and near-instantly restores them, reducing startup from minutes to seconds for real-time agentic workflows.

### ADK Integration
Agent Development Kit integrates with GKE: containerize ADK agents, push to Artifact Registry, deploy to GKE within minutes.
