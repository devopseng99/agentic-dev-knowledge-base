---
title: "AI Deployment: Why Serverless is Perfect (and Terrible)"
url: "https://dev.to/gerimate/ai-deployment-why-serverless-is-perfect-and-terrible-4phl"
author: "Geri Mate"
category: "serverless-agents"
---

# AI Deployment: Why Serverless is Perfect (and Terrible)

**Author:** Geri Mate
**Published:** May 28, 2025

## Overview
A comprehensive analysis of when serverless works for AI and when it fails, covering timeout constraints, bundle size limits, cold starts, and practical mitigation strategies.

## Key Limitations

- **AWS Lambda:** 15-minute max timeout, 250MB uncompressed bundle
- **Vercel Functions:** 60s Hobby, 300s Pro, 900s Enterprise
- **Cloudflare Workers:** Unlimited wall-clock, 5-minute CPU limit, 10MB bundle
- **Cold Starts:** Up to 6.99s for Java, TensorFlow models cause 29s timeouts

## Code Examples

### Workflow Suspension and Resume

```javascript
export const analyzeInput = async (event) => {
  const analysis = await performAnalysis(event.input);
  await saveState(event.workflowId, {
    step: 'analysis', result: analysis, nextStep: 'generate'
  });
  await triggerNextStep(event.workflowId);
  return { status: 'processing', workflowId: event.workflowId };
};

export const generateContent = async (event) => {
  const state = await loadState(event.workflowId);
  const content = await generateFromAnalysis(state.result);
  await saveState(event.workflowId, { step: 'complete', finalResult: content });
  return { status: 'complete', result: content };
};
```

### Container-Based Deployment

```dockerfile
FROM public.ecr.aws/lambda/python:3.9
COPY models/ ${LAMBDA_TASK_ROOT}/models/
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app.py ${LAMBDA_TASK_ROOT}
CMD ["app.lambda_handler"]
```

### Hybrid Router Pattern

```javascript
export const aiRouter = async (event) => {
  const complexity = analyzeRequestComplexity(event);
  if (complexity.simple) {
    return await processServerless(event);
  } else {
    return await queueForContainerProcessing(event);
  }
};
```

## Decision Framework
- **Select serverless:** Execution <10 min, bursty traffic, discrete steps
- **Choose traditional:** 15+ min workflows, always-on, >10GB memory, sub-second latency
- **Consider hybrid:** Mixed baseline/spike loads, cost optimization needed
