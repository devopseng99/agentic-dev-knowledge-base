---
title: "Knowledgeable Agents with FalkorDB Graph RAG"
url: "https://dev.to/ag2ai/knowledgeable-agents-with-falkordb-graph-rag-9d"
author: "Mark Sze, Tvrtko Sternak, Davor Runje, AgentGenie, Qingyun Wu"
category: "agent-graph-database"
---

# Knowledgeable Agents with FalkorDB Graph RAG

**Author:** Mark Sze, Tvrtko Sternak, Davor Runje, AgentGenie, Qingyun Wu
**Published:** December 20, 2024

## Overview

Introduces FalkorDB Graph RAG capabilities for AG2 agents, along with structured outputs and nested chats in swarms. FalkorDB is a high-performance graph database integrated into AG2 release 0.5.

## Key Concepts

### Graph RAG Agent Setup (Python)

```python
import os
import autogen

config_list = autogen.config_list_from_json(env_or_file="OAI_CONFIG_LIST")
os.environ["OPENAI_API_KEY"] = config_list[0]["api_key"]

from autogen import ConversableAgent, UserProxyAgent
from autogen.agentchat.contrib.graph_rag.document import Document, DocumentType
from autogen.agentchat.contrib.graph_rag.falkor_graph_query_engine import FalkorGraphQueryEngine
from autogen.agentchat.contrib.graph_rag.falkor_graph_rag_capability import FalkorGraphRagCapability

input_path = "../test/agentchat/contrib/graph_rag/the_matrix.txt"
input_documents = [Document(doctype=DocumentType.TEXT, path_or_url=input_path)]

query_engine = FalkorGraphQueryEngine(
    name="The_Matrix_Auto",
    host="172.18.0.3",
    port=6379,
)
query_engine.init_db(input_doc=input_documents)

graph_rag_agent = ConversableAgent(
    name="matrix_agent",
    human_input_mode="NEVER",
)

graph_rag_capability = FalkorGraphRagCapability(query_engine)
graph_rag_capability.add_to_agent(graph_rag_agent)

user_proxy = UserProxyAgent(
    name="user_proxy",
    human_input_mode="ALWAYS",
)

user_proxy.initiate_chat(
    graph_rag_agent,
    message="Name a few actors who've played in 'The Matrix'")
```

### Structured Output with Pydantic (Python)

```python
from pydantic import BaseModel

class Step(BaseModel):
    explanation: str
    output: str

class MathReasoning(BaseModel):
    steps: list[Step]
    final_answer: str

llm_config = {
    "config_list": [{
        "api_type": "openai",
        "model": "gpt-4o-mini",
        "api_key": os.getenv("OPENAI_API_KEY"),
        "response_format": MathReasoning
    }]
}

assistant = autogen.AssistantAgent(
    name="Math_solver",
    llm_config=llm_config,
)
```

### Advantages of Graph RAG

- Enhanced contextual understanding of entity relationships
- Improved reasoning and inference capabilities
- Superior handling of complex relationships
- Explainable retrieval paths
