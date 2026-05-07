---
title: "AWS re:Invent 2025 - Building Intelligent Workflows with Event Driven AI (MAM327)"
url: "https://dev.to/kazuya_dev/aws-reinvent-2025-building-intelligent-workflows-with-event-driven-ai-mam327-5adn"
author: "Kazuya"
category: "aws-agents"
---

# AWS re:Invent 2025 - Building Intelligent Workflows with Event Driven AI
**Author:** Kazuya
**Published:** December 8, 2025

## Overview
Session demonstrating two patterns for integrating AI agents with event-driven architecture using EventBridge and Bedrock AgentCore: EventBridge triggering agents for customer recommendations, and agents triggering EventBridge for automated SRE triage.

## Key Concepts

### Pattern 1: EventBridge Triggering Agents
- Customer-facing agent "Gus" on AWS Amplify
- Dynamically generates SQL queries from natural language (no hardcoded SQL)
- Performs sentiment analysis to adjust recommendations
- Maintains conversation memory across turns

### Pattern 2: Agent-Triggered EventBridge
- CloudWatch alarms trigger EventBridge rules
- Lambda invokes Bedrock AgentCore
- Agent retrieves context from CloudWatch Logs
- Severity determination drives routing
- Low-severity: auto-remediation
- High-severity: SNS notifications to engineers

### Architecture
EventBridge provides: event producers, buses (default/custom/SaaS), and rules for routing. The "strangler fig pattern" gradually modernizes legacy systems.

### AgentCore Features Used
- Tools and Memory for conversation context retention
- Runtime and Identity Management for access control
- Observability for agent decision audit trails
