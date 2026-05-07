---
title: "How to Build Agentic RAG for any PDF in 10 minutes"
url: "https://dev.to/skeptrune/how-to-build-agentic-rag-for-any-pdf-in-10-minutes-1n5m"
author: "Nick K"
category: "ai-agent-pdf"
---

# How to Build Agentic RAG for any PDF in 10 minutes

**Author:** Nick K
**Published:** June 16, 2025

## Overview
Agentic RAG gives the LLM autonomy to decide when and how to search custom data. This guide uses Trieve with Chunkr OCR for sophisticated PDF processing.

## Key Concepts

### Step 1: Initialize Trieve Client

```javascript
import fs from "fs";
import { TrieveSDK, UpdateDatasetReqPayload } from "trieve-ts-sdk";

const trieveClient = new TrieveSDK({
  apiKey: TRIEVE_API_KEY,
  datasetId: TRIEVE_DATASET_ID,
  organizationId: TRIEVE_ORGANIZATION_ID,
});
```

### Step 2: Configure Search Tool

```javascript
async function configureSearchTool() {
  const updatePayload: UpdateDatasetReqPayload = {
    dataset_id: TRIEVE_DATASET_ID,
    server_configuration: {
      SYSTEM_PROMPT:
        "You are an AI assistant. YOU MUST ALWAYS CALL AND USE THE SEARCH TOOL FOR EVERY USER QUESTION WITHOUT EXCEPTION.",
      TOOL_CONFIGURATION: {
        query_tool_options: {
          tool_description:
            "ALWAYS use the search tool for EVERY user question.",
          query_parameter_description:
            "Write a specific query with critical keywords from the user question.",
        },
      },
    },
  };
  await trieveClient.updateDataset(updatePayload);
}
```

### Step 3: Upload PDF with Chunkr OCR

```javascript
async function uploadPdfWithChunkr(filePath: string, trackingId?: string) {
  const fileBuffer = fs.readFileSync(filePath);
  const base64File = fileBuffer.toString('base64');
  const fileName = filePath.split('/').pop() || filePath;

  const response = await trieveClient.uploadFile({
    base64_file: base64File,
    file_name: fileName,
    group_tracking_id: trackingId || `chunkr-doc-${fileName}-${Date.now()}`,
    chunkr_create_task_req_payload: {},
  });
}
```

### Step 4: Ask Agentic Questions

```javascript
const { reader } = await trieveClient.createMessageReaderWithQueryId({
  topic_id: topicIdToUse,
  new_message_content: question,
  use_agentic_search: true,
  model: "o3",
});
```

## Key Tips
- Be Explicit: Don't assume the LLM knows -- tell it directly
- Emphasize Data Freshness: Remind the LLM that its internal knowledge might be outdated
- Encourage Specificity in Queries: Guide the LLM to extract keywords
- Iterate: These descriptions are powerful
