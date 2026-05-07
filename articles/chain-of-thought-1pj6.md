---
title: "Chain of Thought"
url: "https://dev.to/abhishek_gautam-01/chain-of-thought-1pj6"
author: "Abhishek Gautam"
category: "agent-chain-of-thought"
---

# Chain of Thought

**Author:** Abhishek Gautam
**Published:** August 20, 2025

## Overview
Comprehensive guide exploring Chain of Thought (CoT) prompting techniques including Zero-Shot CoT, Few-Shot CoT, Automatic CoT (Auto-CoT), AutoReason, and Chain of Draft (CoD). Part 5 of "Prompting in GPT5 Era" series.

## Key Concepts

### CoT Implementation Methods

- **Zero-Shot CoT:** Adding "Let's think step by step" to trigger reasoning without examples
- **Few-Shot CoT:** Providing worked examples showing full reasoning chains. Performs ~30% better than zero-shot
- **Auto-CoT:** Automated generation of diverse reasoning demonstrations through clustering
- **AutoReason:** Two-step framework using a stronger model for rationale generation and a cost-efficient model for the final answer
- **Chain of Draft (CoD):** Minimalist approach using only 5-word reasoning steps, achieving comparable accuracy while using as little as 7.6% of the tokens

## Code Examples

### AutoReason Template

```
# Rationale Generation (using a strong model like GPT-4)
Generate step-by-step reasoning for the following question, breaking down the problem into logical, interpretable steps.
QUESTION: {{question}}

# Final Answer Generation (using cost-efficient model)
Given the following reasoning steps, provide the final answer to the question.
REASONING STEPS: {{rationale_from_strong_model}}
QUESTION: {{original_question}}
ANSWER:
```

### CoD Prompt Example

```
Think step by step, but only keep a minimum draft for each thinking step, with 5 words at most. Return the answer at the end of the response after a separator ####.
```

### GPT-5 Context Gathering Config

```xml
<context_gathering>
   Goal: Get enough context fast. Parallelize discovery and stop as soon as you can act.
   Method:
   - Start broad, then fan out to focused subqueries.
   - In parallel, launch varied queries; read top hits per query.
   Early stop criteria:
   - You can name exact content to change.
   - Top hits converge (~70%) on one area/path.
</context_gathering>
```

### Limitations
- Requires large models (100B+ parameters)
- Generated reasoning chains may not reflect actual internal processes
- Effectiveness limited to narrow planning tasks
- Computational costs increase with detailed reasoning steps
