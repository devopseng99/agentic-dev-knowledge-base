---
title: "Writing an AnythingLLM Custom Agent Skill to Trigger Make.com Webhooks"
url: "https://dev.to/drunnells/writing-an-anythingllm-custom-agent-skill-to-trigger-makecom-webhooks-1dn0"
author: "Dustin Runnells"
category: "agent-webhook-integration"
---

# Writing an AnythingLLM Custom Agent Skill to Trigger Make.com Webhooks

**Author:** Dustin Runnells
**Published:** November 28, 2024

## Overview
A guide to creating a custom agent skill in AnythingLLM that integrates with Make.com webhooks to automate Google Sheets updates through an LLM agent interface. Combines LLM conversational capabilities with Make.com's connector library for workflow automation.

## Key Concepts

Agents are "LLMs that have access to tools, so that they can do more than just chat with the user." The tutorial uses Make.com's webhook triggers to connect to Google Sheets without complex API integration.

## Code Examples

### plugin.json

```json
{
  "active": true,
  "hubId": "sheet-update-agent",
  "name": "Update Google Sheet",
  "schema": "skill-1.0.0",
  "version": "1.0.0",
  "description": "Update Google Sheet via Make.com Webhook",
  "author": "@drunnells",
  "license": "MIT",
  "setup_args": {
    "postUrl": {
      "type": "string",
      "required": true,
      "input": {
        "type": "text",
        "placeholder": "https://hook.us2.make.com/your-custom-url",
        "hint": "The URL to send the post request to"
      },
      "value": ""
    }
  },
  "entrypoint": {
    "file": "handler.js",
    "params": {
      "name": {
        "description": "Contact name",
        "type": "string"
      },
      "email": {
        "description": "Contact email address",
        "type": "string"
      },
      "phone": {
        "description": "Contact phone number",
        "type": "string"
      }
    }
  },
  "examples": [
    {
      "prompt": "Add Bob Smith's contact information to the contact spreadsheet - Bob Smith, bsmith@example.com, 123-456-7891",
      "call": "{\"name\": \"Bob Smith\", \"email\": \"bsmith@example.com\", \"phone\": \"123-456-7891\"}"
    }
  ],
  "imported": true
}
```

### handler.js

```javascript
module.exports.runtime = {
  handler: async function ({ name, email, phone }) {
    try {
      this.introspect(`Received Parameters: ${JSON.stringify({ name, email, phone })}`);
      this.introspect(`Runtime Arguments: ${JSON.stringify(this.runtimeArgs)}`);
      const postUrl = this.runtimeArgs["postUrl"];
      if (!postUrl) {
        return "Error: postUrl is not configured.";
      }
      this.introspect(`Attempting to post to webhook: ${postUrl}`);
      if (!name || !email || !phone) {
        return "Error: Missing required parameters. Please provide name, email, and phone.";
      }
      const response = await fetch(postUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          name: name,
          email: email,
          phone: phone
        })
      });
      if (response.ok) {
        return "Document updated successfully!";
      } else {
        return `Failed to update document. Status Code: ${response.status}`;
      }
    } catch (e) {
      return `Failed to update document. Error: ${e.message}`;
    }
  }
};
```

### Testing with curl

```bash
curl -X POST https://hook.us2.make.com/testqrd3j8469g856t16hp9l95yeowv9 \
  -H "Content-Type: application/json" \
  -d '{"name":"Jon Smith","email":"jsmith@example.com","phone":"555-555-5555"}'
```
