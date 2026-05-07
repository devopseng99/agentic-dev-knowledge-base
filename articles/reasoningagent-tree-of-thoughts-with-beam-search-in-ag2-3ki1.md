---
title: "ReasoningAgent - Tree of Thoughts with Beam Search in AG2"
url: "https://dev.to/ag2ai/reasoningagent-tree-of-thoughts-with-beam-search-in-ag2-3ki1"
author: "Hrushikesh Dokala, Shaokun Zhang, Chi Wang, BabyCNM, Qingyun Wu"
category: "agent-chain-of-thought"
---

# ReasoningAgent - Tree of Thoughts with Beam Search in AG2

**Author:** Hrushikesh Dokala et al.
**Published:** December 20, 2024

## Overview
Introduces ReasoningAgent, an AG2-based agent implementing tree-of-thought reasoning with beam search. The system explores multiple reasoning paths in parallel and uses a grader agent to evaluate and select the most promising paths.

## Key Concepts
Three components: Thinker Agent (generates steps), Grader Agent (evaluates quality), Beam Search (maintains top-k paths). When beam_size=1, behaves like Chain-of-Thought or O1-style reasoning.

## Code Examples

### Basic Implementation - O1-Style (Python)

```python
import os
from autogen import AssistantAgent, UserProxyAgent
from autogen.agentchat.contrib.reasoning_agent import ReasoningAgent, visualize_tree

config_list = [{"model": "gpt-4", "api_key": os.environ.get("OPENAI_API_KEY")}]

reasoning_agent = ReasoningAgent(
    name="reason_agent",
    llm_config={"config_list": config_list},
    verbose=False,
    beam_size=1,
    max_depth=3,
)

user_proxy = UserProxyAgent(
    name="user_proxy",
    human_input_mode="NEVER",
    code_execution_config={"use_docker": False},
    max_consecutive_auto_reply=10,
)

question = "What is the expected maximum dice value if you can roll a 6-sided dice three times?"
user_proxy.initiate_chat(reasoning_agent, message=question)
```

### Complex Problem with Larger Beam (Python)

```python
reason_agent = ReasoningAgent(
    name="reason_agent",
    llm_config={"config_list": config_list},
    verbose=False,
    beam_size=3,
    max_depth=3,
)

task = "Design a mixed integer linear program for a coffee roasting supply chain"
response = user_proxy.initiate_chat(reason_agent, message=task, summary_method=last_meaningful_msg)
```

### SFT Dataset Extraction (Python)

```python
def extract_sft_dataset(root):
    instruction = root.content
    idx = len("# Question: ") + len(root.content) + 1

    def find_leaf_nodes(node):
        if not node.children:
            return [node]
        leafs = []
        for child in node.children:
            leafs.extend(find_leaf_nodes(child))
        return leafs

    leaf_nodes = find_leaf_nodes(root)
    max_value = max(leaf_nodes, key=lambda x: x.value).value
    best_leafs = [leaf for leaf in leaf_nodes if leaf.value == max_value]
    best_trajectories = [{"instruction": instruction, "response": leaf.trajectory[idx:]} for leaf in best_leafs]
    return best_trajectories
```

### RLHF Preference Dataset (Python)

```python
def extract_rlhf_preference_dataset(root, contrastive_threshold=0.2):
    preference_pairs = []

    def traverse_tree(node):
        if not node.children:
            return
        for i in range(len(node.children)):
            for j in range(len(node.children)):
                if i == j:
                    continue
                child_a, child_b = node.children[i], node.children[j]
                if child_a.value - child_b.value > contrastive_threshold:
                    preference_pairs.append({
                        "instruction": node.trajectory,
                        "preferred_response": f"Step {child_a.depth}: {child_a.content}",
                        "dispreferred_response": f"Step {child_b.depth}: {child_b.content}",
                    })
        for child in node.children:
            traverse_tree(child)

    traverse_tree(root)
    return preference_pairs
```
