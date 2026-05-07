---
title: "CodeSentinel: The AI Agent That Audits GitHub Repos for Security Threats"
url: "https://dev.to/nikhilsahni7/codesentinel-the-ai-agent-that-audits-github-repos-for-security-threats-ded"
author: "Nikhil Sahni"
category: "full-code-examples"
---

# CodeSentinel: The AI Agent That Audits GitHub Repos for Security Threats
**Author:** Nikhil Sahni
**Published:** July 6, 2025

## Overview
Autonomous security audit agent built on Runner H that performs comprehensive security audits of GitHub repositories. Detects vulnerable dependencies, OSINT community chatter, secure upgrade recommendations, and runtime/container vulnerabilities across Node, Python, Java, and other ecosystems.

## Key Concepts

### Risk Score Formula
```
Risk Score = (CVSS * 0.6) + (ExploitFound * 2) + (ActiveOSINT * 1.5)
```

### Agent Workflow
1. Ask Inputs -- GitHub repo URL, auth token, tech stack, monorepo designation
2. Understand Project Structure -- GitHub API retrieves package.json, requirements.txt, pom.xml, etc.
3. Parse All Dependencies -- Deduplicates, tags by path, handles monorepos
4. Scan for CVEs -- Queries NVD, OSV.dev, GitHub Advisory DB
5. OSINT Threat Chatter -- Scans Reddit, Hacker News, Dev.to
6. Suggest Secure Upgrades -- Uses latest registry data (npm, PyPI, Maven)
7. Generate Final Report -- Markdown, PDF, or CSV with GitHub issue creation
8. Follow-Up Options -- Email, rescan, compare previous scans

### Feature Comparison

| Feature | Naive Agents | CodeSentinel |
|---------|-------------|------------|
| Parses All Files | Stops early | Full scan |
| CVE Detection | Basic | + OSINT |
| Monorepo Support | Limited | Fully supported |
| Export Options | None | Markdown, CSV, PDF |
| Runtime + Docker CVEs | Missed | Included |
| GitHub Issue Integration | No | Auto-create |

### Real-World Test Cases
- Supabase: Parsed 6+ files, flagged outdated dependencies
- Next.js (Vercel): Detected critical CVE-2025-29927 in middleware
- Packtok (Monorepo): Parsed turbo workspaces, deduplicated lodash vulnerability
