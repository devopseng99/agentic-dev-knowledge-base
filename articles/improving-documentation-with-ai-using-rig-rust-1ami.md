---
title: "Improving documentation with AI using Rig & Rust"
url: "https://dev.to/joshmo_dev/improving-documentation-with-ai-using-rig-rust-1ami"
author: "Josh Mo"
category: "rust-go-java-agents"
---

# Improving documentation with AI using Rig & Rust
**Author:** Josh Mo
**Published:** January 12, 2025

## Overview
AI-powered documentation analyzer using Rust and Rig. Downloads GitHub repos, identifies markdown files, classifies using Diataxis framework (tutorials, how-to guides, explanations, reference), generates improvement suggestions with priority levels. Uses pipeline chaining with classifier and advisor agents.

## Key Concepts
- File struct with Display trait for LLM pipeline integration
- collect_markdown_files() recursively traverses directories, filtering files >250 chars
- octocrab crate for GitHub tarball downloads
- rig::pipeline::new() chains classifier then advisor agent
- Results serialize to JSON with jq filtering by priority
