---
title: "Building a Local AI Agent (Part 2): Six UX and UI Design Challenges"
url: "https://dev.to/flo1632/building-a-local-ai-agent-part-2-six-ux-and-ui-design-challenges-50en"
author: "Florian Zielasko"
category: "agent-ui-frameworks"
---

# Building a Local AI Agent (Part 2): Six UX and UI Design Challenges
**Author:** Florian Zielasko
**Published:** April 30, 2026

## Overview
Examines six UX/UI design solutions for Reiseki, an open-source local AI agent balancing usability for non-technical users with transparency about data access and memory.

## Key Concepts
1. **Zero-Setup Installation**: Windows installer, no Python/config/CLI needed
2. **Live Tool Trace**: Real-time visibility into agent actions, arguments, and results
3. **Memory Management Panel**: Manual save trigger + dedicated panel with deletion options
4. **Conversation History Modal**: SQLite persistence, visible/editable/deletable chat logs
5. **Smartphone Access via QR Toggle**: Network access only when explicitly enabled, QR code for phone
6. **Model Switcher**: Change models in UI without restart

Core tension: usability without technical knowledge vs. user always knowing what the agent knows about them.
