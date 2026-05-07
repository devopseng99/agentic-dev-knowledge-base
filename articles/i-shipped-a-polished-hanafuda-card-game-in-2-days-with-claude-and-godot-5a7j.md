---
title: "I shipped a polished hanafuda card game in 2 days with Claude and Godot"
url: "https://dev.to/morinaga/i-shipped-a-polished-hanafuda-card-game-in-2-days-with-claude-and-godot-5a7j"
author: "morinaga"
category: "gaming-agents"
---
# I shipped a polished hanafuda card game in 2 days with Claude and Godot
**Author:** MORINAGA  **Published:** May 2, 2026

## Overview
A solo developer released Shin KoiKoi, a free, polished hanafuda card game implementing only the Koi-Koi ruleset, within two days of active development. Claude AI handled roughly 70% of UI scaffolding while the developer managed game logic, architectural decisions, and user experience refinement. Pre-development work spanned three weeks focused on design and scope decisions.

## Key Concepts
- **AI-Assisted UI Development**: Claude handled ~70% of UI scaffolding; developer owned game logic and UX decisions
- **Scope Decision**: Single-player only, Koi-Koi ruleset exclusively — deliberate constraint enables fast shipping
- **Technical Stack**: Godot 4.6.2 .NET, C# targeting .NET 9.0, 184 unit tests
- **Development Timeline**: 3 weeks pre-work + 2 days active implementation + 1 polish day
- **Accessibility First**: Colorblind modes, 4 UI scales, reduced motion support, GDPR/CCPA flows
- **AI-Generated Assets**: 45 PNG assets via Gemini nanobanana2 and Midjourney V7 (cultural symbols only, zero IP risk)
- **Roadmap**: v0.2 planned with online multiplayer using Nakama + server hosting

```ini
# macOS Export Configuration
[rendering]
textures/vram_compression/import_etc2_astc=true
textures/vram_compression/import_s3tc_bptc=true
```

```csharp
// Multilingual Font Fallback
var sysFont = new SystemFont
{
    FontNames = new[]
    {
        "Noto Sans CJK JP",
        "Hiragino Sans",
        "Yu Gothic",
        "Noto Sans",
        "Noto Sans Devanagari",
        "sans-serif",
    },
    AllowSystemFallback = true,
};
```

```csharp
// Screenshot Automation for store assets
public partial class ScreenshotTour : Node
{
    public override void _Process(double delta)
    {
        _stepElapsed += (float)delta;
        switch (_step)
        {
            case 0: if (_stepElapsed >= 3.0f) Advance(); break;
            case 1: Capture("01_title.png"); Advance(); break;
            case 2: _main.OpenSettingsForScreenshot(); Advance(); break;
        }
    }
}
```

## Distribution
- Primary: https://hogwartzinc.itch.io/shin-koikoi (free, Mac/Windows/Linux)
