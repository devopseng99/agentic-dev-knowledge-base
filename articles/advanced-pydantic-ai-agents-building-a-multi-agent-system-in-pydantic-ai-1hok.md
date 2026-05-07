---
title: "Advanced Pydantic AI Agents: Building a Multi-Agent System in Pydantic AI"
url: https://dev.to/hamluk/advanced-pydantic-ai-agents-building-a-multi-agent-system-in-pydantic-ai-1hok
author: Lukas Hamm
category: pydantic-ai
---

# Advanced Pydantic AI Agents: Building a Multi-Agent System in Pydantic AI

**Author:** Lukas Hamm
**Published:** November 6, 2025

## Overview

This article concludes a five-part tutorial series on Pydantic AI agents. It focuses on the **Multi-Agent Pattern**, specifically agent delegation, where specialized agents cooperate to complete complex tasks.

## Key Concepts

### Three Multi-Agent Coordination Forms

The framework supports:
- **Agent Delegation**: One agent calls another to perform subtasks
- **Programmatic Agent Hand-Off**: Explicit runtime control transfers
- **Graph-Based Control Flow**: Agents organized in directed graphs with dynamic execution paths

### Architecture Design

The tutorial demonstrates dividing responsibilities:

1. **TaskAgent**: Handles task creation queries
2. **ProjectManagementAgent**: Manages project-level updates and tracking

## Code Implementation

### TaskAgent Structure

```python
class TaskAgent():
    def __init__(self):
        self.agent = self._init_agent()
        self.pm_agent = ProjectManagementAgent()

    @agent.tool_plain
    async def update_project(project_name: str) -> str:
        result = await self.pm_agent.run(
            query=f"Update open tasks for {project_name}"
        )
        if isinstance(result, Failed):
            return Failed(reason=f"Task creation failed: {result.reason}")
        return f"Updated project details for {project_name}: {result.project}."
```

### ProjectManagementAgent Implementation

```python
class ProjectManagementAgent:
    @agent.tool_plain
    def update_open_tasks(project_name: str) -> ProjectDetails | Failed:
        project = PROJECTS.get(project_name, None)
        if project is None:
            return Failed(reason=f"Project {project_name} does not exist.")
        project_details = ProjectDetails(
            owned_by_group=project.get("group"),
            number_of_open_tasks=project.get("open_tasks")
        )
        project_details.number_of_open_tasks += 1
        project["open_tasks"] = project_details.number_of_open_tasks
        return project_details
```

### Data Models

```python
class ProjectDetails(BaseModel):
    owned_by_group: str
    number_of_open_tasks: int

class TaskModel(BaseModel):
    task: str
    description: str
    priority: int
    project: str
    created_by: str
    project_details: ProjectDetails

class Failed(BaseModel):
    reason: str
```

## Execution Flow

**Success scenario:**
1. TaskAgent receives query and invokes `update_project` tool
2. Tool delegates to ProjectManagementAgent
3. ProjectManagementAgent updates task count successfully
4. Result returns to TaskAgent, which completes task creation

**Failure scenario:**
1. ProjectManagementAgent cannot find project in registry
2. Returns structured `Failed` object with error details
3. TaskAgent receives failure and halts task creation
4. Prevents inconsistent data generation

## Real-World Applications

This pattern enables teams to:
- Decompose workflows into modular components
- Maintain clear functional boundaries
- Replace or extend individual agents independently
- Achieve parallel reasoning across modules
- Integrate domain-specific intelligence

## Key Takeaways

The multi-agent delegation pattern combines natural language flexibility with structured, type-safe communication. The explicit `Failed` class standardizes error handling across agent boundaries, making debugging transparent and testing straightforward. This architectural approach scales effectively for production systems requiring modular, maintainable AI coordination.

**Resources:**
- [GitHub Repository](https://github.com/hamluk/LearnPydanticAI/tree/part-5)
- Previous Part: "Extending Pydantic AI Agents with Chat History"
