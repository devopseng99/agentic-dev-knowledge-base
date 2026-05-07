---
title: "AI Agents - Introduction and Customer Support AI Agent Example"
url: https://dev.to/anishghimire862/ai-agents-introduction-and-customer-support-ai-agent-example-531e
author: Anish Ghimire
category: ai-agents-customer-support
---

# AI Agents - Introduction and Customer Support AI Agent Example

**Author:** Anish Ghimire
**Published:** October 14, 2025
**Original Source:** sarvalekh.com

---

## Article Summary

This comprehensive guide explores artificial intelligence agents, their types, and practical implementation through a customer support example using Node.js and Ollama.

## Key Sections

### What is an AI Agent?

"An Artificial Intelligence (AI) Agent is a software program that can perceive its environment, make decisions, and autonomously perform tasks to achieve predefined or dynamic goals."

### Types of AI Agents

1. **Reactive Agents** - React to immediate stimuli without memory (vacuum cleaners, traffic systems)
2. **Goal-Based Agents** - Plan actions to achieve specific goals (autonomous vehicles)
3. **Utility-Based Agents** - Maximize overall value and optimize performance (self-driving cars)
4. **Learning Agents** - Improve through environmental interaction (Netflix recommendations, YouTube)

### Connection with Generative AI

Generative AI models generate content from prompts and training data, while "AI agents go beyond Gen AI by making decisions and taking actions autonomously."

### Why AI Agents Are Required

- Bridge gaps between LLM training data and domain-specific knowledge
- Enable custom knowledge base access
- Automate tasks beyond text generation (database queries, real-time data retrieval)
- Provide adaptability and contextual awareness

## Practical Implementation

### Architecture Overview

The customer support agent includes:
- Custom knowledge base (JSON file)
- LLM integration (Qwen2.5 via Ollama)
- Node.js middleware layer
- POST API endpoint for query processing

### Code Examples

**Knowledge Base Loading:**
```javascript
let knowledgeBase = {}
fs.readFile('knowledge.json', 'utf8', (err, data) => {
  if (err) {
    console.error('Error reading knowledge base:', err)
  } else {
    knowledgeBase = JSON.parse(data)
  }
})
```

**Query Processing Function:**
```javascript
async function runQuery(query) {
  const knowledgeContent = JSON.stringify(knowledgeBase)
  const prompt = `
    You are an intelligent customer support agent...
    Here is the knowledge base:
    ${knowledgeContent}
    The user has asked: "${query}"
  `

  try {
    const response = await axios.post('http://localhost:11434/api/generate', {
      model: 'qwen2.5',
      prompt: prompt,
      temperature: 0.7,
      stream: false,
    })
    return response.data?.response || 'Answer not found.'
  } catch (error) {
    console.error('Error querying Ollama:', error)
    return 'Sorry, there was an error processing your request.'
  }
}
```

**API Endpoint:**
```javascript
app.post('/query', async (req, res) => {
  const query = req.body.query.trim()
  const response = await runQuery(query)
  res.json({ response })
})
```

**Example Request:**
```bash
curl -X POST http://localhost:3000/query \
     -H "Content-Type: application/json" \
     -d '{"query": "I am unable to activate my account.."}'
```

## Key Takeaways

- AI agents leverage LLMs for intelligence while autonomously integrating external tools
- Knowledge bases can take multiple formats (FAQs, databases, PDFs, images, audio, video)
- Text-based processing requires additional steps for non-text knowledge sources
- The demonstrated implementation provides a foundation for more complex agent systems
- Complete source code available on GitHub
