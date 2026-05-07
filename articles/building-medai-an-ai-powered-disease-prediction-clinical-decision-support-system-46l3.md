---
title: "Building MedAI — An AI-Powered Disease Prediction & Clinical Decision Support System"
url: "https://dev.to/srimukh_vishnubotla_77c92/building-medai-an-ai-powered-disease-prediction-clinical-decision-support-system-46l3"
author: "Srimukh Vishnubotla"
category: "healthcare-ai"
---
# Building MedAI — An AI-Powered Disease Prediction & Clinical Decision Support System
**Author:** Srimukh Vishnubotla  **Published:** April 27, 2026

## Overview
MedAI is a local-first clinical intelligence platform built as a Flask application with MongoDB persistence. Enables practitioners to input patient vitals, symptoms, and medical history to receive structured risk assessments grounded in 14,000+ diseases from the Human Disease Ontology. All processing occurs on-device using Ollama for local LLM serving—no cloud dependencies or external APIs.

## Key Concepts
- RAG (Retrieval-Augmented Generation): keyword-scored retrieval across standardized disease definitions prevents hallucination
- Local-First Architecture: no internet required; operates entirely on personal devices
- Hybrid Data Persistence: MongoDB optional; core assessment features function without it
- Streaming Responses: Server-Sent Events (SSE) for real-time token delivery
- Vision-Enabled Imaging: medical image analysis with fallback text processing
- Rule-Based Risk Scoring: deterministic vital-to-risk conversion before LLM involvement
- Tech: Flask 3.x, Ollama, Human Disease Ontology (HumanDO.obo), MongoDB, Jinja2, llama3.2/llava

```python
# rag_search — keyword scoring (api_routes.py)
for w in words:
    if w in name.split():  score += 15   # exact word in name
    elif w in name:        score += 10   # partial name hit
    if w in syns:          score += 8    # synonym match
    if w in defn:          score += 4    # definition match
    if w in pars:          score += 2    # parent category
```

```python
# Streaming SSE endpoint — /api/assess/stream
def generate():
    # 1. Send metadata immediately (risk scores, RAG results)
    yield f"data: {json.dumps({'type': 'meta', 'data': meta})}\n\n"

    # 2. Stream tokens as they arrive from Ollama
    for token in stream_ollama(prompt, timeout=90):
        yield f"data: {json.dumps({'type': 'token', 'text': token})}\n\n"

    # 3. Persist to MongoDB, signal completion
    collection.insert_one({...})
    yield f"data: {json.dumps({'type': 'done'})}\n\n"
```

```bash
# 1. Install Python dependencies
pip install -r requirements.txt

# 2. Start Ollama and pull a model
ollama serve
ollama pull llama3.2          # ~2GB, recommended
ollama pull llava             # optional: enables image analysis

# 3. Run the Flask app
python app.py

# 4. Open the dashboard
# http://localhost:5000/dashboard
```

```json
{
  "assessment_id": "a3f2b1c4-70cf-423b-8e61-153d63756d43",
  "patient_id": "pt-00142",
  "timestamp": "2026-04-07T11:32:09Z",
  "vitals": {
    "age": 54,
    "glucose": 148,
    "blood_pressure": "142/91",
    "temperature": 37.2
  },
  "chief_complaint": "fatigue and increased thirst",
  "risk_scores": {
    "diabetes": 72,
    "hypertension": 65
  },
  "rag_matches": [
    {
      "doid": "DOID:9352",
      "name": "type 2 diabetes mellitus",
      "score": 27,
      "icd": "E11"
    }
  ],
  "model_used": "llama3.2",
  "assessment_text": "Based on the presented vitals..."
}
```
