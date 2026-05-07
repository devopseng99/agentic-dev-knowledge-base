---
title: "DeepSeek-TUI: Run a DeepSeek Coding Agent Directly in Your Terminal"
url: "https://dev.to/arshtechpro/deepseek-tui-run-a-deepseek-coding-agent-directly-in-your-terminal-59ij"
author: "ArshTechPro"
category: "deepseek-ai-agent"
---

# DeepSeek-TUI: Run a DeepSeek Coding Agent Directly in Your Terminal

**Author:** ArshTechPro
**Published:** May 6, 2026

## Overview
DeepSeek-TUI is an open-source terminal user interface built in Rust that connects to DeepSeek's language models and acts as an agentic coding assistant. It can edit files, run shell commands, make git commits, search the web, and interact with external services through MCP servers.

## Key Concepts

### Three Modes of Operation

- **Plan Mode:** Reviews proposed actions before execution -- ideal for production environments
- **Agent Mode:** Default interactive mode requesting approval for sensitive operations
- **YOLO Mode:** Auto-approves all tool usage for autonomous operation in trusted environments

Toggle between modes using Tab/Shift+Tab, or launch directly with `deepseek-tui --yolo`.

### Installation

```shell
npm install -g deepseek-tui
```

### API Key Configuration

**Interactive Setup:**
```shell
deepseek-tui login
```
Saves credentials to `~/.deepseek/config.toml`

**Environment Variable:**
```shell
DEEPSEEK_API_KEY="your_key_here" deepseek-tui
```

### Launch and Verify
```shell
deepseek-tui
deepseek-tui doctor
```

### Alternative Installation (Rust)

```shell
cargo install deepseek-tui --locked
cargo install deepseek-tui-cli --locked
```

**Build from Source:**
```shell
git clone https://github.com/Hmbown/DeepSeek-TUI.git
cd DeepSeek-TUI
cargo install --path crates/tui --locked
```

### Command Reference
```shell
deepseek-tui                              # Interactive TUI
deepseek-tui -p "explain this codebase"   # One-shot prompt
deepseek-tui --yolo                       # Auto-approval mode
deepseek-tui models                       # List available models
deepseek-tui serve --http                 # HTTP/SSE API server
```

### Keyboard Shortcuts
- `F1`: Help
- `Ctrl+K`: Command palette
- `Esc`: Cancel current action
- `Tab`/`Shift+Tab`: Cycle operating modes
- `/config`: Configuration editor
- `/compact`: Compress session history
- `@path/to/file`: Add file context
- `Ctrl+V`: Attach clipboard image

### Minimal Config (`~/.deepseek/config.toml`)
```toml
api_key = "your_deepseek_api_key"
default_text_model = "deepseek-v4-pro"
```

### Profiles for Multiple Environments
```toml
api_key = "personal_key"
default_text_model = "deepseek-v4-pro"

[profiles.work]
api_key = "work_key"
base_url = "https://api.deepseek.com"
```

**Profile Selection:**
```shell
deepseek-tui --profile work
# OR
DEEPSEEK_PROFILE=work deepseek-tui
```

### Key Environment Variables

| Variable | Purpose |
|----------|---------|
| `DEEPSEEK_API_KEY` | API authentication |
| `DEEPSEEK_MODEL` | Override default model |
| `DEEPSEEK_BASE_URL` | Custom endpoint |
| `DEEPSEEK_PROFILE` | Named profile selection |
| `DEEPSEEK_SANDBOX_MODE` | File access control |
| `DEEPSEEK_APPROVAL_POLICY` | Tool approval behavior |

### Supported Providers
- `deepseek` (default): https://api.deepseek.com
- `nvidia-nim`: NVIDIA's NIM endpoints
- `fireworks`: Fireworks AI
- `sglang`: Self-hosted (localhost:30000/v1)
- `openrouter`: OpenRouter
- `novita`: Novita AI

### MCP Server Integration
```shell
deepseek-tui mcp init
```
Configures MCP servers via `~/.deepseek/mcp.json`.

### Feature Flags Configuration
```toml
[features]
shell_tool = true
subagents = true
web_search = true
apply_patch = true
mcp = true
```

**Runtime Overrides:**
```shell
deepseek-tui --enable web_search
deepseek-tui --disable subagents
deepseek-tui features list
```

### Current Models
- **deepseek-v4-pro**: Full capability model (default), 1M context window
- **deepseek-v4-flash**: Faster, lighter variant, 1M context window
