---
title: "Building a Multi-Agent Orchestration System with AG2 (Agentic framework) and Local LLMs"
url: "https://dev.to/chung_duy_51a346946b27a3d/building-a-multi-agent-orchestration-system-with-ag2-agentic-framework-and-local-llms-4d3g"
author: "Chung Duy"
category: "multi-turn-conversation"
---

# Building a Multi-Agent Orchestration System with AG2 and Local LLMs

**Author:** Chung Duy
**Published:** February 16, 2026

## Overview
Demonstrates creating a multi-agent system simulating a software development team using AG2 (formerly AutoGen) and local LLMs. Five specialized agents collaborate with deterministic routing and feedback loops to transform project ideas into comprehensive plans.

## Key Concepts

### Five Specialized Agents
1. **Project Manager** - Analyzes requirements, creates task breakdowns
2. **Architect** - Designs technical architecture, proposes tech stacks
3. **Developer** - Creates implementation plans and code snippets
4. **Reviewer** - Quality checks, approves or sends back for revisions
5. **QA Engineer** - Develops testing strategies, provides final sign-off

### Design Principles
- Deterministic routing (not LLM-based speaker selection)
- Dual-model strategy: reasoning agents use higher temperature, code agents use lower
- Keyword-driven control flow ("APPROVED" / "REVISION NEEDED" / "FINAL SIGN-OFF")
- 15-round maximum to prevent infinite revision loops

## Code Examples

### Project Setup
```bash
mkdir multi-agents && cd multi-agents
python -m venv venv
source venv/bin/activate
pip install "ag2[ollama,openai]" python-dotenv
```

### Configuration (config.py)
```python
import os
from dotenv import load_dotenv
from ag2 import LLMConfig

load_dotenv()

provider = os.getenv("LLM_PROVIDER", "ollama")
base_url = os.getenv("LLM_BASE_URL", "http://localhost:11434")
num_ctx = int(os.getenv("LLM_NUM_CTX", "8192"))

reasoning_model = os.getenv("REASONING_MODEL", "qwen3:latest")
reasoning_temp = float(os.getenv("REASONING_TEMPERATURE", "0.7"))
code_model = os.getenv("CODE_MODEL", "qwen3:latest")
code_temp = float(os.getenv("CODE_TEMPERATURE", "0.3"))

if provider == "ollama":
    reasoning_config = LLMConfig(
        model=reasoning_model, api_type="ollama",
        client_host=base_url, temperature=reasoning_temp, num_ctx=num_ctx,
    )
    code_config = LLMConfig(
        model=code_model, api_type="ollama",
        client_host=base_url, temperature=code_temp, num_ctx=num_ctx,
    )
else:
    reasoning_config = LLMConfig(
        model=reasoning_model, api_key="lm-studio",
        base_url=base_url, temperature=reasoning_temp,
    )
    code_config = LLMConfig(
        model=code_model, api_key="lm-studio",
        base_url=base_url, temperature=code_temp,
    )
```

### Agent Creation (agents.py)
```python
from ag2 import ConversableAgent
from config import reasoning_config, code_config

def create_agents():
    pm = ConversableAgent(
        name="pm",
        system_message="""You are a Senior Project Manager.
Your job is to analyze the user's project request and produce:
1. A clear list of functional and non-functional requirements
2. Project scope and boundaries
3. A structured task breakdown with priorities""",
        human_input_mode="NEVER",
        llm_config=reasoning_config,
    )

    architect = ConversableAgent(
        name="architect",
        system_message="""You are a Senior Software Architect.
Based on the PM's requirements, propose:
1. Tech stack with justification
2. System architecture
3. Data models and relationships
4. Data flow and control flow""",
        human_input_mode="NEVER",
        llm_config=reasoning_config,
    )

    developer = ConversableAgent(
        name="developer",
        system_message="""You are a Senior Full-Stack Developer.
Based on the Architect's design:
1. Create file/folder structure
2. Write implementation plan
3. Provide key code snippets
4. Define API endpoints""",
        human_input_mode="NEVER",
        llm_config=code_config,
    )

    reviewer = ConversableAgent(
        name="reviewer",
        system_message="""You are a Senior Code Reviewer.
Review for: consistency, feasibility, missing pieces, best practices.
End with: "APPROVED" or "REVISION NEEDED: [issues]" """,
        human_input_mode="NEVER",
        llm_config=code_config,
    )

    qa = ConversableAgent(
        name="qa",
        system_message="""You are a Senior QA Engineer.
Create test strategy, key test cases, acceptance criteria.
End with: "FINAL SIGN-OFF: Project plan is complete." """,
        human_input_mode="NEVER",
        llm_config=reasoning_config,
    )

    return pm, architect, developer, reviewer, qa
```

### Orchestrator (orchestrator.py)
```python
from ag2 import GroupChat, GroupChatManager
from agents import create_agents
from config import reasoning_config

pm, architect, developer, reviewer, qa = create_agents()

allowed_transitions = {
    pm:        [architect],
    architect: [developer],
    developer: [reviewer],
    reviewer:  [developer, qa],
    qa:        [pm],
}

def select_next_speaker(last_speaker, groupchat):
    last_msg = groupchat.messages[-1]["content"].lower()
    if last_speaker == pm:
        return architect
    elif last_speaker == architect:
        return developer
    elif last_speaker == developer:
        return reviewer
    elif last_speaker == reviewer:
        if "approved" in last_msg:
            return qa
        else:
            return developer
    elif last_speaker == qa:
        return None
    return None

group_chat = GroupChat(
    agents=[pm, architect, developer, reviewer, qa],
    allowed_or_disallowed_speaker_transitions=allowed_transitions,
    speaker_transitions_type="allowed",
    messages=[], max_round=15, send_introductions=True,
    speaker_selection_method=select_next_speaker,
)

manager = GroupChatManager(
    groupchat=group_chat, llm_config=reasoning_config,
    is_termination_msg=lambda msg: "final sign-off" in msg["content"].lower(),
)
```

### Main Entry Point (main.py)
```python
from orchestrator import pm, manager

def main():
    default_idea = (
        "Build a REST API for a task management app with user auth, "
        "CRUD operations, and real-time notifications"
    )
    user_input = input("Describe your project idea:\n> ").strip()
    if not user_input:
        user_input = default_idea

    result = pm.initiate_chat(manager, message=user_input)
    print(f"Messages: {len(result.chat_history)}, Cost: {result.cost}")

if __name__ == "__main__":
    main()
```
