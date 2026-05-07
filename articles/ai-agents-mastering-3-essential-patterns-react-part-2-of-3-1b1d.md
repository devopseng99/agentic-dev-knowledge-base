---
title: "AI Agents: Mastering 3 Essential Patterns (ReAct). Part 2 of 3"
url: https://dev.to/gabrielmrojas/ai-agents-mastering-3-essential-patterns-react-part-2-of-3-1b1d
author: Gabriel Melendez
category: react-pattern
---

# AI Agents: Mastering 3 Essential Patterns (ReAct). Part 2 of 3

**Author:** Gabriel Melendez
**Date Published:** January 4, 2026
**Series:** Part 2 of 3-part series on AI Agent patterns

---

## Overview

This article explores the ReAct (Reasoning + Acting) pattern, a cognitive framework where AI agents develop an internal monologue before taking action. Building on the Tool Using pattern from Part 1, ReAct enables agents to solve multi-step problems by iteratively thinking, acting, observing, and adjusting their approach.

---

## Key Concepts

### What is ReAct?

The breakthrough involves forcing language models to maintain a **thought trace** or internal monologue. Rather than rushing to answers, agents enter a loop: Think -> Act -> Observe -> Repeat.

### The Process Loop

Gabriel illustrates this with a "Historical Detective" example asking: *"What is the square root of the age of the current President of France?"*

The agent progresses through iterations:
- **Iteration 1:** Searches for current French president -> discovers "Emmanuel Macron"
- **Iteration 2:** Searches for Macron's age -> finds "47 years old"
- **Iteration 3:** Calculates square root of 47 -> "6.85"

This sequential reasoning prevents hallucinations by grounding each step in verified observations.

---

## Code Implementation

The article provides a Python example using **Agno framework**:

```python
import os
import sys
import logging
import traceback
from typing import List, Optional
from dotenv import load_dotenv, find_dotenv
from agno.agent import Agent
from agno.models.openai import OpenAIChat
from agno.tools.tavily import TavilyTools

# Logging configuration
LOG_DIR = os.path.join(os.path.dirname(__file__), "log")
LOG_FILE = os.path.join(LOG_DIR, "logs.txt")

if not os.path.exists(LOG_DIR):
    os.makedirs(LOG_DIR)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler(LOG_FILE, encoding="utf-8"),
        logging.StreamHandler(sys.stdout)
    ]
)

logger = logging.getLogger(__name__)

def global_exception_handler(exctype, value, tb):
    """Captures unhandled exceptions and records them in the log."""
    error_msg = "".join(traceback.format_exception(exctype, value, tb))
    logger.error(f"Unhandled exception:\n{error_msg}")
    sys.__excepthook__(exctype, value, tb)

sys.excepthook = global_exception_handler

# Environment Variables Loading
env_path = find_dotenv()
if env_path:
    load_dotenv(env_path)
    logger.info(f".env file loaded from: {env_path}")
else:
    logger.warning(".env file not found")

# Tool Definitions
def calculate(expression: str) -> str:
    """
    Solves a simple mathematical expression.
    Useful for calculating year or date differences.

    Args:
        expression (str): The mathematical expression to evaluate
    """
    try:
        allowed_chars = "0123456789+-*/(). "
        if all(c in allowed_chars for c in expression):
            result = eval(expression)
            return f"Result: {result}"
        else:
            return "Error: Disallowed characters in expression."
    except Exception as e:
        return f"Error while calculating: {str(e)}"

# Agno Agent Configuration (ReAct Pattern)
model_id = os.getenv("BASE_MODEL", "gpt-4o")

agent = Agent(
    model=OpenAIChat(id=model_id),
    tools=[TavilyTools(), calculate],
    instructions=[
        "You are a researcher using the ReAct (Reason + Act) method.",
        "1. Think step-by-step about what information you need.",
        "2. Use the search tool (Tavily) to find specific data.",
        "3. Use the calculator for mathematical operations.",
        "4. Do not guess historical information. Look it up.",
        "5. Show your reasoning: 'Thought:', 'Action:', 'Observation:'.",
        "6. Continue investigating until you have a complete answer."
    ],
)

# User Interface
def main():
    logger.info("Starting Historical Detective Agent (ReAct)...")
    print("--- Historical Detective - ReAct Pattern ---")
    print("Type 'exit' to quit.\n")

    while True:
        try:
            user_input = input("Researcher, what is your question?: ")

            if user_input.lower() == "exit":
                logger.info("The user has ended the session.")
                break

            if not user_input.strip():
                continue

            logger.info(f"User query: {user_input}")
            print("\nInvestigating...\n")
            agent.print_response(user_input, stream=True, show_tool_calls=True)
            print("\n")

        except KeyboardInterrupt:
            logger.info("Keyboard interrupt detected.")
            break
        except Exception as e:
            logger.error(f"Error in main loop: {str(e)}")
            print(f"\nAn error occurred: {e}")

if __name__ == "__main__":
    main()
```

---

## Advantages of ReAct

- **Multi-hop Problem Solving:** Answers complex questions requiring sequential discovery
- **Self-Healing:** Agents can course-correct when initial approaches fail
- **Transparency:** Developers can audit the agent's reasoning through visible thought traces
- **Reduced Hallucinations:** Grounding each step in actual observations minimizes fabrication

---

## Limitations

- **Latency:** Sequential thinking multiplies API calls, introducing delays (10-30 seconds typical)
- **Cost:** Internal monologues consume significant tokens, increasing expenses
- **Infinite Loops:** Agents may become fixated on failed strategies
- **Prompt Sensitivity:** Requires carefully tuned system instructions

---

## Production Engineering Tips

1. **Implement iteration limits** (e.g., max 10 steps) to prevent runaway costs
2. **Use stop sequences** to prevent hallucinated observations
3. **Manage context proactively** by removing outdated thought traces in long conversations

---

## Real-World Applications

- **Coding agents** (like Devin): code -> execute -> observe error -> refactor
- **Technical support automation:** ticket analysis -> log review -> solution generation
- **Financial analysis:** price research -> news analysis -> historical comparison

---

## Resources

Complete code available on [GitHub repository](https://github.com/gabrielmrojas/1-AI-Agent-Fundamentals-Patterns)
