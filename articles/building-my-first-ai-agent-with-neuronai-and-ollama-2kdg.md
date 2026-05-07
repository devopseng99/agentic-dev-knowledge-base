---
title: "Building My First AI Agent with Neuron AI and Ollama"
url: "https://dev.to/robertobutti/building-my-first-ai-agent-with-neuronai-and-ollama-2kdg"
author: "Roberto B."
category: "ai-agents"
---

# Building My First AI Agent with Neuron AI and Ollama

**Author:** Roberto B.
**Date Published:** March 29, 2025 (Updated October 3, 2025)
**Tags:** #ai #php #tutorial #llm

## Overview

Roberto B. shares his journey creating an AI agent using Neuron AI and Ollama to automate technical article reviews. The project demonstrates integrating local AI models into PHP applications while maintaining privacy and control.

## Key Technologies

- **Neuron AI**: A lightweight PHP framework that simplifies AI integration
- **Ollama**: Local AI model runner ensuring privacy-focused execution
- **Gemma**: Google DeepMind's efficient, open LLM family
- **PHP**: Server-side scripting language for automation and system tools

## Why Neuron AI?

The framework offers four primary advantages:

1. **Simplicity** -- Abstracts complex AI interactions for straightforward integration
2. **Flexibility** -- Supports multiple AI providers for easy model switching
3. **Extensibility** -- Enables custom agents tailored to specific use cases
4. **Local execution** -- Integrates with Ollama for cloud-free AI processing

## Setup Instructions

### Installation

```bash
composer require neuron-core/neuron-ai
```

**Note:** The correct package is `neuron-core/neuron-ai` (not the deprecated `inspector-apm/neuron-ai`).

## Implementation: ReviewerAgent

### Complete Code Example

```php
<?php

use NeuronAI\Agent;
use NeuronAI\Chat\Messages\UserMessage;
use NeuronAI\Providers\AIProviderInterface;
use NeuronAI\Providers\Ollama\Ollama;
use NeuronAI\SystemPrompt;

require './vendor/autoload.php';

class ReviewerAgent extends Agent
{
    public function provider(): AIProviderInterface
    {
        return new Ollama(
            url: "http://localhost:11434/api",
            model: "gemma3:4b"
        );
    }

    public function instructions(): string
    {
        $prompt = "Review and rewrite the following article in clear, grammatically correct, and professional English. Improve readability, correct any errors, and ensure the tone remains neutral and coherent. Do not change the meaning of the text. Output only the corrected and polished version of the article.";
        return (string) new SystemPrompt(
            background: [
                $prompt
            ],
        );
    }
}

$reviewerAgent = ReviewerAgent::make();
$articleMarkdownFile = './article-1.md';

try {
    $response = $reviewerAgent->chat(
        new UserMessage("This is the article: " . file_get_contents($articleMarkdownFile))
    );
    echo $response->getContent();
} catch (Exception $e) {
    echo 'Error: ' . $e->getMessage() . PHP_EOL;
    echo 'Error: Unable to communicate with the AI service. Please ensure Ollama is running.' . PHP_EOL;
}
```

## How It Works

The `ReviewerAgent` class extends `Agent` and implements two critical methods:

**1. Provider Method**
Specifies Ollama as the backend, running the Gemma 3 4B model locally. This design allows easy provider switching to OpenAI or other platforms.

**2. Instructions Method**
Defines the agent's role and behavior through a system prompt, establishing context for article analysis and improvement suggestions.

## Execution

Ensure Ollama is running at `http://localhost:11434`, then execute:

```bash
php my-agent.php
```

The agent will process the markdown file and output improved content.

## Best Practices for Maintenance

- **Update dependencies** regularly for security patches and performance improvements
- **Monitor responses** to ensure alignment with intended use cases
- **Optimize performance** through prompt refinement and model experimentation
- **Implement logging** for troubleshooting and accuracy improvement
- **Validate inputs** to prevent security vulnerabilities

## Key Takeaways

Creating AI agents in PHP is accessible and practical. Neuron AI's developer-friendly approach combined with Ollama's local execution capability enables building intelligent applications that prioritize privacy and control without cloud dependencies.

## Resources

- [Neuron AI GitHub Repository](https://github.com/neuron-core/neuron-ai)
- [Neuron AI Documentation](https://docs.neuron-ai.dev/)
- [Ollama](https://ollama.ai/)
- [Gemma Models](https://deepmind.google/models/gemma/)
