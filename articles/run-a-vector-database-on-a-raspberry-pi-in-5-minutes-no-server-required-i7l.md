---
title: "Run a Vector Database on Raspberry Pi in 5 Minutes (No Server Required)"
url: "https://dev.to/motedb/run-a-vector-database-on-a-raspberry-pi-in-5-minutes-no-server-required-i7l"
author: "motedb"
category: "jetson-robotics"
---
# Run a Vector Database on Raspberry Pi in 5 Minutes (No Server Required)
**Author:** motedb  **Published:** 2026-04-10

## Overview
Demonstrates running a vector database directly on a Raspberry Pi for AI applications requiring semantic search without external server dependencies. Enables edge AI systems to maintain local memory and similarity search capabilities.

## Key Concepts
- Embedded vector database on ARM hardware (Raspberry Pi)
- No server process required: in-process embedding
- Semantic search for robot memory and context retrieval
- Use cases: robot scene memory, semantic navigation landmarks, edge RAG
- Performance on Pi 5: query latency, memory footprint
- Approximate nearest neighbor (ANN) algorithms for constrained hardware
- Integration with local LLMs via Ollama
- Python API for vector insertion and similarity search

```python
import motedb

# Initialize embedded vector DB on Pi
db = motedb.open("/home/pi/robot_memory.db")

# Create table with vector column
db.execute("""
    CREATE TABLE IF NOT EXISTS scenes (
        id INTEGER PRIMARY KEY,
        description TEXT,
        embedding VECTOR(384),
        location TEXT
    )
""")

# Insert scene with embedding
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('all-MiniLM-L6-v2')

scene = "kitchen with refrigerator and table"
embedding = model.encode(scene).tolist()
db.execute("INSERT INTO scenes (description, embedding, location) VALUES (?, ?, ?)",
           [scene, embedding, "kitchen"])

# Semantic search
query_embed = model.encode("where is the fridge?").tolist()
results = db.query(
    "SELECT description, location FROM scenes WHERE embedding ~= ? LIMIT 3",
    [query_embed]
)
```
