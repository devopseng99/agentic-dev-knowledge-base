---
title: "Turning AWS Serverless Experience into a Claude Code Plugin"
url: "https://dev.to/gunnargrosch/turning-aws-serverless-experience-into-a-claude-code-plugin-2nha"
author: "Gunnar Grosch"
category: "serverless-agents"
---

# Turning AWS Serverless Experience into a Claude Code Plugin

**Author:** Gunnar Grosch
**Published:** February 21, 2026

## Overview
An AWS Serverless Plugin for Claude Code that encodes practitioner experience into tools Claude can utilize, covering application lifecycle, event-driven architecture, orchestration, observability, and security.

## Key Concepts

### Plugin Scope
- **Application Lifecycle:** SAM/CDK initialization, builds, deployments via MCP tools
- **Event-Driven Architecture:** Event source mappings for DynamoDB Streams, Kinesis, SQS, Kafka, S3, SNS
- **Orchestration:** Step Functions (220+ integrations) and Lambda Durable Functions
- **Observability:** Structured JSON logging with Powertools, X-Ray tracing
- **Security:** Least-privilege IAM from pre-approved templates

### Directory Structure

```
aws-serverless-plugin/
├── .claude-plugin/
│   └── plugin.json
├── .mcp.json
├── hooks/
│   └── hooks.json
├── scripts/
│   └── validate-template.sh
├── skills/
│   └── aws-serverless/
│       ├── SKILL.md
│       ├── getting-started.md
│       ├── event-sources.md
│       ├── orchestration-and-workflows.md
│       ├── observability.md
│       └── troubleshooting.md
```

### Design Decisions
1. **Encode Decisions, Not Documentation** - Focus on judgment, not parameter lists
2. **Right-Sizing SKILL.md** - Split into focused main file plus on-demand guides
3. **Tool Parameter Exactness** - Validate against actual MCP server schemas
4. **Bundle the MCP Server** - Single installation provides both skill and server
5. **Explicit Security Surface** - `--allow-write` and `--allow-sensitive-data-access` flags

### PostToolUse Hook
Automatically runs `sam validate` after template modifications.

### Agent Skills Standard
Follows the open Agent Skills standard, compatible with Cursor, Gemini CLI, GitHub Copilot, and other tools.
