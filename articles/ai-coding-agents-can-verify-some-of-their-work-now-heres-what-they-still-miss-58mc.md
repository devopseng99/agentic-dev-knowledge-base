---
title: "AI Coding Agents Can Verify Some of Their Work Now. Here's What They Still Miss."
url: "https://dev.to/moonrunnerkc/ai-coding-agents-can-verify-some-of-their-work-now-heres-what-they-still-miss-58mc"
author: "Brad Kinnard"
category: "agent-research-testing"
---
# AI Coding Agents Can Verify Some of Their Work Now. Here's What They Still Miss.
**Author:** Brad Kinnard  **Published:** April 9, 2026

## Overview
Examines the verification capabilities of modern AI coding agents like Copilot and Claude Code, highlighting self-verification improvements while identifying critical gaps in quality assurance that remain unaddressed.

## Key Concepts
1. **Agent Self-Verification Limitations** — Agents successfully verify builds and tests pass, but overlook accessibility, responsive design, dark mode support, and configuration externalization
2. **Swarm Orchestrator Solution** — A multi-agent orchestration tool that adds independent quality gates beyond what individual agents check, enforcing 16 web-app criteria or 6 baseline criteria
3. **Multi-Tool Adapter Support (v4.2.0)** — Routes code generation through different AI platforms (Copilot CLI, Claude Code, Claude Code Teams) with unified process supervision
4. **OWASP ASI Compliance Mapping** — Formal assessment of 6 out of 10 agentic application risks, including prompt injection, improper output handling, and unreliable execution
5. **Failure Classification** — Distinguishes between build failures, test failures, missing artifacts, dependencies, and timeouts, enabling targeted repair prompts

## Code Examples

```bash
swarm run --goal "Add auth" --tool copilot
swarm run --goal "Add auth" --tool claude-code-teams --team-size 3
swarm report --latest --stdout
```
