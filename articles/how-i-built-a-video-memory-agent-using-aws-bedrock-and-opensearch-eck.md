---
title: "How I Built a Video Memory Agent using AWS Bedrock and OpenSearch"
url: "https://dev.to/aws-builders/how-i-built-a-video-memory-agent-using-aws-bedrock-and-opensearch-eck"
author: "Salam Shaik"
category: "aws-agents"
---

# How I Built a Video Memory Agent using AWS Bedrock and OpenSearch
**Author:** Salam Shaik
**Published:** December 23, 2025

## Overview
Semantic video search agent that creates "semantic memory" from video content. Four-layer architecture: Ingestion (frame extraction + transcription), Memory (vector embeddings in OpenSearch), Reasoning (Bedrock agent with k-NN search), Interface (Streamlit chatbot). Uses AWS Transcribe for audio, Nova Premier for scene analysis, Titan Embeddings v2 for vectors, and OpenSearch k-NN with HNSW for semantic search. Enables queries like "When does the hero cry?"

## Key Concepts

### Architecture Layers
1. **Ingestion:** S3 video download, AWS Transcribe (SRT output), 5 frames/minute via MoviePy
2. **Memory:** OpenSearch with 1024-dim HNSW k-NN index, Titan Text Embeddings v2
3. **Reasoning:** Lambda adapter between Bedrock Agent and OpenSearch, chronological re-sorting
4. **Interface:** Streamlit chat with Bedrock Agent streaming

### Critical Innovation
Re-sorts k-NN results by timestamp to reconstruct narrative timeline and prevent hallucinations

### OpenSearch Index Schema
- Keyword fields: video_id, scene_id, episode_title, characters, locations, emotions, topics, visual_tags
- Text fields: transcript, summaries, relationships, events
- knn_vector: 1024 dimensions, HNSW cosinesimil (Lucene engine)

## Code Examples

### Video Analysis with Nova Premier
```python
def call_nova_premier(bedrock_client, model_id, scene_text, frame_bytes_list, minute_index):
    system_prompt = (
        "You are a precise video scene analyst. "
        "You receive up to 5 frames from a one-minute video segment "
        "plus the dialogue/subtitles text for the same time range.\n"
        "Return a STRICT JSON object with: scene_summary, characters, "
        "locations, emotions, relationships, topics, visual_tags, important_events"
    )

    content_blocks = [{"text": f"This is minute {minute_index} of the video.\n\nSubtitles:\n{scene_text}"}]
    for img_bytes in frame_bytes_list:
        content_blocks.append({"image": {"format": "jpeg", "source": {"bytes": img_bytes}}})

    response = bedrock_client.converse(
        modelId=model_id,
        system=[{"text": system_prompt}],
        messages=[{"role": "user", "content": content_blocks}],
        inferenceConfig={"maxTokens": 512, "temperature": 0.2, "topP": 0.9},
    )

    raw_text = response["output"]["message"]["content"][0]["text"]
    return json.loads(raw_text)
```

### Frame Extraction
```python
def extract_minute_frame_bytes(clip, minute_index, frames_per_minute=5, image_format="jpeg"):
    duration_sec = clip.duration
    start = minute_index * 60.0
    end = min(start + 60.0, duration_sec)
    window = end - start
    step = window / (frames_per_minute + 1)
    timestamps = [start + step * (i + 1) for i in range(frames_per_minute)]

    images_bytes = []
    for t in timestamps:
        t = min(t, duration_sec - 0.01)
        frame = clip.get_frame(t)
        pil_img = Image.fromarray(frame)
        buf = io.BytesIO()
        pil_img.save(buf, format=image_format.upper())
        buf.seek(0)
        images_bytes.append(buf.read())
    return images_bytes
```

### OpenSearch Index Schema
```json
{
  "settings": { "index": { "knn": true } },
  "mappings": {
    "properties": {
      "video_id": { "type": "keyword" },
      "scene_id": { "type": "keyword" },
      "transcript": { "type": "text" },
      "nova_scene_summary": { "type": "text" },
      "characters": { "type": "keyword" },
      "emotions": { "type": "keyword" },
      "embedding": {
        "type": "knn_vector",
        "dimension": 1024,
        "method": { "name": "hnsw", "space_type": "cosinesimil", "engine": "lucene" }
      }
    }
  }
}
```

### Titan Embedding Generation
```python
def get_titan_embedding(bedrock_client, model_id, text, dimensions=1024):
    body = json.dumps({"inputText": text})
    resp = bedrock_client.invoke_model(
        modelId=model_id, body=body,
        contentType="application/json", accept="application/json"
    )
    return json.loads(resp["body"].read())["embedding"]

def build_embedding_text(scene_doc):
    parts = []
    if summary := scene_doc.get("nova_scene_summary", ""):
        parts.append("[Summary] " + summary)
    if transcript := scene_doc.get("transcript", ""):
        parts.append("[Transcript] " + transcript)
    if chars := ", ".join(scene_doc.get("characters", [])):
        parts.append("[Characters] " + chars)
    return "\n".join(parts)
```

### Lambda Agent Handler
```python
def lambda_handler(event, context):
    params = {}
    if 'parameters' in event:
        for p in event['parameters']:
            params[p['name']] = p['value']

    user_query = params.get('query', '')
    video_id = params.get('video_id', 'default_video')

    vector = get_embedding(user_query)
    raw_hits = search_opensearch(vector, video_id)

    # Re-sort by timestamp for narrative coherence
    sorted_hits = sorted(raw_hits, key=lambda x: parse_timestamp(x.get('timestamp_label', '0:00')))

    result_text = "RELEVANT VIDEO SCENES (Chronological):\n"
    for hit in sorted_hits:
        time_lbl = hit.get('timestamp_label', 'Unknown Time')
        summary = hit.get('nova_scene_summary', 'No summary')
        emotions = ", ".join(hit.get('emotions', []))
        result_text += f"[Time: {time_lbl}] {summary} (Emotions: {emotions})\n"

    return {
        "messageVersion": "1.0",
        "response": {
            "actionGroup": event.get('actionGroup', ''),
            "responseBody": {"application/json": {"body": result_text}}
        }
    }
```

### Streamlit Interface
```python
import streamlit as st
import boto3, uuid

AGENT_ID = ""
AGENT_ALIAS_ID = ""
SESSION_ID = str(uuid.uuid4())

client = boto3.client("bedrock-agent-runtime", region_name="us-west-2")

st.title("3Netra: Video Memory Agent")

if prompt := st.chat_input("Ask about the video..."):
    response = client.invoke_agent(
        agentId=AGENT_ID,
        agentAliasId=AGENT_ALIAS_ID,
        sessionId=SESSION_ID,
        inputText=prompt
    )
    for event in response.get("completion"):
        if 'chunk' in event:
            text_chunk = event['chunk']['bytes'].decode('utf-8')
            full_response += text_chunk
```
