---
title: "Not Just Scraping: OSINTGraph Turns Instagram Networks into an Investigable Graph with an AI Agent"
url: "https://dev.to/justin_lol_a756619fd64361/not-just-scraping-osintgraph-turns-your-targets-instagram-network-into-an-investigable-graph-with-241l"
author: "mhloo"
category: "agent-graph-database"
---

# OSINTGraph: Instagram Network Investigation with AI Agent

**Author:** mhloo
**Published:** September 3, 2025

## Overview

Introduces OSINTGraph, a Python CLI tool for open-source intelligence investigations that stores Instagram network data in Neo4j and provides an AI agent for natural language querying.

## Key Concepts

### Core Commands

1. **osintgraph discover** - Collects publicly available Instagram data (profile, followers, followees, posts, comments, likes)
2. **osintgraph explore** - Extends reconnaissance to all followee accounts
3. **osintgraph agent** - AI-powered natural language querying of the graph database

### Technical Architecture

- Data stored in Neo4j graph database
- Nodes represent profiles, posts, and comments
- Relationships map follows, likes, replies, and comment interactions

### AI Agent Capabilities

Investigators can ask questions like "Find all comments @john_doe made about 'party'" without manually analyzing hundreds of comments. Supports custom analysis templates with system prompts.

### Repository

GitHub: https://github.com/XD-MHLOO/Osintgraph
