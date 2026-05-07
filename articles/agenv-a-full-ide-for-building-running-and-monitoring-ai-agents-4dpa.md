---
title: "Agenv -- A Full IDE for Building, Running, and Monitoring AI Agents"
url: "https://dev.to/adibenmati/agenv-a-full-ide-for-building-running-and-monitoring-ai-agents-4dpa"
author: "adibenmati"
category: "full-code-examples"
---

# Agenv -- A Full IDE for Building, Running, and Monitoring AI Agents
**Author:** adibenmati
**Published:** May 3, 2026

## Overview
Web-based IDE purpose-built for running and monitoring AI agents like Claude, Gemini, and Vertex. Consolidates multiple terminal windows, code editing, and cost tracking into a single interface.

## Key Concepts

### GitHub Repository
https://github.com/adibenmati/agenv

### Installation

```bash
npm install -g @adibenmatdev/agenv
```

Or without installation:
```bash
npx @adibenmatdev/agenv
```

### Command Examples

```bash
agenv                          # Launch desktop or web
agenv --web                    # Force web mode
agenv --web --port 3000       # Custom port
agenv run "claude"            # Launch with command
agenv stop                    # Stop server
agenv set agent gemini        # Configure default agent
```

### Core Features
- Split terminal panes with persistent PTY sessions (Alt+1-9 shortcuts)
- Integrated code editor with syntax highlighting for 30+ languages
- Git operations sidebar (staging, diffing, committing, pushing)
- Session persistence with AES-256-GCM encryption
- Real-time token usage and cost tracking per agent session
- Desktop (Electron) or web server deployment with ngrok integration

### Technical Architecture
Minimal dependencies: express (HTTP), ws (WebSocket), @lydell/node-pty (terminal emulation), qrcode-terminal (mobile access QR). Frontend uses vanilla JavaScript modules -- no React, Vue, or build processing.

### Security
- Desktop mode: no exposed network ports
- Web mode: 128-bit random token auth, scrypt password hashing, rate limiting, CSP headers
- Electron sandbox enforcement
- Local encryption of persistent data

**npm Package:** @adibenmatdev/agenv
**License:** Apache-2.0
