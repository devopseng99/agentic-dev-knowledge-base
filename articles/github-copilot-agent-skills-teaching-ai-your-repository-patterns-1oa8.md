---
title: "GitHub Copilot Agent Skills: Teaching AI Your Repository Patterns"
url: "https://dev.to/qa-leaders/github-copilot-agent-skills-teaching-ai-your-repository-patterns-1oa8"
author: "Let's Automate"
category: "full-code-examples"
---

# GitHub Copilot Agent Skills: Teaching AI Your Repository Patterns
**Author:** Let's Automate
**Published:** December 20, 2025

## Overview
Introduction to GitHub Copilot Agent Skills feature for teaching AI assistants repository-specific patterns through structured SKILLS.md documentation files.

## Key Concepts

### Agent Skills Structure
Create `.github/skills/[skill-name]/SKILLS.md` files containing:
- Clear rules (must-do and must-not-do)
- Working code examples from your repository
- Project organization context
- Templates for common scenarios

### Self-Healing Selenium Example

```csharp
[When(@"I click the ""(.*)""")]
public async Task WhenIClickElement(string elementDescription)
{
    await _driver.Click(By.CssSelector(""), elementDescription);
}
```

### Rules Pattern
**Must:**
- Use self-healing WebDriver extensions
- Prefer element descriptions over raw locators
- Generate async step definitions
- Log all healing attempts

**Must Not:**
- Hardcode XPath or CSS selectors
- Use Thread.Sleep
- Bypass self-healing logic

### Requirements
- GitHub Copilot paid plan (Individual, Business, or Enterprise)
- 5-10 minute indexing delay for new files
- Currently repository-level only

### GitHub Repository
https://github.com/aiqualitylab/SeleniumSelfHealing.Reqnroll
