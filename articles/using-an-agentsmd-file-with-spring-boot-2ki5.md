---
title: "Using an AGENTS.md File with Spring Boot"
url: "https://dev.to/mikecodeinvestigator/using-an-agentsmd-file-with-spring-boot-2ki5"
author: "Mike Moller Nielsen"
category: "ai-agent-spring-boot-java"
---

# Using an AGENTS.md File with Spring Boot

**Author:** Mike Moller Nielsen
**Published:** April 14, 2026

## Overview

An AGENTS.md file is a simple way to guide AI coding assistants within a Spring Boot project. It defines codebase structure and coding conventions to maintain consistency in AI-generated code.

## Key Concepts

### Purpose in Spring Boot

The file specifies:
- Where controllers, services, and repositories should belong
- How dependencies are injected
- Testing conventions

### Example AGENTS.md Content

```markdown
# Project Structure
- Controllers: `src/main/java/com/example/controllers/`
- Services: `src/main/java/com/example/services/`
- Repositories: `src/main/java/com/example/repositories/`

# Coding Rules
- Use constructor injection (not field injection)
- Keep business logic in services, not controllers
- All services must have corresponding unit tests
- Follow package-by-feature structure

# Spring Boot Conventions
- Use `@RestController` for REST endpoints
- Use `@Service` for business logic
- Use `@Repository` for data access
- Prefer `record` types for DTOs
- Use `@Transactional` at service layer

# Testing
- Use `@SpringBootTest` for integration tests
- Use `@WebMvcTest` for controller tests
- Mock dependencies with `@MockBean`
```

### Benefits

By providing this context, AGENTS.md reduces inconsistent code generation and improves AI-assisted development usefulness. The file should be concise and practical, containing project structure, coding rules, and basic modification guidelines.
