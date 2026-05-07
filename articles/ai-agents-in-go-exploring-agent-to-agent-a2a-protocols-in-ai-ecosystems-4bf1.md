---
title: "AI Agents in Go: Exploring Agent-to-Agent (A2A) Protocols in AI Ecosystems"
url: "https://dev.to/beryldev/ai-agents-in-go-exploring-agent-to-agent-a2a-protocols-in-ai-ecosystems-4bf1"
author: "Beryl Christine Atieno"
category: "rust-go-java-agents"
---

# AI Agents in Go: Exploring Agent-to-Agent (A2A) Protocols in AI Ecosystems
**Author:** Beryl Christine Atieno
**Published:** November 3, 2025

## Overview
Builds a customer profile generator in Go using A2A protocols, integrating Gemini AI with the Telex messaging platform. Demonstrates structured agent communication without centralized control.

## Key Concepts

```go
func (g *GeminiClient) buildPrompt(businessIdea string) string {
    return fmt.Sprintf(`You are an expert market researcher. Based ONLY on the business idea "%s", generate a SINGLE, concise customer profile.`, businessIdea)
}

type A2AMessage struct {
    ID    string        `json:"id"`
    Parts []MessagePart `json:"parts"`
}

func (h *A2AHandler) HandleMessage(c *gin.Context) {
    var msg A2AMessage
    if err := c.BindJSON(&msg); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid A2A message"})
        return
    }
    businessIdea := h.extractBusinessIdea(msg)
    response := h.generateProfile(businessIdea)
    c.JSON(http.StatusOK, gin.H{"response": response})
}
```
