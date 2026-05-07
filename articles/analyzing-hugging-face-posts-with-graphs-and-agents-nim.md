---
title: "Analyzing Hugging Face Posts with Graphs and Agents"
url: "https://dev.to/neuml/analyzing-hugging-face-posts-with-graphs-and-agents-nim"
author: "David Mezzetti"
category: "huggingface-llm-agents"
---
# Analyzing Hugging Face Posts with Graphs and Agents
**Author:** David Mezzetti  **Published:** November 21, 2024

## Overview
This tutorial demonstrates combining semantic graph networks with AI agents to analyze a dataset of 2,000+ Hugging Face microblog posts. The author shows how to build vector embeddings with automatic relationship inference, visualize post networks through graphs, and use autonomous agents to generate research reports using txtai.

## Key Concepts
- Semantic Graphs — automatically infer content relationships using vector embeddings
- Graph Traversal — navigate networks using openCypher query syntax
- AI Agents — LLM-powered workflows that iteratively interface with tools to answer multi-faceted questions
- Vector Embeddings Database — store and search content with semantic similarity
- Network Visualization — display post relationships using NetworkX and Matplotlib

## Code Examples

### Installation
```bash
pip install txtai[graph] datasets
```

### Load Dataset and Generate Titles
```python
from datasets import load_dataset
from txtai import LLM

llm = LLM("Qwen/Qwen3-4B-Instruct-2507")

def title(text):
    prompt = f"""Create a simple, concise topic for the following text. Only return the topic name.

Text:
{text}
"""
    return llm([{"role": "user", "content": prompt}], maxlength=2048)

def hfposts():
    ds = load_dataset("maxiw/hf-posts", split="train")
    for row in ds:
        yield {
            "id": title(row["rawContent"]),
            "text": row["rawContent"],
            "author": row["author"]["name"],
            "date": row["publishedAt"],
            "url": f"https://hf.co{row['url']}",
            "reactions": sum(x["count"] for x in row["reactions"]),
            "views": row["totalUniqueImpressions"],
            "comments": row["numComments"]
        }
```

### Build Embeddings Index with Graph
```python
from tqdm import tqdm
from txtai import Embeddings

embeddings = Embeddings(
    autoid="uuid5",
    path="intfloat/e5-large",
    instructions={"query": "query: ", "data": "passage: "},
    content=True,
    graph={"approximate": False, "minscore": 0.7},
)
embeddings.index(tqdm(hfposts()))
```

### Load Pre-computed Index
```python
embeddings = Embeddings()
embeddings.load(provider="huggingface-hub", container="neuml/txtai-hfposts")
```

### Graph Path Traversal (openCypher)
```python
g = embeddings.graph.search("""
MATCH P=({id: "Argilla Joins Hugging Face"})-[*1..3]->({id: "Hugging Face Growth"})
RETURN P
LIMIT 30
""", graph=True)
```

### Create and Configure Agent
```python
from txtai import Agent

posts = {
    "name": "posts",
    "description": "Searches a database of technical blog posts",
    "target": embeddings
}

agent = Agent(
    tools=[posts],
    llm=llm,
    max_iterations=10,
)
```

### Agent Execution
```python
from IPython.display import display, Markdown

researcher = """
You're looking to learn more about {topic}. Do the following.
 - Search for posts related to the topic.
 - Write a report with references hyperlinks.
 - Write the text as Markdown.
"""

md(agent(researcher.format(topic="hugging face and open source AI")))
```
