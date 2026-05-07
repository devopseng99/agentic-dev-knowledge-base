---
title: "Building Next-Gen AI Agents for Google Workspace: MCP, A2A, and A2UI with Google Apps Script"
url: "https://dev.to/gde/building-next-gen-ai-agents-for-google-workspace-mcp-a2a-and-a2ui-with-google-apps-script-299o"
author: "Tanaike"
category: "a2a-protocols"
---

# Building Next-Gen AI Agents for Google Workspace: MCP, A2A, and A2UI with Google Apps Script
**Author:** Tanaike
**Published:** January 10, 2026

## Overview
Implementing MCP, A2A, and A2UI using Google Apps Script (GAS) to bypass OAuth authentication challenges and enable seamless AI agent integration with Google Workspace.

## Key Concepts

### MCP Server Setup

```javascript
const object = {
  apiKey: "{apiKey}",
  model: "models/gemini-3-flash-preview",
  accessKey: "sample",
  webAppsUrl: "https://script.google.com/macros/s/###/exec",
};
```

### Gemini CLI Integration

```json
{
  "mcpServers": {
    "gas_web_apps": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://script.google.com/macros/s/{Your value}/exec?accessKey=sample"
      ],
      "timeout": 300000
    }
  }
}
```

### A2A Client Setup

```bash
git clone https://github.com/tanaikech/a2a-for-google-apps-script
cd a2a-for-google-apps-script/a2a-client
npm install
npm run test1
```

### A2UI with Spreadsheet Data

```javascript
const allRestaurants = ((_) => {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Sheet1");
  const [header, ...values] = sheet.getDataRange().getDisplayValues();
  return values.map((e) => header.reduce((o, h, j) => ((o[h] = e[j]), o), {}));
})();
```

### Key Takeaway
GAS uniquely resolves OAuth 2.0 authorization bottlenecks, enabling MCP (tool connection), A2A (agent collaboration), and A2UI (dynamic UI generation) with Google Workspace data.
