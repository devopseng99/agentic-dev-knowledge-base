---
title: "Microsoft Agent Framework: Combining Semantic Kernel + Autogen for Advanced AI Agents"
url: "https://dev.to/sreeni5018/microsoft-agent-framework-combining-semantic-kernel-autogen-for-advanced-ai-agents-2i4i"
author: "Seenivasa Ramadurai"
category: "semantic-kernel"
---

# Microsoft Agent Framework: Combining Semantic Kernel + Autogen for Advanced AI Agents

**Author:** Seenivasa Ramadurai
**Published:** October 8, 2025
**Tags:** #dotnet #ai #opensource #microsoft

---

## Introduction

The Microsoft Agent Framework (MAF) represents a convergence of two powerful technologies: Semantic Kernel and AG-Autogen. This open-source SDK enables developers to build AI agents and multi-agent workflows using .NET and Python, with Java and JavaScript support forthcoming.

MAF introduces workflow capabilities that provide explicit control over multi-agent execution paths and robust state management designed for "long-running and human-in-the-loop (HITL) use cases."

---

## AI Agents vs. Workflows

The framework distinguishes between two operational modes:

- **AI Agents** function like human brains—LLMs drive activities while external data sources (comparable to MCP servers) provide real-time context
- **Workflows** operate like biological systems, where multiple specialized components collaborate to accomplish complex objectives

Both maintain memory across interactions, enabling contextual decision-making over time.

---

## Orchestration Patterns

### 1. Sequential Orchestration
Agents execute tasks in defined order, with each step depending on completion of the previous one.

### 2. Concurrent Orchestration
Agents work in parallel for efficiency—for example, searching multiple platforms simultaneously and aggregating results.

### 3. Handoff Orchestration
Dynamic workflows where agents pass tasks between each other based on context and requirements.

### 4. Magnetic Orchestration
Sophisticated, context-aware coordination between agents (similar to LangGraph).

### 5. Complex Multi-Agent Collaboration
Multiple specialized agents collaborating on intricate tasks requiring diverse capabilities.

---

## Building an Interactive Chatbot

### Prerequisites
- Python 3.11+
- Azure CLI installed and configured
- Azure subscription with AI Foundry access
- Basic Python and async programming knowledge

### Installation

**Using uv (recommended):**
```bash
uv add agent-framework --prerelease=allow
```

**Using pip:**
```bash
pip install agent-framework --pre
```

### Environment Configuration

Create a `.env` file with Azure AI Foundry credentials:
```
AZURE_AI_PROJECT_ENDPOINT=https://your-project-endpoint.cognitiveservices.azure.com/
AZURE_AI_MODEL_DEPLOYMENT_NAME=your-deployment-name
```

### Complete Chatbot Implementation

```python
import asyncio
from agent_framework import ChatAgent
from agent_framework.azure import AzureAIAgentClient
from azure.identity.aio import AzureCliCredential

async def main():
    credential = AzureCliCredential()
    print("=" * 50)
    print("CREDENTIAL INFORMATION:")
    print("=" * 50)
    print(f"Credential Type: {type(credential).__name__}")
    print(f"Module: {type(credential).__module__}")
    print(f"Full Class: {type(credential)}")

    # Try to get more info about the credential
    try:
        # Get token to see what account is being used
        token = await credential.get_token("https://cognitiveservices.azure.com/.default")
        print(f"Token Type: {type(token)}")
        print(f"Token Expires: {token.expires_on}")
        print("Authentication: SUCCESSFUL")
    except Exception as e:
        print(f"Authentication Error: {e}")

    print("=" * 50)

    # Ask user for mode selection
    print("Select mode:")
    print("1. Normal mode (complete response)")
    print("2. Streaming mode (real-time response)")
    mode_choice = input("Enter choice (1 or 2): ").strip()

    streaming_mode = mode_choice == "2"
    print(f"Selected: {'Streaming' if streaming_mode else 'Normal'} mode")
    print("=" * 50)

    async with (
        credential,
        ChatAgent(
            chat_client=AzureAIAgentClient(async_credential=credential),
            instructions="You are a helpful and friendly chatbot. You can answer questions, have conversations, and assist with various topics."
        ) as agent,
    ):
        print("Chatbot: Hello! I'm your friendly chatbot. Type 'exit' or 'quit' to end the conversation.")
        thread = agent.get_new_thread()

        while True:
            user_input = input("\nYou: ").strip()

            if user_input.lower() in ['exit', 'quit']:
                print("Chatbot: Goodbye! Have a great day!")
                break

            if not user_input:
                continue

            if streaming_mode:
                print("Chatbot: ", end="", flush=True)
                async for chunk in agent.run_stream(user_input, thread=thread):
                    if chunk.text:
                        print(chunk.text, end="", flush=True)
                print()  # New line after streaming
            else:
                result = await agent.run(user_input, thread=thread)
                print(f"Chatbot: {result.text}")

if __name__ == "__main__":
    asyncio.run(main())
```

---

## Key Components

### AzureAIAgentClient
Connects applications to Azure AI Foundry with optional configuration parameters:
```python
AzureAIAgentClient(
    async_credential=credential,
    # Optional:
    # project_endpoint="https://your-endpoint.cognitiveservices.azure.com/",
    # model_deployment_name="your-deployment-name",
    # agent_id="existing-agent-id"
)
```

### ChatAgent
Wraps the client and provides conversational interface:
```python
ChatAgent(
    chat_client=AzureAIAgentClient(async_credential=credential),
    instructions="Your custom instructions for the agent"
)
```

### Thread Management
Maintains conversation context across interactions:
```python
thread = agent.get_new_thread()
result = await agent.run(user_input, thread=thread)
```

---

## Key Takeaways

- Enterprise-grade AI capabilities via Azure integration
- Secure authentication with Azure CLI credentials
- Support for streaming and standard response modes
- Built-in conversation thread management
- Extensible architecture for production deployment

Future articles will explore building AI agents and workflows using MCP servers for external datasource integration.
