---
title: "AWS DevOps Agent Explained: Architecture, Setup, and Real Root-Cause Demo (CloudWatch + EKS)"
url: "https://dev.to/aws-builders/aws-devops-agent-explained-architecture-setup-and-real-root-cause-demo-cloudwatch-eks-ng7"
author: "Jatin Mehrotra"
category: "aws-agents"
---

# AWS DevOps Agent Explained: Architecture, Setup, and Real Root-Cause Demo
**Author:** Jatin Mehrotra
**Published:** December 6, 2025

## Overview
Comprehensive guide to AWS DevOps Agent launched at re:Invent 2025, functioning as an autonomous on-call engineer. Covers dual-console architecture, Agent Spaces, resource discovery, and demos investigating CloudWatch alarms and EKS pod errors.

## Key Concepts

### Architecture
- Dual-console: administrators manage Agent Spaces via AWS Console, operations teams use web app for investigations
- Agent Spaces: logical containers defining resource access boundaries
- Resource discovery: CloudFormation stack detection + resource tagging

### Capabilities
- Connects to multiple AWS accounts
- Integrates with CI/CD pipelines
- MCP server integration
- Observability platforms (Datadog)
- Identifies root causes and provides mitigation steps with rollback procedures

### Key Insight
The agent reduces Mean Time To Resolution but won't replace engineers -- it supports incident response workflows.
