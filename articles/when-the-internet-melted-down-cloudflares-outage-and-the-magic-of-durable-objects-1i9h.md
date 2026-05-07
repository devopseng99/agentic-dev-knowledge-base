---
title: "When the Internet Melted Down: Cloudflare's Outage and the Magic of Durable Objects"
url: "https://dev.to/bascodes/when-the-internet-melted-down-cloudflares-outage-and-the-magic-of-durable-objects-1i9h"
author: "Bas Steins"
category: "cloudflare-durable-objects"
---

# When the Internet Melted Down: Cloudflare's Outage and the Magic of Durable Objects
**Author:** Bas Steins
**Published:** June 13, 2025

## Overview
Analysis of Cloudflare's June 2025 148-minute outage and deep dive into Durable Objects as compute-with-storage building blocks for serverless applications.

## Key Concepts

### Durable Objects
Unlike stateless serverless functions, Durable Objects maintain persistent state as JavaScript objects across the network. They execute on V8 isolates with data storage capability and offer near-zero cold start times since code loads during TLS handshakes.

### Durable Objects vs D1
D1 is a serverless SQLite database built on Durable Objects. D1 handles relational data but lacks application code colocation. Durable Objects provide low-level control with embedded SQLite.

### Lessons
The outage revealed storage layer redundancy needs despite Durable Objects' innovation for stateful serverless applications, particularly for AI agents and distributed systems.
