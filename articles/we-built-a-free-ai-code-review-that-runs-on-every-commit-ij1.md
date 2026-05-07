---
title: "We Built a Free AI Code Review That Runs on Every Commit"
url: "https://dev.to/shrsv/we-built-a-free-ai-code-review-that-runs-on-every-commit-ij1"
author: "Shrijith Venkatramana"
category: "ai-code-review-agent"
---

# We Built a Free AI Code Review That Runs on Every Commit

**Author:** Shrijith Venkatramana
**Published:** February 21, 2026

## Overview
Introduces git-lrc, an open-source AI code review tool that hooks directly into `git commit`, displaying diffs in a GitHub-style interface with inline AI comments, severity tags, and change summaries.

## Key Concepts

### Problem
AI tools like Copilot increased development velocity but created a gap: AI generates large diffs that look reasonable, compile, and pass tests, but hide subtle issues -- removed validation checks, relaxed constraints, dropped edge cases, expensive cloud calls, or sensitive data in logs.

### Solution
git-lrc hooks into `git commit` as the natural anchor point of developer responsibility.

### Three-Option Workflow
1. **Review** - Run AI analysis on staged diffs
2. **Vouch** - Skip AI and take personal responsibility
3. **Skip** - Neither review nor vouch

### Features
- Iteration tracking: commits record review cycles and coverage percentages in git log
- AI-workflow integration: copy flagged issues back to AI agent for fixes
- Only staged diffs analyzed; no full repository uploads or data retention
- Free: 60-second installation via curl; uses user's own Gemini API key

**Source:** HexmosTech/git-lrc on GitHub
