---
title: "Why My AI Detected the Player But Did Nothing in Unreal Engine"
url: "https://dev.to/dinesh_04/why-my-ai-detected-the-player-but-did-nothing-in-unreal-engine-5dba"
author: "dinesh_04"
category: "gaming-agents"
---
# Why My AI Detected the Player But Did Nothing in Unreal Engine
**Author:** Dinesh  **Published:** March 15, 2026

## Overview
Documents a common beginner confusion in Unreal Engine AI development: creating perception systems that detect players without triggering behavioral responses. Explains how perception and decision-making operate as separate systems that must be connected through the AI Controller, Blackboard, and Behavior Tree architecture.

## Key Concepts
- **AI Perception Component**: Detects sensory information (sight, hearing, damage) — separate from decision-making
- **Blackboard**: Stores detected actor data for the AI system to reference during decision-making
- **Behavior Tree**: Makes decisions based on Blackboard values — the "brain" that acts on detected information
- **System Flow**: AI Perception → AI Controller → Blackboard → Behavior Tree (must connect all four)
- **Separation of Concerns**: Sensing and decision-making are deliberately independent subsystems in UE5
- **Debug Tool**: Press apostrophe (') in editor to visualize sight radius and perceived actors

## The Problem
Many beginners implement AI Perception correctly and can see actors being detected in debug view, but the AI never moves or reacts. Root cause: the detected actor reference is never written to the Blackboard, and the Behavior Tree has no Blackboard key to read.

## The Fix
1. Create AI Controller C++ class
2. Configure AI Perception Component on the controller
3. On `OnTargetPerceptionUpdated` callback: write detected actor to Blackboard key
4. Create Behavior Tree that reads from that Blackboard key
5. Set the AI Controller on the enemy character Blueprint

## Part of
Day 78 of a 20-part learning series "Learning Blender for Game Designing and Development"
