---
title: "Building an AI-Assisted Animation Pipeline in UE5 with HY-Motion (Dev Log #13)"
url: "https://dev.to/domtechgaming/building-an-ai-assisted-animation-pipeline-in-ue5-with-hy-motion-dev-log-13-okb"
author: "domtechgaming"
category: "gaming-agents"
---
# Building an AI-Assisted Animation Pipeline in UE5 with HY-Motion (Dev Log #13)
**Author:** DomTech Gaming  **Published:** May 6, 2026

## Overview
Development log documenting an AI-assisted animation workflow for Magickness, an in-development MMORPG. The pipeline integrates HY-Motion (HY Animotion), Blender, and Unreal Engine 5 to streamline gameplay animation creation while maintaining compatibility with existing Mixamo-based character systems.

## Key Concepts
- **Animation Generation Workflow**: Generate animation in HY-Motion → Export FBX → Trim/refine in Blender → Import into UE5 using the existing SMPLH skeleton → Retarget using a custom SMPLH-to-Mixamo retargeter → Export finalized gameplay animation
- **Retargeter Asset Storage**: The retarget pose is embedded within the UE5 retargeter asset, enabling reusable pipelines for future animations without rebuilding infrastructure
- **HY-Motion (HY Animotion)**: AI-powered animation generation tool integrated into the indie MMORPG development workflow
- **SMPLH Skeleton**: Body model skeleton used as intermediate format in the retargeting pipeline
- **Blender as refinement step**: Manual trimming and cleanup of AI-generated FBX animations before UE5 import
- **Discovery-driven MMORPG**: Magickness framework with emphasis on scalable systems and AI-assisted development workflows

## Resources
- Project website: https://magickness.com/
- Dev Log video: https://youtu.be/_BEMC1-BY_I
