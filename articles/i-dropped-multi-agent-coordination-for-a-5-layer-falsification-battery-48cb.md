---
title: "I Dropped Multi-Agent Coordination for a 5-Layer Falsification Battery"
url: "https://dev.to/moonrunnerkc/i-dropped-multi-agent-coordination-for-a-5-layer-falsification-battery-48cb"
author: "Brad Kinnard"
category: "agent-research-testing"
---
# I Dropped Multi-Agent Coordination for a 5-Layer Falsification Battery
**Author:** Brad Kinnard  **Published:** May 2, 2026

## Overview
The author restructured Swarm Orchestrator by removing multi-agent parallel coordination in favor of a single-agent architecture supported by comprehensive post-merge verification. This is a temporary experimental shift to determine whether coordination value derives from agent diversity or verification rigor.

## Key Concepts
1. **Five-Layer Falsification Battery** — Sequential verification framework running against merged code
2. **Hard Gates (Layers 1-2)** — Differential and mutation testing that block patches on failure
3. **Advisory Layers (Layers 3-5)** — Cheat detection, property-based testing, and cryptographic attestation
4. **Composite Scoring** — Weighted evaluation across advisory layers determining human review requirements

The motivation is distinguishing whether multi-agent coordination itself provided value versus the verification pressure it incidentally created. The author plans to restore multi-agent capabilities in version 8 with clearer empirical evidence about their necessity.
