---
title: "[Open Source] ADEval — A Tool for Evaluating Tool-Use Capabilities of Google ADK AI Agents"
url: "https://dev.to/gde/open-source-adeval-a-tool-for-evaluating-tool-use-capabilities-of-google-adk-ai-agents-3284"
author: "Yu-Wei Simon Liu"
category: "llm-eval-alignment"
---
# ADEval: A Tool for Evaluating Tool-Use Capabilities of Google ADK AI Agents
**Author:** Yu-Wei Simon Liu  **Published:** March 10, 2026

## Overview
While creating an AI Agent using Google's Agent Development Kit (ADK) is straightforward, ensuring the Agent's behavior is predictable and stable presents genuine challenges. ADEval addresses this through a dual approach combining automation and visualization: the Q-Tools-A (Question-Tools-Answer) validation framework.

## Key Concepts

### Core Philosophy: Q-Tools-A Validation
When evaluating an AI Agent, comparing the final text response is not enough. A high-quality Agent must call the right Tools at the right time with the correct parameters.

Three-component evaluation:
1. **Question** — Input prompt, User ID, and Session State for persistence
2. **Tools** — Validates whether agents invoke expected tools with correct parameters
3. **Answer** — Ensures final responses meet business requirements through keyword matching or semantic validation

### Smart Argument Comparison
The key innovation: order-independent parameter matching. If an agent calls `get_weather(city="Taipei", unit="c")`, ADEval correctly judges it regardless of internal parameter sequence.

### Installation

```shell
# Clone the repository
git clone https://github.com/ap-mic-inc/ADEval.git
cd ADEval

# Install in editable mode
pip install -e .
```

Run `adeval ui` to launch the web interface or `adeval --help` for CLI documentation.

### Dual Mode: Debug to Production

**Web UI (Playground + Visual Tracing):**
- Real-time results with Dark Terminal Style viewer
- Expand raw JSON to pinpoint exactly where tool calls failed
- Transforms complex API response event streams into readable traces

**CLI Tool (CI/CD):**
- `adeval config` — Set default API URLs and developer credentials
- `adeval test` — Stress tests without creating formal experiments
- `adeval run / export` — Execute experiment sets and receive statistical reports

### CI/CD Integration
CLI exits with status 0 for passing tests, enabling standard CI integration. Import dozens or hundreds of test cases via CSV files with real-time progress bars and pass-rate statistics.

### Key Features
- **Local Data Ownership** — All experiment data, logs, and configurations store in `.adeval/` folder — no cloud dependency
- **Order-Independent Comparison** — Recognizes parameter equivalence despite ordering differences
- **Batch Evaluation** — CSV import for large test suites

### Core Values
- **Precise Behavioral Control** — Beyond text matching toward rigorous tool-use validation
- **Flexible Workflow** — Full lifecycle from visual debugging through automated regression testing
- **Security** — Localized storage prioritizes privacy

GitHub: https://github.com/ap-mic-inc/ADEval
