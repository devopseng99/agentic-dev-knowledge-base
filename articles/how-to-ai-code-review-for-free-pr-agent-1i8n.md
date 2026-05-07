---
title: "How to AI code review for free (PR-Agent)"
url: "https://dev.to/webdeveloperhyper/how-to-ai-code-review-for-free-pr-agent-1i8n"
author: "Web Developer Hyper"
category: "ai-code-review-agent"
---

# How to AI code review for free (PR-Agent)

**Author:** Web Developer Hyper
**Published:** August 31, 2025

## Overview
Guide for setting up PR-Agent, a free open-source AI code review tool that works across GitHub and GitLab, using Gemini as the free-tier LLM.

## Key Concepts

### PR-Agent's 3 Main Functions
1. **describe**: Outlines pull request changes
2. **review**: Analyzes code for issues and improvements
3. **improve**: Suggests enhanced code implementations

### GitHub Actions Setup

```yaml
name: PR Agent (Gemini)
on:
  pull_request:
    types: [opened, reopened, ready_for_review, synchronize]
  issue_comment:
jobs:
  pr_agent_job:
    if: ${{ github.event.sender.type != 'Bot' }}
    runs-on: ubuntu-latest
    permissions:
      issues: write
      pull-requests: write
      contents: write
    steps:
      - name: PR Agent action step
        uses: qodo-ai/pr-agent@main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          config.model: "gemini/gemini-2.5-flash"
          config.fallback_models: '["gemini/gemini-2.5-flash"]'
          GOOGLE_AI_STUDIO.GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
          config.response_language: "ja-JP"
          github_action_config.auto_review: "true"
          github_action_config.auto_describe: "true"
          github_action_config.auto_improve: "true"
          github_action_config.pr_actions: '["opened", "reopened", "ready_for_review", "synchronize"]'
```

### GitLab Pipeline Setup

```yaml
stages:
  - pr_agent

pr_agent_job:
  stage: pr_agent
  image:
    name: codiumai/pr-agent:latest
    entrypoint: [""]
  script:
    - cd /app
    - export MR_URL="$CI_MERGE_REQUEST_PROJECT_URL/merge_requests/$CI_MERGE_REQUEST_IID"
    - echo "MR_URL=$MR_URL"
    - export gitlab__url=$CI_SERVER_PROTOCOL://$CI_SERVER_FQDN
    - export gitlab__PERSONAL_ACCESS_TOKEN=$GITLAB_PERSONAL_ACCESS_TOKEN
    - export config__git_provider="gitlab"
    - export config__model="gemini/gemini-2.5-flash"
    - export GOOGLE_AI_STUDIO__GEMINI_API_KEY=$GEMINI_API_KEY
    - export config__response_language="ja-JP"
    - python -m pr_agent.cli --pr_url="$MR_URL" describe
    - python -m pr_agent.cli --pr_url="$MR_URL" review
    - python -m pr_agent.cli --pr_url="$MR_URL" improve
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
```

### Customization (.pr_agent.toml)
```toml
[pr_description] # /describe #
extra_instructions = ""

[pr_reviewer] # /review #
extra_instructions = ""

[pr_code_suggestions] # /improve #
extra_instructions = ""
```

Note: Free Gemini usage means Google may study your data; paid alternatives recommended for sensitive information.
