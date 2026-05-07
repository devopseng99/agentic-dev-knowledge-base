---
title: "Building an AI Agent with Rig and Rust in 10 Minutes"
url: "https://dev.to/rinarig/building-an-ai-agent-with-rig-and-rust-in-10-minutes-48fg"
author: "Rina"
category: "rust-ai-agents"
---

# Building an AI Agent with Rig and Rust in 10 Minutes

**Author:** Rina
**Date Published:** December 19, 2024

---

## Overview

Rina is described as "an open-source, lightweight AI agent framework built with Rig." The article introduces readers to installation and setup procedures for developers interested in creating flexible, scalable AI agents.

## Key Features

- **Twitter Integration** -- Cookie-based login (no API costs) and AI-generated tweet images via Heuris API
- **Telegram Integration** -- Bot integration capabilities
- **Heuris Image Generator** -- AI-powered image creation for social content
- **Discord Integration** -- Bot functionality
- **Character Customization** -- Pre-defined message examples, configurable topics, and communication styles

## Prerequisites

- Rust programming language
- Cargo package manager
- Git version control

## Installation Steps

```bash
git clone https://github.com/cornip/Rina.git
cd Rina
cargo build
```

To retrieve the Twitter cookie string, the guide instructs users to open Chrome DevTools, navigate to the Network tab, locate GraphQL requests to x.com, and copy the cookie value from Request Headers.

## Environment Configuration

Required variables include Twitter credentials (username, password, email, 2FA secret, cookie string), bot tokens for Telegram and Discord, and API keys for OpenAI and Heurist.

## Running the Service

```bash
cargo run
```

## Additional Notes

Character customization occurs through the `rina/src/characters/rina.toml` file. The project welcomes contributions via issue submissions and pull requests.
