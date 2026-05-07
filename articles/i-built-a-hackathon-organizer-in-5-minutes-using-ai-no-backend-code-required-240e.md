---
title: "I Asked AI to Design a Hackathon App. 5 Minutes Later It Was in Production."
url: "https://dev.to/restdbjones/i-built-a-hackathon-organizer-in-5-minutes-using-ai-no-backend-code-required-240e"
author: "Jbee - codehooks.io"
category: "hackathons"
---

# I Asked AI to Design a Hackathon App. 5 Minutes Later It Was in Production.
**Author:** Jbee - codehooks.io
**Published:** March 1, 2026

## Overview
Building a complete hackathon management platform (events, participants, teams, submissions, judges, scores) using AI-assisted datamodel design and Codehooks.io serverless template. Schema-driven UI generation from JSON definitions.

## Key Concepts

### Quick Setup
```bash
npm i -g codehooks
coho create hackathonhq --template react-admin-dashboard
cd hackathonhq
mv config.json backend
coho set-env JWT_ACCESS_TOKEN_SECRET $(openssl rand -hex 32)
npm run install:all
npm run deploy
```

### Schema-Driven Architecture
```json
{
  "collections": {
    "events": {
      "schema": {
        "properties": {
          "status": {
            "type": "string",
            "enum": ["Planning", "Open for Registration", "In Progress", "Judging", "Completed"]
          }
        }
      },
      "relatedCollections": [
        {
          "collection": "teams",
          "foreignKey": "event._id",
          "allowCreate": true
        }
      ]
    }
  }
}
```

Tech Stack: React 18, Tailwind v4, shadcn/ui, Codehooks.io serverless Node.js, JWT auth

### GitHub Repository
- https://github.com/RestDB/codehooks-io-templates/tree/main/react-admin-dashboard
