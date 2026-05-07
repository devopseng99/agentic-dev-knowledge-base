---
title: "Build Your Own AI Code Review Agent in CI"
url: "https://dev.to/lvndry/build-your-own-ai-code-review-agent-in-ci-4mai"
author: "Landry Monga"
category: "code-review"
---

# Build Your Own AI Code Review Agent in CI

**Author:** Landry Monga
**Published:** February 21, 2026
**Tags:** #cicd #ai #githubactions #automation

---

## Overview

The article presents a practical approach to implementing automated code review in CI/CD pipelines using AI models of your choice, eliminating the need for expensive "AI code review" subscriptions.

## Core Problem & Solution

**Pain Points Addressed:**
- Reviewers miss issues when fatigued
- Repetitive comments on naming, tests, edge cases
- Quick PRs become 45-minute context rebuilds

**Proposed Workflow:**
> "Every pull request gets an instant, structured code review (correctness, security, performance, tests) posted automatically by CI"

The key insight: the review **rubric** (prompt structure) matters more than the model itself.

---

## Implementation Steps

### Step 1: GitHub Actions Workflow

**File:** `.github/workflows/ai-code-review.yml`

```yaml
name: AI Code Review
on:
  pull_request:

jobs:
  review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Install Jazz
        run: npm install -g jazz-ai

      - name: Run code review workflow
        run: jazz --output raw workflow run code-review --auto-approve
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
```

**Options:**
- `--output raw`: Optimized for CI capture
- `--auto-approve`: Fully unattended execution
- Swap `OPENAI_API_KEY` for Anthropic, OpenRouter, or local Ollama

### Step 2: Define Review Rubric

**File:** `workflows/code-review/WORKFLOW.md`

```markdown
---
name: code-review
description: Review PR diff and produce a structured report
autoApprove: read-only
---

Review the current PR diff.

Output GitHub-flavored Markdown with:

1) Summary (2-4 bullets)
2) High-risk issues (correctness + security)
3) Performance / complexity concerns
4) API / UX footguns
5) Test gaps + concrete test suggestions
6) Nitpicks (style/readability)

Rules:
- Be specific: reference files/functions.
- Prefer minimal diffs / smallest safe fix.
- If unsure, say so and propose verification methods.
- No generic advice -- propose exact test cases.
```

### Step 3: Post Review as PR Comment

```yaml
- name: Generate review markdown
  run: jazz --output raw workflow run code-review --auto-approve > review.md
  env:
    OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}

- name: Comment on PR
  run: gh pr comment "$PR_NUMBER" --body-file review.md
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    PR_NUMBER: ${{ github.event.pull_request.number }}
```

---

## Cost Advantages Over Subscriptions

- **Event-driven:** Only runs when PRs are created
- **Pay-as-you-go:** Use affordable APIs
- **Flexible routing:** Cheaper models for small diffs, stronger ones for refactors
- **Local option:** Run Ollama with near-zero marginal cost

---

## Safety Principles

**Critical:** "Don't let your CI agent mutate the repo."

Keep `autoApprove` set to `read-only` for review jobs. Avoid granting shell execution or commit permissions.

---

## Practical Best Practices

1. **Force severity ranking** (High/Medium/Low) to avoid alert fatigue
2. **Monitor false positive rate** -- one noisy week kills adoption forever
3. **Route by diff size** -- scale model strength accordingly
4. **Transparency required** -- list reviewed files, assumptions, and unchecked areas

---

## Key Takeaway

Structured review frameworks outperform sophisticated models without discipline. A well-designed rubric that separates high-risk issues from nitpicks and demands concrete, actionable suggestions drives lasting value in automated code review.
