---
title: "Agent UI Without React: Zero-Dependency Web Components for AI Agents"
url: "https://dev.to/daltlc/agent-ui-without-react-zero-dependency-web-components-for-ai-agents-50e3"
author: "Dalton C"
category: "agent-ui-frameworks"
---

# Agent UI Without React: Zero-Dependency Web Components for AI Agents
**Author:** Dalton C
**Published:** April 4, 2026

## Overview
Zephyr Framework provides 14 web components using Web Components v1 standard for AI agent UIs with zero dependencies, no build step required. Agents interact with pre-existing components via structured APIs rather than generating UI.

## Key Concepts

### Core API
```javascript
const state = Zephyr.agent.getState()
Zephyr.agent.act('#settings', 'open')
Zephyr.agent.render('#dashboard', {
  tag: 'z-stat',
  attributes: { 'data-label': 'Revenue', 'data-value': '$1.2M' }
})
```

### Quick Start
```html
<z-modal id="demo">
  <h2>Hello from Zephyr</h2>
</z-modal>
<z-tabs>
  <button slot="tab" data-tab="one" data-active>First</button>
  <div slot="panel" data-tab="one">Tab content here.</div>
</z-tabs>
<script src="https://cdn.jsdelivr.net/npm/zephyr-framework@0.3/zephyr-framework.min.js"></script>
```

### MCP Integration
```bash
npx create-zephyr-framework my-app
cd my-app && npm start
```

### Comparison
| Feature | Zephyr | MCP Apps | AG-UI | Generative UI |
|---------|--------|----------|-------|--------------|
| Framework dependency | None | React | React | React |
| Build step | No | Yes | Yes | Yes |
| Pre-built components | 14+ | Define own | Define own | Define own |

License: MIT, GitHub: https://github.com/daltlc/zephyr-framework
