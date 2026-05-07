---
title: "Writing System Prompts That Actually Work: The RISEN Framework for AI Agents"
url: "https://dev.to/gunnargrosch/writing-system-prompts-that-actually-work-the-risen-framework-for-ai-agents-4p94"
author: "Gunnar Grosch"
category: "agent-prompt-chaining"
---

# Writing System Prompts That Actually Work: The RISEN Framework for AI Agents

**Author:** Gunnar Grosch
**Published:** March 1, 2026

## Overview

Introduces RISEN, a structured framework for crafting system prompts that produce consistent, actionable agent outputs. Turns system prompts into behavioral contracts rather than conversational prompts.

## Key Concepts

### RISEN Components

| Component | Purpose |
|-----------|---------|
| **Role** | Defines agent expertise and specialization |
| **Instructions** | States the core task |
| **Steps** | Outlines ordered workflow |
| **Expectation** | Specifies output format and structure |
| **Narrowing** | Sets constraints and scope limits |

### RISEN Prompt Template (Incident Response)

```plaintext
# Role
You are an AWS site reliability engineer on an on-call rotation
with 10 years of experience operating production serverless workloads.

# Instructions
Perform a structured diagnosis. Identify the most likely root cause,
provide immediate mitigation steps, and recommend longer-term fixes.

# Steps
1. Parse the alert details: service, metric, threshold, duration.
2. List the top 3 most likely root causes in order of probability.
3. For each, describe evidence that would confirm or rule it out.
4. Provide immediate mitigation steps executable in under 5 minutes.
5. Recommend longer-term fixes with estimated effort.

# Expectation
Sections: Alert Summary, Probable Root Causes (ranked), Diagnostic
Steps, Immediate Mitigation, Long-Term Fixes. Include specific
metric names, CLI commands, and thresholds.

# Narrowing
- Operator has CLI access but cannot deploy code changes during incident.
- Focus on mitigation first. Restoring service is the priority.
- Do not suggest "contact AWS Support" as a first step.
- All commands should use AWS CLI v2 syntax.
```

### Blank Template

```plaintext
# Role
You are a [job title/expertise] specializing in [domain]. You have
[years of experience] with [specific technologies/tools].

# Instructions
[Core task in 1-2 sentences. What should the agent accomplish?]

# Steps
1. [First thing the agent should do]
2. [Second thing]
3. [Continue until the workflow is complete]

# Expectation
[Output format: sections, tables, code blocks, bullet points.
Specify the structure the response should follow.]

# Narrowing
- [What to exclude or ignore]
- [Scope boundaries]
- [Constraints on format, length, or approach]
```

### Best Practices
- Role specificity matters: "senior AWS security engineer specializing in serverless" outperforms generic titles
- Steps should number 3-7, representing distinct phases
- Narrowing constraints must be objectively verifiable
- Expectation sections are mandatory for multi-agent systems
- Explicitly listing what the agent should NOT do cuts hallucination rates more than positive instruction
