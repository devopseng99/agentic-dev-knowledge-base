---
title: "7 Godot 4 API Calls Your AI Assistant Still Gets Wrong"
url: "https://dev.to/ziva/7-godot-4-api-calls-your-ai-assistant-still-gets-wrong-3ep6"
author: "ziva"
category: "gaming-agents"
---
# 7 Godot 4 API Calls Your AI Assistant Still Gets Wrong
**Author:** Ziva  **Published:** April 20, 2026

## Overview
AI coding assistants frequently generate Godot 3 code when asked to write Godot 4 scripts. This article documents seven common API mismatches that create runtime failures, explains why this occurs, and provides correct Godot 4 equivalents.

## Key Concepts
- **Training Data Density Problem**: Most tutorials and documentation predate Godot 4's March 2023 release, causing language models to weight outdated APIs more heavily
- **Silent Failures**: Some API changes compile successfully but fail at runtime, making them harder to detect than parse errors
- **Version Evolution**: Godot 4.5 introduced additional breaking changes, making targets harder for models trained on earlier versions

## Seven API Mismatches

| Godot 3 | Godot 4 | Issue Type |
|---------|---------|-----------|
| `deg2rad()` | `deg_to_rad()` | Function rename |
| `KinematicBody2D` + `move_and_slide(velocity, ...)` | `CharacterBody2D` + velocity property | Class & signature change |
| `set_shader_param()` | `set_shader_parameter()` | Function rename |
| `BUTTON_LEFT` | `MOUSE_BUTTON_LEFT` | Constant prefix |
| `rand_range()` | `randf_range()` / `randi_range()` | Function split |
| `yield()` | `await` | Syntax overhaul |
| `Directory` / `File` | `DirAccess` / `FileAccess` | Class replacement |

```gdscript
# Incorrect (Godot 3 style — what AI often generates)
var angle_rad = deg2rad(45)
var body = KinematicBody2D.new()
body.move_and_slide(velocity, Vector2.UP)
yield(get_tree().create_timer(1.0), "timeout")
```

```gdscript
# Correct (Godot 4 style)
var angle_rad = deg_to_rad(45)
var body = CharacterBody2D.new()
body.velocity = velocity
body.move_and_slide()
await get_tree().create_timer(1.0).timeout
```

## Workarounds
1. Prepend the Godot 4.x breaking changes list to system prompts
2. Execute generated code against a live editor to surface runtime errors
3. Use static typing (`var velocity: Vector2`) to catch incompatible signatures

## GitHub References
- Godot 4.x breaking changes: https://gist.github.com/raulsntos/06ac5dd10ebccc3a4f1e7e3ad30dc876
