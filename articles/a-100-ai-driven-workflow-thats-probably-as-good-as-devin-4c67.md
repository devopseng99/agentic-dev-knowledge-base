---
title: "A 100% AI-driven web dev workflow, as good as Devin: MAGE x Aider"
url: "https://dev.to/wasp/a-100-ai-driven-workflow-thats-probably-as-good-as-devin-4c67"
author: "vincanger (Wasp)"
category: "enterprise-clones"
---

# A 100% AI-driven web dev workflow, as good as Devin: MAGE x Aider
**Author:** vincanger (Wasp)
**Published:** March 20, 2024

## Overview
How to replicate Devin's autonomous software engineering capabilities using open-source tools: Wasp AI for scaffolding and Aider for iterative development. Costs $0.10-$2 per app vs Devin's $15-40.

## Key Concepts

### Wasp Config Example
```jsx
app TodoApp {
  wasp: {
    version: "^0.13.0"
  },
  auth: {
    userEntity: User,
    methods: {
      usernameAndPassword: {}
    },
  }
}

entity User {=psl
  id       Int    @id @default(autoincrement())
  tasks    Task[]
psl=}
```

### GitHub Repositories
- https://github.com/wasp-lang/wasp

### Key Architecture
- Wasp: Full-stack React/Node/Prisma framework with declarative config
- Aider: CLI tool for pair-programming with GPT models
- Mage: AI-powered full-stack app generator (40k+ apps generated)
- DSL-based approach reduces token consumption
- Workflow: Scaffold via Wasp AI CLI -> Iterate with Aider -> Debug via natural language
