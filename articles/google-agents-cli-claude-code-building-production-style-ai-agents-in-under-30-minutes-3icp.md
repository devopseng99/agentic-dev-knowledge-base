---
title: "Google Agents CLI + Claude Code: Building Production-Style AI Agents in Under 30 Minutes"
url: "https://dev.to/vivek_shetye/google-agents-cli-claude-code-building-production-style-ai-agents-in-under-30-minutes-3icp"
author: "Vivek Shetye"
category: "google-adk"
---

# Google Agents CLI + Claude Code: Building Production-Style AI Agents in Under 30 Minutes

**Author:** Vivek Shetye
**Published:** April 28, 2026
**Tags:** #devchallenge #cloudnextchallenge #googlecloud #ai

---

## Overview

The article demonstrates how Google's new Agents CLI combined with Claude Code enables developers to build multi-agent systems remarkably quickly. The author built a complete customer support team with four specialized agents in under 30 minutes.

## What Was Built

A production-style customer support system featuring four specialized AI agents:

- **Concierge Agent** -- Initial contact point, intent classification, request routing
- **Logistician Agent** -- Order status, shipping updates, inventory checks
- **Stylist Agent** -- Product recommendations, catalog discovery, personalized suggestions
- **Resolver Agent** -- Returns processing, refunds, human escalation for disputes

## Core Technology Stack

**Google ADK (Agent Development Kit)**
- Python-native framework providing agent abstractions, tool integration, session handling, and multi-agent architecture patterns

**Google Agents CLI**
- Workflow automation enabling scaffold, build, validate, and deploy operations

**Claude Code**
- Implementation accelerator that writes code, generates tests, creates evaluations, performs security audits, and assists deployment

## Development Workflow

### Phase 1: Scaffold Foundation
Google Agents CLI initializes the entire project structure with production-ready base architecture and deployment pathways -- eliminating manual boilerplate creation.

### Phase 2: Natural Language System Definition
Developers specify agent roles, responsibilities, communication patterns, human-in-the-loop workflows, memory requirements, mock data sources, and deployment targets in plain language.

### Phase 3: End-to-End Generation
Claude Code generates:
- System design specifications with agent hierarchy and routing logic
- Agent definitions, tool integrations, mock datasets, and application code
- Unit tests, integration tests, evaluation suites, and security recommendations

### Phase 4: Deployment
The system successfully:
- Containerized the application
- Pushed to Artifact Registry
- Configured IAM permissions
- Deployed to Google Cloud Run
- Created GitHub Actions CI/CD workflows enabling automated test-eval-deploy cycles

## Key Insight

> "The hardest part is no longer building AI agents. It's deciding what to build."

This represents a fundamental shift where mature tooling dramatically increases developer leverage, compressing idea-to-production timelines.

## Production Recommendations

Despite accelerated development, the author emphasizes that fast building does NOT eliminate production responsibility. Prioritize:
- Prompt injection defenses
- Adversarial evaluations
- Human oversight mechanisms
- Security hardening
- Guardrails implementation
- Comprehensive monitoring

## Target Audience

The workflow particularly benefits:
- AI engineers
- Startup founders
- Automation builders
- Developer tool creators

## Resources

**Full Code Repository:** [github.com/vivekshetye/google-adk-multi-agent-customer-support](https://github.com/vivekshetye/google-adk-multi-agent-customer-support)
