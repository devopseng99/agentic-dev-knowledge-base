---
title: "Build an AI Job Search Agent with Langflow, Docker & Discord"
url: "https://dev.to/lightningdev123/build-an-ai-job-search-agent-with-langflow-docker-discord-automate-your-job-hunt-5b68"
author: "Lightning Developer"
category: "langflow-agent"
---

# Build an AI Job Search Agent with Langflow, Docker & Discord

**Author:** Lightning Developer
**Published:** March 30, 2026

## Overview

Comprehensive tutorial for creating an automated job search system using Langflow, Docker, and Discord integration with a seven-step workflow from resume analysis to Discord notifications.

## Key Concepts

### Docker Setup

```bash
mkdir langflow-project
cd langflow-project
docker pull langflowai/langflow:latest
docker run -p 7860:7860 langflowai/langflow:latest
```

With data persistence:
```bash
docker run -d \
  -p 7860:7860 \
  -v langflow_data:/app/langflow \
  --name langflow \
  langflowai/langflow:latest
```

### Resume Analyzer Prompt

```
You are an AI job assistant.

Analyze the candidate's resume and extract structured information.

Return ONLY valid JSON.

Fields:
- skills
- preferred_job_roles
- experience_level
- location_preference

Resume:
{text}

Return format:

{
 "skills": [],
 "preferred_job_roles": [],
 "experience_level": "",
 "location_preference": ""
}
```

### Job Matching Prompt

```
You are an AI job search assistant.

Candidate profile:
{resume}

Job board content:
{jobs}

Your task:
1. Extract jobs that match the candidate profile.
2. For each job, ALWAYS extract the application link if present.
3. The application link may appear as:
   - "Apply"
   - "Apply here"
   - "Read more"
   - "View job"
   - a URL (http/https)

Rules:
- If a URL is found near a job, use it as the application_link.
- If multiple links exist, choose the most relevant job application link.

IMPORTANT:
- If no application link is found, DO NOT return "Not available".
- Instead, generate a fallback Google search link using:
  job title + company name.

Format:
https://www.google.com/search?q=JOB_TITLE+COMPANY+apply

Return ONLY valid JSON.
```

### Discord Notifier Component (Python)

```python
from lfx.custom.custom_component.component import Component
from lfx.io import MessageTextInput, Output
from lfx.schema import Data
import urllib.request
import json

class DiscordNotifier(Component):
    display_name = "Discord Notifier"
    description = "Sends a message to Discord webhook"
    icon = "send"

    inputs = [
        MessageTextInput(
            name="message",
            display_name="Message",
            tool_mode=True,
        ),
    ]

    outputs = [
        Output(display_name="Result", name="result",
               method="send_to_discord")
    ]

    def send_to_discord(self) -> Data:
        webhook_url = "Discord_Server_Webhook_URL"

        raw = str(self.message)

        try:
            parsed = json.loads(raw)
            text = parsed.get("content", raw)
        except Exception:
            text = raw

        lines = ["New Job Listings\n"]
        for line in text.strip().split("\n"):
            if not line.strip():
                continue
            parts = line.split("|")
            if len(parts) >= 4:
                number_company = parts[0].strip()
                title          = parts[1].strip()
                location       = parts[2].strip()
                link           = parts[3].strip()

                lines.append(
                    f"**{number_company}. {title}**\n"
                    f"Location: {location}\n"
                    f"Link: {link}\n"
                )
            else:
                lines.append(line)

        msg = "\n".join(lines)[:1990]

        payload = json.dumps({"content": msg}).encode()
        req = urllib.request.Request(
            webhook_url,
            data=payload,
            headers={
                "Content-Type": "application/json",
                "User-Agent": "DiscordBot (https://github.com, 1.0)"
            },
            method="POST"
        )
        urllib.request.urlopen(req)
        self.status = "Sent!"
        return Data(data={"status": "success"})
```

### Remote Access via Pinggy

```bash
ssh -p 443 -R0:localhost:7860 -L4300:localhost:4300 \
-o StrictHostKeyChecking=no \
-o ServerAliveInterval=30 \
[Pinggy_token]@pro.pinggy.io
```
