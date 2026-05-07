---
title: "Building my first AI Agent from scratch (Phase 2)"
url: "https://dev.to/decoders_lord/building-my-first-ai-agent-from-scratch-1e35"
author: "Priyank Sevak"
category: "full-code-examples"
---

# Building my first AI Agent from scratch (Phase 2)
**Author:** Priyank Sevak
**Published:** February 25, 2026

## Overview
Building a Code Analyzer Agent -- a tool-calling agent using Google Gemini that analyzes code snippets by extracting function names, class names, import counts, nesting depth, and complexity hints.

## Key Concepts

### GitHub Repository
https://github.com/DecodersLord/Agentic-AI-Journey

### Architecture
1. Reasoning Engine (Gemini) -- decides whether to invoke tools or respond directly
2. Tool (analyze_code) -- Python function returning structured analysis
3. Orchestrator (main.py) -- manages conversation loop and tool dispatch

### Function Declaration

```python
analyze_code_declaration = types.FunctionDeclaration(
    name="analyze_code",
    description="Analyze a code snippet and return the number of lines, functions, and classes.",
    parameters=types.Schema(
        type=types.Type.OBJECT,
        properties={
            "code": types.Schema(
                type=types.Type.STRING,
                description="The code snippet to analyze",
            ),
        },
        required=["code"],
    ),
)
```

### Main Agent Loop

```python
history = []  # Conversation memory

while True:
    user_input = input("You: ")

    history.append(types.Content(role="user", parts=[types.Part.from_text(text=user_input)]))

    response = client.models.generate_content(
        model="gemini-3-flash-preview",
        contents=history,
        config=config,
    )

    part = response.candidates[0].content.parts[0]

    if part.function_call:
        name = part.function_call.name
        result = available_tools[name](**dict(part.function_call.args))

        history.append(response.candidates[0].content)
        history.append(types.Content(role="user", parts=[
            types.Part.from_function_response(name=name, response=result)
        ]))

        follow_up = client.models.generate_content(
            model="gemini-3-flash-preview",
            contents=history,
            config=config,
        )
        print(f"Agent: {follow_up.text}")
        history.append(follow_up.candidates[0].content)
    else:
        print(f"Agent: {response.text}")
        history.append(response.candidates[0].content)
```

### Tool Dispatch Pattern

```python
available_tools = {
    "analyze_code": analyze_code,
}
result = available_tools[name](**args)
```

### System Instruction

```python
system_instruction = (
    "You are a code analysis agent. "
    "When the user provides any code snippet, "
    "you MUST use the analyze_code tool."
)
```

### Key Lessons
1. LLMs may bypass tools if they can generate better responses independently
2. Function declarations (descriptions and parameter names) directly influence tool invocation
3. Full conversation history must accumulate and be sent each turn
4. Tool results must go back to LLM for summarization
5. Two API calls occur when tools execute (tool decision + response generation)
