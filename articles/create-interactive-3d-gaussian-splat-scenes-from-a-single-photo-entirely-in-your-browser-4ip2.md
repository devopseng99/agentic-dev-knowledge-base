---
title: "Create interactive 3D Gaussian Splat scenes from a single photo — entirely in your browser."
url: "https://dev.to/lostbeard/create-interactive-3d-gaussian-splat-scenes-from-a-single-photo-entirely-in-your-browser-4ip2"
author: "Todd Tanner"
category: "3d-ai-generation"
---
# Create interactive 3D Gaussian Splat scenes from a single photo — entirely in your browser.
**Author:** Todd Tanner  **Published:** 2026-03-07

## Overview
SpawnScene is a fully client-side Gaussian Splatting application built with Blazor WebAssembly. The project leverages monocular depth estimation through DepthAnything V2 to generate 3D scenes from single photographs, with GPU processing handled via WebGPU and SpawnDev.ILGPU.

## Key Concepts

### Technology Stack
- **Blazor WebAssembly** — Runs entirely in browser, no server required
- **DepthAnything V2** — Monocular depth estimation from single images
- **WebGPU** — GPU-accelerated processing in-browser
- **SpawnDev.ILGPU** — .NET GPU compute library

### How It Works
1. Upload a single photograph
2. DepthAnything V2 estimates depth map from the single image
3. Depth map drives Gaussian splat generation
4. Interactive 3D scene renders via WebGPU
5. User can explore the resulting 3D scene in the browser

### Project Status
Early-stage project with bugs and holes. Started to improve related underlying projects.

### Key Innovation
Combines monocular depth estimation with Gaussian splatting entirely client-side—no server uploads, no cloud processing, no account required. Runs on consumer hardware via WebGPU.

### Tech Tags
blazor, dotnet, webgpu, csharp

## GitHub Links
- Project: https://github.com/LostBeard/SpawnScene
- Live demo: https://lostbeard.github.io/SpawnScene/
