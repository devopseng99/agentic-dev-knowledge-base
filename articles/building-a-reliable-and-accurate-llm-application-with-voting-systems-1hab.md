---
title: "Building a Reliable and Accurate LLM Application with Voting Systems"
url: "https://dev.to/stephenc222/building-a-reliable-and-accurate-llm-application-with-voting-systems-1hab"
author: "Stephen Collins"
category: "agent-voting-mechanism"
---
# Building a Reliable and Accurate LLM Application with Voting Systems
**Author:** Stephen Collins  **Published:** June 28, 2024

## Overview
Voting systems combine multiple LLM models to produce more reliable and accurate outcomes. "Voting systems combine the strengths of multiple models, leveraging their diverse perspectives."

## Key Concepts

### Why Use a Voting System
- **Increased Accuracy**: Multiple model outputs typically outperform any single model
- **Robustness**: Less susceptible to individual model failures
- **Better Generalization**: Diverse models capture broader knowledge ranges

### Three Providers Used
- Google Gemini 1.5 Flash
- Claude Sonnet 3.5
- OpenAI GPT-4o

### Implementation
```python
from dotenv import load_dotenv
from ai.factory import create_ai_processor

load_dotenv()

google_processor = create_ai_processor("google", "gemini-1.5-flash-001")
openai_processor = create_ai_processor("openai", "gpt-4o")
anthropic_processor = create_ai_processor("anthropic", "claude-3-5-sonnet-20240620")
voters = [google_processor, openai_processor, anthropic_processor]
```

### Majority Voting System
```python
def majority_voting_system_votes(prompt, image):
    votes = []
    for voter in voters:
        vote = voter.process(prompt, image)
        votes.append(int(vote) if vote.isdigit() else vote)
        print(f"VENDOR: {voter.get_vendor()} MODEL: {voter.get_model_name()} VOTE: {vote}")
    return max(set(votes), key=votes.count)
```

### Weighted Voting System
```python
def weighted_voting_system_votes(prompt, image, weights):
    weighted_responses = {}
    for voter, weight in zip(voters, weights):
        vote = voter.process(prompt, image)
        vote = int(vote) if vote.isdigit() else vote
        weighted_responses[vote] = weighted_responses.get(vote, 0) + weight
    return max(weighted_responses, key=weighted_responses.get)

# Usage
weights = [0.4, 0.3, 0.3]  # Google, OpenAI, Anthropic weights
final_vote = weighted_voting_system_votes(prompt, image, weights)
```

### Example Output
```
VENDOR: google MODEL: gemini-1.5-flash-001 VOTE: 3
VENDOR: openai MODEL: gpt-4o VOTE: 3
VENDOR: anthropic MODEL: claude-3-5-sonnet-20240620 VOTE: 3
Majority Voting Final Vote: 3
```

### Best Practices
- **Model Diversity**: Employ different LLM types for varied perspectives
- **Regular Evaluation**: Track model accuracy over time and adjust weights accordingly
- **Data Segregation**: Properly segregate training and validation data

GitHub: https://github.com/stephenc222/tutorial-llm-voting-systems
