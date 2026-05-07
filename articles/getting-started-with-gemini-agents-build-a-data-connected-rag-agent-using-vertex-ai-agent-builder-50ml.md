---
title: "Getting Started with Gemini Agents: Build a Data-Connected RAG Agent using Vertex AI Agent Builder"
url: "https://dev.to/jubinsoni/getting-started-with-gemini-agents-build-a-data-connected-rag-agent-using-vertex-ai-agent-builder-50ml"
author: "Jubin Soni"
category: "vertex-ai-agent"
---

# Getting Started with Gemini Agents: Build a Data-Connected RAG Agent

**Author:** Jubin Soni
**Published:** March 4, 2026

## Overview

Build a Technical Support Agent using Vertex AI Agent Builder and Gemini that searches private PDF/HTML document repositories and provides cited answers with grounding to prevent hallucinations.

## Key Concepts

### Enable Required APIs

```bash
gcloud services enable discoveryengine.googleapis.com \
    storage.googleapis.com \
    aiplatform.googleapis.com
```

### Create GCS Bucket and Upload Data

```bash
export BUCKET_NAME="your-unique-bucket-name"
gsutil mb gs://$BUCKET_NAME
gsutil cp gs://cloud-samples-data/gen-app-builder/search/alphabet-investor-pdfs/*.pdf gs://$BUCKET_NAME/
```

### Python Agent Query Script

```python
from google.cloud import discoveryengine_v1beta as discoveryengine

def query_agent(project_id, location, data_store_id, user_query):
    client = discoveryengine.ConversationalSearchServiceClient()

    serving_config = client.serving_config_path(
        project=project_id,
        location=location,
        data_store=data_store_id,
        serving_config="default_config",
    )

    chat_session = discoveryengine.Conversation()

    request = discoveryengine.ConverseConversationRequest(
        name=serving_config,
        query=discoveryengine.TextInput(input=user_query),
        serving_config=serving_config,
        summary_spec=discoveryengine.ConverseConversationRequest.SummarySpec(
            summary_result_count=3,
            include_citations=True,
        )
    )

    response = client.converse_conversation(request=request)
    print(f"Answer: {response.reply.summary.summary_text}")

PROJECT_ID = "your-project-id"
LOCATION = "global"
DATA_STORE_ID = "your-data-store-id"

query_agent(PROJECT_ID, LOCATION, DATA_STORE_ID, "What is the revenue for 2023?")
```

### Best Practices

- Ensure high-quality, text-selectable PDFs for optimal extraction
- Use system instructions to define agent persona and constraints
- Enable grounding to prevent model hallucinations
- Pre-process complex documents into smaller JSONL objects
