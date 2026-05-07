---
title: "I Built an Open Source LLM Agent Evaluation Tool That Works with Any Framework"
url: "https://dev.to/hemankumar6/i-built-an-open-source-llm-agent-evaluation-tool-that-works-with-any-framework-55h"
author: "hemanth kumar"
category: "LLM agent evaluation"
---

# I Built an Open Source LLM Agent Evaluation Tool That Works with Any Framework

**Author:** hemanth kumar
**Published:** April 2, 2026

## Overview
EvalForge is a framework-agnostic LLM agent evaluation harness that normalizes agent execution across frameworks (LangChain, CrewAI, AutoGen, OpenAI Agents SDK) into a standardized JSON structure, scores on quality metrics, and returns pass/fail results. Core written in Rust with Python and JavaScript SDKs.

## Key Concepts

### Scoring Metrics (v0.7)
- faithfulness, tool_accuracy, goal_completion, hallucination
- g_eval (custom rubrics), context_precision, answer_relevance

### Installation and Usage

```bash
pip install evalforge
evalforge run --trace my_trace.json --metrics faithfulness
```

```bash
npm install evalforge
```

### CI/CD Integration

```yaml
- name: Evaluate agent quality
  run: evalforge run --trace agent_run.json --metrics faithfulness
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

### Python Framework Adapter

```python
from evalforge.adapters import from_langchain
import evalforge

result = agent.invoke({"input": "Your question"})
trace = from_langchain(result, model="gpt-4o")
eval_result = evalforge.run(trace, metrics=["faithfulness"])
print(eval_result.passed)
```

### TypeScript Usage

```typescript
import { fromMastra, run } from 'evalforge';

const trace = fromMastra(result, { agentName: 'my-agent' });
const evalResult = run(trace, { metrics: ['faithfulness'] });
```

### Features
- Full audit logs with judge model, threshold, and timestamps
- RunTrendAnalyzer detecting performance regression across runs
- Exit codes (0=pass, 1=fail) for pipeline integration

GitHub: https://github.com/heManKuMAR6/evalforge (MIT License)
