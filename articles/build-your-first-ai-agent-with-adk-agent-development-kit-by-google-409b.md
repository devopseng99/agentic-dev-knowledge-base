---
title: "Build Your First AI Agent with ADK - Agent Development Kit by Google"
url: "https://dev.to/marianocodes/build-your-first-ai-agent-with-adk-agent-development-kit-by-google-409b"
author: "Mariano Alvarez"
category: "google-adk"
---

# Build Your First AI Agent with ADK - Agent Development Kit by Google

**Author:** Mariano Alvarez
**Published:** June 1, 2025 (Modified June 2, 2025)
**Tags:** #ai #agents #google #llm

---

## Summary

The article introduces Google's Agent Development Kit (ADK), a Python framework for building AI agents. The author shares their journey experimenting with various agent frameworks before settling on ADK due to its superior documentation, Google backing, and active maintenance.

## Key Comparison Points

The author evaluated three frameworks:

- **LangGraph**: Easy initial setup but "quickly get complex when you start connecting more than one node"
- **Agno**: Simple API with great documentation but performance issues at scale
- **ADK**: Preferred for documentation quality and reliability

## Movie Finder Example

The tutorial demonstrates a simple agent using these components:

### Installation
```bash
pip install google-adk
```

### Environment Setup
```
GOOGLE_GENAI_USE_VERTEXAI=FALSE
GOOGLE_API_KEY=PASTE_YOUR_ACTUAL_API_KEY_HERE
```

### Tool Definition
```python
def find_movies(genre: str, decade: int) -> str:
    """Find movies matching genre and year range"""
    results = []
    year_range = range(decade, decade + 10)

    for movie in MOVIES:
        if genre and movie["genre"] == genre and movie["year"] in year_range:
            results.append(movie["title"])

    return "\n".join(results) if results else "No matching movies found."
```

### Agent Configuration
```python
root_agent = Agent(
    name="root_agent",
    model="gemini-2.5-flash-preview-04-17",
    description="Answers questions from the user",
    instruction="You are a helpful assistant that can answer questions about movies.",
    tools=[find_movies],
)
```

## Key Concepts

1. **LLM vs. Agent**: An LLM is a pretrained model; an agent is a runtime layer adding tools, memory, and logic
2. **Agent Capabilities**: Can analyze questions, call tools, and store results for future reference
3. **Performance Reality**: Agents operate slower than consumer chat applications like ChatGPT

## Testing

Run `adk web` to access a testing dashboard showing agent reasoning, tool calls with parameters, and final responses.
