---
title: "Multi-Agent Forensics: Rescuing SAS Zombie Assault TD from the Flash Graveyard"
url: "https://dev.to/briancampbell8_d3cb5665e2/multi-agent-forensics-rescuing-sas-zombie-assault-td-from-the-flash-graveyard-1nog"
author: "briancampbell8"
category: "gaming-agents"
---
# Multi-Agent Forensics: Rescuing SAS Zombie Assault TD from the Flash Graveyard
**Author:** briancampbell8  **Published:** May 5, 2026

## Overview
A forensic engineering approach to modernizing a legacy Flash-era game using coordinated AI agents. Rather than treating AI as a simple search tool, the author established a structured team with distinct roles: a human architect providing oversight, Copilot serving as theoretical reasoner, and Windsurf as the code executor. The team successfully debugged catastrophic rendering crashes and brought the game back to functional status.

## Key Concepts
- **Multi-agent coordination**: Assigning specialized roles prevents hallucinations and overlapping work
- **ABI (Application Binary Interface) alignment**: Matching byte-for-byte structures between C# and C++ prevents interop crashes
- **Forensic verification**: Using measurable evidence (pixel statistics, buffer validation) instead of guesswork
- **Consensus-based debugging**: Truth emerges from agreement between reasoning, logic, and execution layers
- **AI agent trainability**: Consistent leadership and constraints improve agent discipline and anticipation
- **Flash game modernization**: Migrating legacy ActionScript/Flash titles to modern rendering pipelines using bgfx

```c
// Truth Probe
#include <stdio.h>
#include <bgfx/c99/bgfx.h>

int main(void) {
    printf("TRUE_SIZE:bgfx_init_t:%zu\n", sizeof(bgfx_init_t));
    return 0;
}
```

```csharp
// Struct Alignment
[StructLayout(LayoutKind.Sequential, Pack = 8)]
public struct bgfx_init_t {
    public bgfx_type_t type;
    public ushort vendorId;
    // ... Surgical alignment ensures the crash stops here.
}
```

```csharp
// Context Integrity Check
Logger.Info($"[Forensics] Draw called with context: {context.GetType().FullName}");
```

```csharp
// Pixel Statistics
int nonZeroCount = buffer.Count(b => b != 0);
Logger.Info($"[Forensics] Buffer Stats: {nonZeroCount} non-zero pixels.");
```
