---
title: "Create Your First Serverless Workflow with Durable Functions"
url: "https://dev.to/azure/durable-functions-stateful-long-running-functions-in-serverless-part-i-5bm"
author: "Azure"
category: "multi-cloud-durable"
---

# Create Your First Serverless Workflow with Durable Functions
**Author:** Azure
**Published:** 2019

## Overview
Introduction to Azure Durable Functions for building stateful, long-running workflows in serverless environments. Covers the orchestrator pattern, activity functions, and how the framework manages state persistence and replay.

## Key Concepts
Azure Durable Functions extends Azure Functions with stateful orchestration. The framework automatically checkpoints execution state, enabling workflows that wait for external events, run parallel tasks, and handle human interaction -- all within the serverless model. Orchestrator functions must be deterministic (same inputs produce same outputs) to support replay-based recovery after failures.
