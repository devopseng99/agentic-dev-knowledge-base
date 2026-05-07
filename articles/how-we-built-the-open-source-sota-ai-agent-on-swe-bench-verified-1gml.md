---
title: "How We Built the Open-Source SOTA AI Agent on SWE-bench Verified"
url: "https://dev.to/refact/how-we-built-the-open-source-sota-ai-agent-on-swe-bench-verified-1gml"
author: "Oleg Klimov"
category: "swe-bench"
---

# How We Built the Open-Source SOTA AI Agent on SWE-bench Verified

**Author:** Oleg Klimov (Refact AI)
**Published:** May 22, 2025

---

## Overview

Refact.ai achieved state-of-the-art performance on SWE-bench Verified, solving 349 out of 500 tasks (69.8% success rate). The solution demonstrates that sophisticated guardrails and specialized sub-agents can create reliable autonomous coding systems.

## Key Technical Components

### Model Architecture
- **Orchestration:** Claude-3.7
- **Debug sub-agent:** Claude-3.7 + o4-mini
- **Planning tool:** o3
- **Temperature:** 0 across all models
- **Evaluation:** pass@1 (single attempt per task)

### Core Agent Strategy

The simplified four-step workflow replaced a more complex previous version:

1. **Explore** - Use file inspection and semantic search tools
2. **Reproduce** - Create test scripts and identify issues using `debug_script()`
3. **Plan & Fix** - Apply `strategic_planning()` then implement solutions
4. **Validate** - Run tests to verify fixes

### The Debug Sub-Agent

The `debug_script()` tool represents a specialized component that leverages Python's pdb debugger. It operates independently to:

> "gather key issue details: which files are affected, what caused the failure, and how it might be fixed"

This sub-agent forces structured investigation rather than allowing the main model to skip debugging entirely.

### Strategic Planning Tool

The `strategic_planning()` function uses o3-powered reasoning to evaluate the `debug_script()` report and refine solutions before implementation. It's limited to one call per task to manage computational costs.

## Guardrails & Constraints

Automatic helper messages intervene when the model exhibits signs of going off-track. Examples include:

**Post-debug reminder:**
```
Open all visited files using cat(file1,file2,file3,...)!
```

**Post-planning reminder:**
```
Now implement the solution above.

Reminders:
- Do not create documents, README.md, or other files non-related to fixing
- Convert generated changes into update_textdoc() or create_textdoc() calls
- Change the project directly but do not modify existing tests
```

**Flow guardrails:**
- Enforce `debug_script()` over direct shell execution
- Limit debugging to three attempts maximum
- Require `strategic_planning()` before modifications

## Tool Improvements

Refinements from the previous SWE-bench Lite run (59.7%):

| Previous | Updated |
|----------|---------|
| `definition()` | `search_symbol_definition()` |
| `references()` | `search_symbol_usages()` |
| `regex_search()` | `search_pattern()` |
| `search()` | `search_semantic()` |
| `deep_analysis()` | `strategic_planning()` |

Additional fixes included AST parsing improvements, proper index-wait mechanisms, and line-number tracking for retrieval tools.

## What Didn't Work

Several approaches were tested and abandoned:

- **Separate critique tool** - The model performed better simply running tests
- **Four-step planning flow** - Overcomplicated basic tasks; single-step solution generation works better
- **pdb() without sub-agent** - Models preferred shell commands; dedicated sub-agents improved reliability
- **No sub-agents** - Context degradation caused instruction-following failures

## Results by Repository

| Repository | Score |
|-----------|-------|
| scikit-learn | 28/32 (87.5%) |
| pytest | 16/19 (84.21%) |
| pydata/xarray | 18/22 (81.82%) |
| django | 165/231 (71.43%) |
| sympy | 54/75 (72.0%) |
| mwaskom/seaborn | 0/2 (0.0%) |

Performance varied significantly across project types, with strong results on testing and data science libraries.

## Production Integration

The research directly informs Refact.ai's IDE plugins for VS Code and JetBrains. Notably, `strategic_planning()` is not called by default in production due to cost considerations -- developers can invoke it manually when deeper reasoning is needed. The guardrail mechanisms are already implemented as automatic helper messages within the product's workflow.

## Key Insight

The philosophy balances autonomy with control: "autonomous AI Agent for programming you can trust -- and control when you need to."
