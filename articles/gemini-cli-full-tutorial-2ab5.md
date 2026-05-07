---
title: "Gemini CLI Full Tutorial"
url: "https://dev.to/proflead/gemini-cli-full-tutorial-2ab5"
author: "Vladislav Guzey"
category: "cloud-agents"
---

# Gemini CLI Full Tutorial
**Author:** Vladislav Guzey
**Published:** June 27, 2025

## Overview
Comprehensive tutorial for Gemini CLI, Google's free open-source AI agent for the terminal. Covers installation, built-in tools, usage examples, project customization via GEMINI.md, MCP server integration, and pricing tiers.

## Key Concepts

### Installation

```shell
sudo apt update && sudo apt install nodejs npm
npm install -g @google/gemini-cli
```

### Getting Started

```shell
gemini
```

Access Gemini 2.5 Pro with 1M token context window, 60 requests/min, 1,000 daily requests free.

### Built-in Tools
- ReadFolder, ReadFile, ReadManyFiles, FindFiles (glob), SearchText (grep)
- Edit, WriteFile, Shell, WebFetch, GoogleSearch, Save Memory

### Usage Examples

```shell
> What does the file index.js do?
> Add error handling to index.js
!ls -al
```

### MCP Server Integration

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "[YOUR-TOKEN]" }
    }
  }
}
```

### Project Customization
Create a `GEMINI.md` file in the project root for custom AI instructions and project-specific rules.

### Pricing
Free tier: 1,000 daily requests. Paid options available via API key or enterprise plans.
