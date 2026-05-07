---
title: "Oracle AI Agent 101: Build your first agent step-by-step"
url: "https://dev.to/halton_chen/oracle-ai-agent-101-build-your-first-agent-step-by-step-2m0b"
author: "Halton Chen"
category: "full-code-examples"
---

# Oracle AI Agent 101: Build your first agent step-by-step
**Author:** Halton Chen
**Published:** April 4, 2026

## Overview
Tutorial for building a procurement-focused AI agent using Oracle AI Agent Studio. Covers creating, configuring, testing, and deploying a custom agent for checking purchase requisition status.

## Key Concepts

### Agent Building Blocks
1. **Tools** -- Enable agents to accomplish tasks through integrations:
   - Calculator tool
   - Email tool
   - Business object tool (for structured transactional data like PR status)
   - User query tool
   - Document retrieval tool for RAG

2. **Topics** -- Define agent expertise boundaries through instructions controlling conversation scope

3. **Agent Team Configuration** -- LLM provider selection, security roles, starter questions

### LLM Model Options
- GPT-5 mini: balanced reasoning for enterprise workflows
- GPT-4.1 mini: faster and cost-efficient for high-volume
- GPT-OSS-120B: customizable for specific tuning

### Access Path
Tools -> AI Agent Studio within Oracle Cloud Applications

### Key Takeaways
- Templates reduce setup time
- Tools extend capabilities through integrations
- Topics control agent scope
- Debug feature validates before deployment
