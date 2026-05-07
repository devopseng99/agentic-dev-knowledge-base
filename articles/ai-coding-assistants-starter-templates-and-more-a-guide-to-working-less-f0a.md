---
title: "AI Coding Assistants, Starter Templates, and More: A Guide to Working Less"
url: "https://dev.to/giteden/ai-coding-assistants-starter-templates-and-more-a-guide-to-working-less-f0a"
author: "Eden Ella"
category: "full-code-examples"
---

# AI Coding Assistants, Starter Templates, and More: A Guide to Working Less
**Author:** Eden Ella
**Published:** November 19, 2024

## Overview
Explores pairing AI coding assistants with established development tools like templates, infrastructure-as-code, and composable codebases for maximum productivity.

## Key Concepts

### Templates + AI Assistants
Templates provide crucial context for AI assistants, saving hours of prompt-engineering. They embed development conventions defining frameworks, state management, and styling.

Cursor AI supports `.cursorrules` instruction files. Collection available at https://cursor.directory/

### Infrastructure-as-Code Example (SST)

```typescript
const bucket = new sst.aws.Bucket("MyBucket", {
  access: "public"
});

new sst.aws.Nextjs("MyWeb", {
  link: [bucket]
});
```

"Your codebase is all your AI needs to service you well. Nothing is hidden away, including the resources that power your app."

### Self-Hosted UI Libraries
- **shadcn/ui**: CLI tooling for component integration
- **Bit**: Component copying or installation from Bit Platform
- Embedding components makes it easier for AI coding assistants to compose new UIs while referring to customized collections

### Composable Codebase Benefits
- Standardized: Consistent component reuse across systems
- Maintainable: Clear dependency graphs reduce total LOC
- Adaptable: Components combine differently for new requirements
