---
title: "Automate Emails with AI: Building an Email Agent in n8n"
url: "https://dev.to/everyday_dev/automate-emails-with-ai-building-an-email-agent-in-n8n-2ajk"
author: "Everyday Dev"
category: "ai-agent-email-automation"
---

# Automate Emails with AI: Building an Email Agent in n8n

**Author:** Everyday Dev
**Published:** March 23, 2025

## Overview

A guide to building an AI-powered email assistant using n8n, OpenAI, and Gmail that autonomously sends, retrieves, and replies to emails through natural language commands.

## Key Concepts

### Workflow Architecture

1. **Trigger** -- Chat message received
2. **AI Agent** -- Interprets intent (send, get, reply)
3. **OpenAI Chat Model** -- Powers intelligence (gpt-4o-mini)
4. **Gmail Tool** -- Executes email operations
5. **Memory Buffer** -- Preserves chat context

### Gmail Tool Configurations

**Send:**
```
Operation: Send
To: {{ $fromAI('To') }}
Subject: {{ $fromAI('Subject') }}
Message: {{ $fromAI('Message') }}
```

**Retrieve:**
```
Operation: Get Many
Limit: 10
```

**Reply:**
```
Operation: Reply
Message ID: {{ $fromAI('Message_ID') }}
Message: {{ $fromAI('Message') }}
```

### Example Prompts

```
Send an email to john@example.com with subject "Invoice" and say "Please find the attached invoice."
```

```
Show me my latest 5 emails.
```

```
Reply to the email from Jane saying "Thanks, sounds good!"
```

### Extensions

Can be extended with file attachments, intelligent filtering, calendar scheduling, or Outlook integration with minimal changes.
