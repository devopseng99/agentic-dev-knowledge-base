---
title: "Stop your AI agents from doing stupid things (I open-sourced a React UI for Human-in-the-Loop)"
url: "https://dev.to/rifzankhan/stop-your-ai-agents-from-doing-stupid-things-i-open-sourced-a-react-ui-for-human-in-the-loop-5eek"
author: "rifzankhan"
category: "agent-ui-frameworks"
---

# Stop your AI agents from doing stupid things (I open-sourced a React UI for Human-in-the-Loop)
**Author:** rifzankhan
**Published:** March 14, 2026

## Overview
An open-source React component called Agent Approval Card that provides a stateless, drop-in UI for human-in-the-loop workflows, addressing the gap between backend pause-and-resume logic and frontend experience.

## Key Concepts

### The Problem
Giving AI agents access to real-world tools (deleting invoices, issuing refunds) creates serious business risks when hallucinations occur. Frameworks like LangGraph and CopilotKit handle backend logic but leave the frontend experience undefined.

### Agent Approval Card Features
- **Risk Levels:** Dynamic rendering of danger buttons and warnings for destructive actions
- **Inline Editing:** Operators can modify raw JSON parameters before approval
- **Frictionless Rejection:** Instant rejection without mandatory explanations
- **Customization:** Clean CSS variable theming compatible with modern dashboards

### Installation

```bash
npm install agent-approval-card
```

### Architecture
The component is deliberately scoped to the UI layer, avoiding enforcement of specific backend protocols or state-management libraries. Developers retain ownership of async logic.

GitHub: [rifzankhan/agent-approval-card](https://github.com/rifzankhan/agent-approval-card)
