---
title: "Markdown Knowledge Graph for Humans and AI Agents"
url: "https://dev.to/gimalay/markdown-knowledge-graph-for-humans-and-agents-43c4"
author: "Dmytro Halichenko"
category: "agent-graph-database"
---

# Markdown Knowledge Graph for Humans and AI Agents

**Author:** Dmytro Halichenko
**Published:** March 21, 2026

## Overview

Introduces IWE, a tool that treats Markdown as a queryable knowledge graph accessible to both humans (via LSP in editors) and AI agents (via CLI). Solves the problem of opaque agent memory in vector databases.

## Key Concepts

### Dual Interface Architecture

- LSP server (`iwes`) for VS Code, Neovim, Zed, Helix
- CLI tool (`iwe`) for programmatic/agent access

### CLI Commands

```
iwe find "authentication"
iwe retrieve -k docs/auth-flow
iwe retrieve -k docs/auth-flow --depth 2
iwe retrieve -k docs/auth-flow --dry-run
```

### Key Flags

- `--depth N`: Follows inclusion links N levels deep
- `-c N`: Includes N levels of parent context
- `-e KEY`: Excludes already-loaded documents
- `--dry-run`: Checks document count before fetching

### Inclusion Links (Polyhierarchy)

```markdown
# Photography

[Composition](composition.md)
[Lighting](lighting.md)
[Post-Processing](post-processing.md)
```

A Markdown link on its own line defines parent-child relationships, enabling polyhierarchy where documents can have multiple parents.

### Advantages Over Alternatives

- **Folders:** Force single document placement
- **Tags:** Lack hierarchy and ordering
- **Inclusion links:** Enable multiple parents, explicit ordering, and hierarchy

### Benefits

- Version-controlled knowledge through Git
- Deterministic retrieval with exact document boundaries
- Readable, editable, portable knowledge base
- Agents access same source of truth as humans
