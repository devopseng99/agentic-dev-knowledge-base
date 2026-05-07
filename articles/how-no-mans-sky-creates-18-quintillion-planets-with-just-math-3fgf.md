---
title: "How No Man's Sky Creates 18 Quintillion Planets With Just Math"
url: "https://dev.to/dubeykartikay/how-no-mans-sky-creates-18-quintillion-planets-with-just-math-3fgf"
author: "dubeykartikay"
category: "gaming-agents"
---
# How No Man's Sky Creates 18 Quintillion Planets With Just Math
**Author:** Kartikay Dubey  **Published:** May 3, 2026

## Overview
Technical deep-dive into how Hello Games generates 18.4 quintillion unique planets in No Man's Sky using procedural generation algorithms, specifically hash functions and noise functions, without storing any planet data on disk. Directly relevant to game AI and agent systems that need to generate or reason about procedurally generated game worlds.

## Key Concepts
- **Procedural Generation**: Algorithmic content creation — planets, terrain, creatures, resources all generated mathematically rather than hand-crafted
- **Deterministic Hash Functions**: Given the same seed/coordinates, the function always returns the same output — allows "saving" entire planets with just a seed number
- **Perlin Noise / Simplex Noise**: Mathematical functions producing natural-looking random variation for terrain height, biome placement, and resource distribution
- **Seeded Randomness**: Planet coordinates become seeds → hash → all planet properties (atmosphere, terrain, creatures) derived deterministically
- **No Storage Required**: 18.4 quintillion planets exist mathematically — only computed when a player visits them
- **Hierarchical Generation**: Galaxy → Star System → Planet → Region → Terrain → Resource — each level seeds the next
- **AI Applications**: Same technique applicable to NPC behavior seeding, dungeon generation, and infinite open-world agent environments

## Mathematical Foundation

```python
# Conceptual: Seeded planet generation
import hashlib

def generate_planet(galaxy_id, system_id, planet_id):
    seed = hashlib.sha256(f"{galaxy_id}:{system_id}:{planet_id}".encode()).hexdigest()
    seed_int = int(seed[:16], 16)

    # Deterministic properties from seed
    atmosphere = (seed_int % 100) / 100.0          # 0.0 to 1.0
    temperature = -200 + (seed_int % 400)           # -200 to 200 Celsius
    has_water = (seed_int % 3) == 0                 # 33% chance
    dominant_color = ["red", "blue", "green", "yellow"][seed_int % 4]

    return {
        "atmosphere": atmosphere,
        "temperature": temperature,
        "has_water": has_water,
        "color": dominant_color,
        "seed": seed_int  # only this gets stored
    }

# Same inputs always produce same planet
planet = generate_planet(1, 42, 7)
```

```python
# Perlin Noise for terrain height (conceptual)
def terrain_height(x, z, planet_seed):
    # Multiple octaves of noise for natural-looking terrain
    height = 0
    amplitude = 1.0
    frequency = 0.01

    for octave in range(6):
        height += noise2d(x * frequency + planet_seed,
                          z * frequency + planet_seed) * amplitude
        amplitude *= 0.5
        frequency *= 2.0

    return height
```

## Relevance to Game AI
- Procedural world generation enables infinite AI agent training environments
- Seeded generation allows reproducible benchmark environments for RL agents
- Same techniques used in Minecraft AI research (OpenAI MineRL, Project Malmo)
