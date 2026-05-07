---
title: "Implementing Agentic Knowledge Graphs using the A2UI Framework"
url: "https://dev.to/vishalmysore/implementing-agentic-knowledge-graphs-using-the-a2ui-framework-2jpi"
author: "vishalmysore"
category: "agent-graph-database"
---

# Implementing Agentic Knowledge Graphs using the A2UI Framework

**Author:** vishalmysore
**Published:** January 13, 2026

## Overview

Introduces agentic knowledge graphs -- dynamic, real-time AI-generated visualizations where relationships and nodes are constructed by autonomous agents rather than stored in databases. Uses A2UI framework with Cytoscape.js for visualization.

## Key Concepts

### What Makes Them Agentic

1. AI agents dynamically create graphs in real-time based on user queries
2. Graphs update as conversations progress through data model updates
3. Context-aware graph construction tailored to specific requests
4. User interactions trigger agent responses with updated visualizations

### Component Registration (TypeScript)

```typescript
provideA2UI({
  catalog: {
    ...DEFAULT_CATALOG,
    KnowledgeGraph: () => import('./knowledge-graph.component')
      .then(m => m.KnowledgeGraphComponent)
  }
})
```

### A2UI Protocol Data Structure (JSON)

```json
[
  {
    "surfaceUpdate": {
      "surfaceId": "kg-test",
      "components": [{
        "id": "kg1",
        "component": {
          "KnowledgeGraph": {
            "title": "My Knowledge Graph",
            "layout": "cose",
            "data": { "path": "/graphData" }
          }
        }
      }]
    }
  },
  {
    "dataModelUpdate": {
      "surfaceId": "kg-test",
      "contents": [{
        "key": "graphData",
        "valueArray": [
          {
            "key": "0",
            "valueMap": [
              {"key": "id", "valueString": "node1"},
              {"key": "label", "valueString": "Node 1"}
            ]
          },
          {
            "key": "1",
            "valueMap": [
              {"key": "source", "valueString": "node1"},
              {"key": "target", "valueString": "node2"},
              {"key": "label", "valueString": "connects"}
            ]
          }
        ]
      }]
    }
  },
  {
    "beginRendering": { "root": "kg1", "surfaceId": "kg-test" }
  }
]
```

### Server-Side Agent Example (Python)

```python
messages = [
    {
        "surfaceUpdate": {
            "surfaceId": "graph-1",
            "components": [{
                "id": "kg1",
                "component": {
                    "KnowledgeGraph": {
                        "title": "Organization Structure",
                        "layout": "breadthfirst",
                        "data": {"path": "/orgData"}
                    }
                }
            }]
        }
    },
    {
        "dataModelUpdate": {
            "surfaceId": "graph-1",
            "contents": [{
                "key": "orgData",
                "valueArray": [
                    {"key": "0", "valueMap": [
                        {"key": "id", "valueString": "ceo"},
                        {"key": "label", "valueString": "CEO"}
                    ]},
                    {"key": "1", "valueMap": [
                        {"key": "source", "valueString": "ceo"},
                        {"key": "target", "valueString": "cto"},
                        {"key": "label", "valueString": "manages"}
                    ]}
                ]
            }]
        }
    },
    {"beginRendering": {"root": "kg1", "surfaceId": "graph-1"}}
]
```

### Supported Layouts

- **grid:** Nodes arranged in grid pattern
- **cose:** Force-directed layout
- **circle:** Nodes arranged in circle
- **breadthfirst:** Hierarchical layout
