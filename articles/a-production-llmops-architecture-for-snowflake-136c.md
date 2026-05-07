---
title: "A Production LLMOps Architecture for Snowflake"
url: "https://dev.to/jhagerer/a-production-llmops-architecture-for-snowflake-136c"
author: "Johann Hagerer"
category: "llmops-infra"
---

# A Production LLMOps Architecture for Snowflake
**Author:** Johann Hagerer
**Published:** November 11, 2025

## Overview
Architecture for production LLMOps on Snowflake with versioned prompts in Model Registry, dual deployment strategies (Snowpark Container Services for streaming, Stored Procedures for workflows), and dual evaluation framework.

## Key Concepts

### Prompt Templates in Model Registry
- Version prompts as semantic artifacts (e.g., v1.2.0)
- Enable A/B testing different versions
- Support rollback when performance degrades
- Decouple prompts from application code

### Streaming with Snowpark Container Services

```python
@app.post("/process-claim/stream")
async def stream_claim_analysis(claim_text: str):
    prompt_template = registry.get_model("claim_analyzer").version("v2.1")
    async for token in llm_client.stream(
        prompt=prompt_template.render(claim=claim_text)
    ):
        yield token
```

### Workflow with Stored Procedures

```python
def process_claims_workflow(session: Session, claim_ids: list):
    extractor = registry.get_model("extractor_prompt").version("v1.2")
    classifier = registry.get_model("classifier_prompt").version("v2.0")
    for claim_id in claim_ids:
        extracted = extract_with_prompt(extractor, claim_id)
        if extracted['amount'] > 100000:
            classification = classify_high_value(classifier, extracted)
        else:
            classification = classify_standard(classifier, extracted)
        save_to_snowflake(claim_id, classification)
```

### Evaluation with TruLens

```python
from snowflake import telemetry

def claim_processing_workflow(claim_data):
    telemetry.set_span_attribute("example.proc.do_tracing", "begin")
    extracted = extract_claims(claim_data)
    classified = classify_claims(extracted)
    telemetry.add_event("event_with_attributes", {
        "example.extracted": extracted,
        "example.classified": classified
    })
    return summarize_claims(classified)
```
