---
title: "Build AI-Powered Microservices in Java Using Agent Communication Protocol (ACP)"
url: "https://dev.to/vishalmysore/build-ai-powered-microservices-in-java-using-agent-communication-protocol-acp-208m"
author: "vishalmysore"
category: "rust-go-java-agents"
---

# Build AI-Powered Microservices in Java Using Agent Communication Protocol (ACP)
**Author:** vishalmysore
**Published:** September 1, 2025

## Overview
ACPJava: annotation-driven framework converting Spring Boot classes into intelligent AI agents with zero boilerplate. @Agent and @Action annotations auto-generate manifests for AI system integration.

## Key Concepts

```java
@Service
@Agent(groupName = "foodpreferences", groupDescription = "Find out what people like to eat")
public class SimpleService {
    @Action(description = "Get the favourite food of a person")
    public String whatThisPersonFavFood(String name) {
        if ("vishal".equalsIgnoreCase(name)) return "Paneer Butter Masala";
        else return "Something delicious";
    }
}
```

```java
ACPClient client = new ACPClient("http://localhost:7860");
List<AgentManifest> agents = client.listAgents(10, 0);
MessagePart part = new MessagePart();
part.setContent("What food does Vishal like?");
Run result = client.executeSync("foodpreferences", List.of(message));
```
