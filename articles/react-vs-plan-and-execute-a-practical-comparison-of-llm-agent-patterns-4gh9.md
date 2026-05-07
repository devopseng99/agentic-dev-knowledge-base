---
title: "ReAct vs Plan-and-Execute: A Practical Comparison of LLM Agent Patterns"
url: https://dev.to/jamesli/react-vs-plan-and-execute-a-practical-comparison-of-llm-agent-patterns-4gh9
author: James Lee
category: agent-patterns
---

# ReAct vs Plan-and-Execute: A Practical Comparison of LLM Agent Patterns

**Author:** James Lee
**Published:** November 18, 2024

## Key Takeaways

- Understanding two major agent patterns: ReAct's reasoning-action loop and Plan-and-Execute's planning-execution separation
- LangChain-based implementation with code examples and best practices
- Performance and cost analysis with quantitative metrics
- Real-world data analysis case studies
- Systematic selection methodology for different scenarios

## Working Principles

### ReAct Pattern

ReAct (Reasoning and Acting) uses an iterative approach alternating between thinking and acting:

1. Analyze current state and objectives
2. Execute specific operations
3. Obtain action results
4. Continue based on observations

**ReAct Prompt Template:**
```
REACT_PROMPT = """Answer the following questions as best you can. You have access to the following tools:

{tools}

Use the following format:

Thought: you should always think about what to do
Action: the action to take, should be one of [{tool_names}]
Action Input: the input to the action
Observation: the result of the action
... (this Thought/Action/Action Input/Observation can repeat N times)
Thought: I now know the final answer
Final Answer: the final answer to the original input question

Question: {input}
Thought: {agent_scratchpad}"""
```

### Plan-and-Execute Pattern

This pattern divides tasks into two phases:

**Planning Phase:** Analyze objectives, break into subtasks, develop execution plan

**Execution Phase:** Execute subtasks sequentially, process results, adjust if needed

**Planner Prompt Template:**
```
PLANNER_PROMPT = """You are a task planning assistant. Given a task, create a detailed plan.

Task: {input}

Create a plan with the following format:
1. First step
2. Second step
...

Plan:"""
```

**Executor Prompt Template:**
```
EXECUTOR_PROMPT = """You are a task executor. Follow the plan and execute each step using available tools:

{tools}

Plan:
{plan}

Current step: {current_step}
Previous results: {previous_results}

Use the following format:
Thought: think about the current step
Action: the action to take
Action Input: the input for the action"""
```

## Implementation Comparison

### ReAct Implementation with LangChain

```python
from langchain.agents import initialize_agent, Tool
from langchain.agents import AgentType
from langchain.chat_models import ChatOpenAI

def create_react_agent(tools, llm):
    return initialize_agent(
        tools=tools,
        llm=llm,
        agent=AgentType.CHAT_CONVERSATIONAL_REACT_DESCRIPTION,
        verbose=True
    )

# Usage example
llm = ChatOpenAI(temperature=0)
tools = [
    Tool(
        name="Search",
        func=search_tool,
        description="Useful for searching information"
    ),
    Tool(
        name="Calculator",
        func=calculator_tool,
        description="Useful for doing calculations"
    )
]

agent = create_react_agent(tools, llm)
result = agent.run("What is the population of China multiplied by 2?")
```

### Plan-and-Execute Implementation with LangChain

```python
from langchain.agents import PlanAndExecute
from langchain.chat_models import ChatOpenAI

def create_plan_and_execute_agent(tools, llm):
    return PlanAndExecute(
        planner=create_planner(llm),
        executor=create_executor(llm, tools),
        verbose=True
    )

# Usage example
llm = ChatOpenAI(temperature=0)
agent = create_plan_and_execute_agent(tools, llm)
result = agent.run("What is the population of China multiplied by 2?")
```

## Performance and Cost Analysis

### Performance Comparison

| Metric | ReAct | Plan-and-Execute |
|--------|-------|------------------|
| Response Time | Faster | Slower |
| Token Consumption | Medium | Higher |
| Task Completion Accuracy | 85% | 92% |
| Complex Task Handling | Medium | Strong |

### Cost Analysis (GPT-4)

| Cost Item | ReAct | Plan-and-Execute |
|-----------|-------|------------------|
| Average Token Usage | 2000-3000 | 3000-4500 |
| API Calls | 3-5 times | 5-8 times |
| Cost per Task | $0.06-0.09 | $0.09-0.14 |

## Case Study: Data Analysis Task

**Objective:** Analyze CSV file, calculate sales statistics, generate report

### ReAct Implementation

```python
from langchain.agents import create_csv_agent
from langchain.chat_models import ChatOpenAI

def analyze_with_react():
    agent = create_csv_agent(
        ChatOpenAI(temperature=0),
        'sales_data.csv',
        verbose=True
    )

    return agent.run("""
        1. Calculate the total sales
        2. Find the best performing product
        3. Generate a summary report
    """)
```

### Plan-and-Execute Implementation

```python
from langchain.agents import PlanAndExecute
from langchain.tools import PythonAstREPLTool

def analyze_with_plan_execute():
    agent = create_plan_and_execute_agent(
        llm=ChatOpenAI(temperature=0),
        tools=[
            PythonAstREPLTool(),
            CSVTool('sales_data.csv')
        ]
    )

    return agent.run("""
        1. Calculate the total sales
        2. Find the best performing product
        3. Generate a summary report
    """)
```

## Selection Guide

### When to Choose ReAct

- Simple direct tasks with single clear objectives
- Real-time interactive scenarios (customer service, instant queries)
- Cost-sensitive applications with limited token budgets

### When to Choose Plan-and-Execute

- Complex multi-step tasks requiring breakdown and dependencies
- High-accuracy scenarios (financial analysis, data processing)
- Long-term planning tasks (project planning, research analysis)

### Best Practice Recommendations

1. **Hybrid Usage Strategy:** Choose patterns based on subtask complexity; combine both in one system
2. **Performance Optimization:** Implement caching, enable parallel processing, optimize prompts
3. **Cost Control:** Set token limits, implement task interruption, use result caching

## Conclusion

Both patterns offer distinct advantages. ReAct excels in speed and cost efficiency, while Plan-and-Execute provides superior accuracy for complex tasks. Selection should consider task characteristics, performance requirements, and cost constraints.
