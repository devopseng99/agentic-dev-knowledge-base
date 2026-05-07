---
title: "Same gpt-image-2 API. Two totally different results. The difference is 3 markdown files."
url: "https://dev.to/yha9806/same-gpt-image-2-api-two-totally-different-results-the-difference-is-3-markdown-files-3ipj"
author: "yha9806"
category: "ai-image-video-generation"
---
# Same gpt-image-2 API. Two totally different results. The difference is 3 markdown files.
**Author:** yha9806  **Published:** 2026-04-26

## Overview
Demonstrates how structured prompt composition using three markdown files produces vastly superior results compared to naive API calls when working with OpenAI's `gpt-image-2` model for cultural image generation.

## Key Concepts

### The Problem
A Glasgow street photograph needed Northern Song gongbi (工笔重彩—meticulous heavy-color painting) elements added without destroying photographic anchors. Two approaches with identical API calls yielded dramatically different outcomes:
- **Naive:** Direct API call with simple prompt dissolved all photographic detail
- **Structured:** Three-file composition preserved photo anchors while integrating gongbi elements

### The Three-File Architecture

**proposal.md** — Human-readable intent documentation including style treatment, preservation requirements, budget, and timeline.

**design.md** — Technical specification covering provider selection, model configuration, input parameters, and prompt composition structure. Includes YAML frontmatter with three concatenated sections:
- Base prompt naming must-preserve anchors and add-as-gongbi elements
- Traditional terminology tokens (三矾九染, 白描, 勾勒填彩, etc.)
- Color constraint tokens with explicit saturation/style forbiddances

**plan.md** — Execution documentation with phase ordering, evaluation gates, scoring verdicts, and parameter-drift notes.

### Image Decomposition
The resulting image was decomposed into 10 semantic layers via YOLO + Grounding DINO + SAM + SegFormer:

| Entity | Coverage | Detection Quality |
|--------|----------|------------------|
| Left buildings | 24.45% | 0.98 |
| Sky | 15.50% | 0.98 |
| Lanterns | 8.05% | 0.61 |
| Person | 5.65% | 1.01 |
| Bus | 3.59% | 0.98 |

### Honest Evaluation Framework (Rubric mode)
```bash
pip install "vulca[mcp]==0.17.14"
```

```json
{
  "mcpServers": {
    "vulca": {
      "command": "vulca-mcp"
    }
  }
}
```

L1-L5 dimension scoring:
- **L1 Visual:** 0.78 (gongbi additions read as deliberate)
- **L2 Technical:** 0.65 ✗ (hard-fail: 三矾九染 depth shallow; alum-wash layering impossible in single diffusion pass)
- **L3 Cultural:** 0.72 (千里江山图 palette honored)
- **L4 Critical:** 0.75 (additive treatment preserved)
- **L5 Philosophical:** 0.65

**Weighted Result:** 0.702

### Key Concepts
- **Additive vs. Filter Treatment:** Structured prompting enables "painting INTO the scene" rather than applying global style transformation
- **Provenance Trails:** All decisions archived in version-controllable markdown contracts
- **Semantic Layer Editing:** Images decomposed into editable entities

## GitHub Repository
[vulca-org/vulca](https://github.com/vulca-org/vulca) — MCP-based visual composition tool with rubric evaluation framework
