---
title: "Part 3: Building Powerful Chains and Agents in LangChain"
url: "https://dev.to/jamesbmour/part-3-building-powerful-chains-and-agents-in-langchain-5g04"
author: "James"
category: "agent-chain-of-thought"
---

# Part 3: Building Powerful Chains and Agents in LangChain

**Author:** James
**Published:** July 31, 2024

## Overview
Explores LangChain's capabilities for constructing sophisticated AI systems through chains and agents. Covers sequential chains, map/reduce chains, router chains, and custom agents with tools.

## Code Examples

### Custom Chain Class (Python)

```python
from langchain.chains import LLMChain
from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate

class CustomChain:
    def __init__(self, llm):
        self.llm = llm
        self.steps = []

    def add_step(self, prompt_template):
        prompt = PromptTemplate(template=prompt_template, input_variables=["input"])
        chain = LLMChain(llm=self.llm, prompt=prompt)
        self.steps.append(chain)

    def execute(self, input_text):
        for step in self.steps:
            input_text = step.run(input_text)
        return input_text

llm = OpenAI(temperature=0.7)
chain = CustomChain(llm)
chain.add_step("Summarize the following text in one sentence: {input}")
chain.add_step("Translate the following English text to French: {input}")
result = chain.execute("LangChain is a powerful framework for building AI applications.")
```

### Sequential Chain Integration (Python)

```python
from langchain import PromptTemplate, LLMChain
from langchain.llms import OpenAI
from langchain.chains import SimpleSequentialChain

llm = OpenAI(temperature=0.7)

first_prompt = PromptTemplate(
    input_variables=["subject"],
    template="Generate a random {subject} topic:"
)
first_chain = LLMChain(llm=llm, prompt=first_prompt)

second_prompt = PromptTemplate(
    input_variables=["topic"],
    template="Write a short paragraph about {topic}:"
)
second_chain = LLMChain(llm=llm, prompt=second_prompt)

overall_chain = SimpleSequentialChain(chains=[first_chain, second_chain], verbose=True)
result = overall_chain.run("science")
```

### Built-in Agent with Tools (Python)

```python
from langchain.agents import load_tools, initialize_agent, AgentType
from langchain.llms import OpenAI

llm = OpenAI(temperature=0)
tools = load_tools(["wikipedia", "llm-math"], llm=llm)

agent = initialize_agent(
    tools,
    llm,
    agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
    verbose=True
)

result = agent.run("What is the square root of the year Plato was born?")
```

### Custom Agent with Search Tool (Python)

```python
from langchain.agents import Tool, AgentExecutor, LLMSingleActionAgent
from langchain import OpenAI, SerpAPIWrapper, LLMChain

search = SerpAPIWrapper()
tools = [
    Tool(
        name="Search",
        func=search.run,
        description="Useful for answering questions about current events"
    )
]

agent_executor = AgentExecutor.from_agent_and_tools(
    agent=agent,
    tools=tools,
    verbose=True
)
result = agent_executor.run("What's the latest news about AI?")
```
