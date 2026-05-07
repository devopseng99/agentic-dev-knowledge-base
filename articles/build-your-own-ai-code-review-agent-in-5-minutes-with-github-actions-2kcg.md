---
title: "Build Your Own AI Code Review Workflow in 5 Minutes with Github Actions"
url: "https://dev.to/daveturissini/build-your-own-ai-code-review-agent-in-5-minutes-with-github-actions-2kcg"
author: "David"
category: "code-review"
---

# Build Your Own AI Code Review Workflow in 5 Minutes with Github Actions

**Author:** David
**Published:** May 27, 2025
**Tags:** #ai #openai #githubactions #github

## Overview

The article demonstrates how to integrate an LLM into your development workflow using GitHub Actions to automate code reviews on pull requests.

## Key Concept

The workflow passes PR changesets to ChatGPT for review and posts feedback back as PR comments, enabling rapid LLM integration into existing processes.

## Prerequisites

- Familiarity with JavaScript and GitHub Actions

## Implementation Steps

### Step 1: Obtain API Credentials

Acquire an OpenAI API token and store it as a GitHub repository or organization secret named `OPEN_API_KEY`.

### Step 2: Create the Workflow File

The workflow triggers on PR creation and code pushes, executing three main operations:

1. **Fetch Changes:** Retrieve the PR's diff using GitHub CLI
2. **Send to LLM:** Pass the changeset to OpenAI via the `daves-dead-simple/open-ai-action`
3. **Post Feedback:** Comment the LLM's response on the pull request

## Workflow YAML Configuration

```yaml
name: LLM Code Review
on:
  pull_request:
    branches:
      - whichever-branch-you-want-code-review-for
    types:
      - opened
      - synchronize

jobs:
  code-review:
    runs-on:
      - ubuntu-latest
    steps:
      - name: Checkout PR branch
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Get Diff
        id: diff
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          echo "changeset<<EOF" >> $GITHUB_OUTPUT
          echo "$(gh pr diff ${{ github.event.pull_request.number }} --repo "${{ github.repository }}")" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Run AI code review
        uses: daves-dead-simple/open-ai-action@main
        id: code-review
        env:
          OPEN_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        with:
          prompt: |
            Please code review the following changeset: ${{ steps.get_diff.outputs.changeset }}

      - name: Comment on PR with AI review
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          gh pr comment ${{ github.event.pull_request.number }} \
            --repo "${{ github.repository }}" \
            --body "${{ steps.code-review.outputs.completion }}"
```

## Key Takeaways

- **Quick Integration:** "very simple way to integrate OpenAI or any other LLM into your dev workflow"
- **Extensibility:** Workflow can be customized to support multiple LLM providers and custom review instructions
- **Practical Application:** Demonstrates immediate feasibility of LLM-based automation in development processes
