---
title: "I'm Building an AI Agent to Write My Unit Tests"
url: "https://dev.to/hernanchilabert/im-building-an-ai-agent-to-write-my-unit-tests-2493"
author: "Hernan Chilabert"
category: "ai-agent-unit-testing"
---

# I'm Building an AI Agent to Write My Unit Tests

**Author:** Hernan Chilabert
**Published:** August 14, 2025

## Overview
An open-source project developing a "Dev Engineer" Agent capable of generating unit tests from a single Python source file, using CrewAI for a feedback loop where Dev and QA agents iterate until target coverage is achieved.

## Key Concepts

### Phase 1: Dev Engineer Agent
1. Accepts a Python source file as input
2. Generates a `test_.py` file with pytest-compatible unit tests
3. Uses LangChain for orchestration and OpenAI LLM for code generation

### Vision: Autonomous Testing Team
- Dev Agent writes tests
- QA Agent executes them and analyzes coverage
- QA Agent provides feedback on failures
- Dev Agent iterates based on feedback
- Process continues until test suite meets quality standards

### Roadmap
- **Phase 2:** QA Engineer Agent, CrewAI framework integration for feedback loops
- **Phase 3:** FastAPI exposure, Redis state management, Docker containerization
- **Future:** LangSmith observability, VSCode extension, multi-language support

**Repository:** https://github.com/herchila/unittest-ai-agent
