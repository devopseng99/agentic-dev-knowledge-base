---
title: "Why google/adk-go Is a Game Changer for Go Devs"
url: "https://dev.to/esrom_berhane_4fa205468a0/why-googleadk-go-is-a-game-changer-for-go-devs-and-why-you-cant-ignore-it-5h9g"
author: "ESROM BERHANE"
category: "rust-go-java-agents"
---

# Why google/adk-go Is a Game Changer for Go Devs
**Author:** ESROM BERHANE
**Published:** November 22, 2025

## Overview
Google's Agent Development Kit for Go: idiomatic design, model-agnostic (optimized for Gemini), built-in tools, multi-agent orchestration, session management, streaming events, cloud-native deployment.

## Key Concepts

```go
myAgent := agent.NewLLMAgent(ctx, "assistant",
    agent.WithModel(gemini),
    agent.WithInstruction("You are a helpful AI assistant."),
    agent.WithTools(searchTool),
)
sessSvc := session.NewInMemoryService()
sess, _ := sessSvc.CreateSession(ctx, "myApp", "user1", "sess1", nil)
for event, err := range myAgent.Run(ctx, ictx) {
    if event.Message != nil { fmt.Println("Agent:", event.Message.Text) }
}
```
