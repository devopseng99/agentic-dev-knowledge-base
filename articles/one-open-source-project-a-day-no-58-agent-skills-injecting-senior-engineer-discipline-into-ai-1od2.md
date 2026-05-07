---
title: "One Open Source Project a Day (No. 58): Agent Skills - Injecting Senior Engineer Discipline into AI Coding Agents"
url: "https://dev.to/wonderlab/one-open-source-project-a-day-no-58-agent-skills-injecting-senior-engineer-discipline-into-ai-1od2"
author: "WonderLab"
category: "full-code-examples"
---

# Agent Skills - Injecting Senior Engineer Discipline into AI Coding Agents
**Author:** WonderLab
**Published:** May 7, 2026

## Overview
Agent Skills by Addy Osmani (Google Chrome) encodes 20 workflows enforcing senior-level engineering discipline into AI coding agents. 30,800+ stars on GitHub. Pure-text Markdown workflows compatible with Claude Code, Cursor, and similar tools.

## Key Concepts

### GitHub Repository
https://github.com/addyosmani/agent-skills

### Six-Phase Workflow

```
Define -> Plan -> Build -> Verify -> Review -> Ship
  |        |       |       |        |       |
/spec   /plan   /build   /test   /review  /ship
```

### Installation

**Claude Code Plugin:**
```
/plugin marketplace add addyosmani/agent-skills
/plugin install agent-skills@addy-agent-skills
```

**Local Clone:**
```bash
git clone https://github.com/addyosmani/agent-skills.git
claude --plugin-dir /path/to/agent-skills
```

**Reference in CLAUDE.md:**
```markdown
Load the following skills for this project:
- skills/build/incremental-implementation
- skills/verify/test-driven-development
- skills/review/code-review-and-quality
```

### Skill File Anatomy

```yaml
---
name: incremental-implementation
description: Build features in small, testable increments
triggers:
  - "start implementation"
  - "begin coding"
  - "implement feature"
---

## Overview
[Purpose and scope]

## Process
[Step-by-step workflow with deliverables]

## Rationalizations (Excuses & Rebuttals)
| Common Excuse | Why It Doesn't Hold |
|---|---|
| "The feature is simple, just write it" | Simplicity is subjective; no spec means no acceptance criteria |
| "I'll add tests afterward" | Test debt almost never gets paid back |

## Verification
[Proof required to confirm execution]
```

### Anti-Rationalization Design

| Common Excuse | Engineering Response |
|---|---|
| "This feature is simple, just write it" | Simplicity is subjective without clear acceptance criteria |
| "Tests can come later" | Test debt rarely gets repaid |
| "It's just temporary" | Average lifespan of "temporary" solutions exceeds all expectations |
| "PR is already big, adding more is fine" | Large PRs create review blind spots |

### Three Expert Personas
- code-reviewer
- test-engineer
- security-auditor

### Stats
30,800+ stars, 3,600+ forks, 162 commits, MIT license
