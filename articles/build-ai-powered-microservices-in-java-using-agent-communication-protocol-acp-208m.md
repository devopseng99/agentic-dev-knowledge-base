---
title: "Build AI-Powered Microservices in Java Using Agent Communication Protocol (ACP)"
url: "https://dev.to/vishalmysore/build-ai-powered-microservices-in-java-using-agent-communication-protocol-acp-208m"
author: "vishalmysore"
category: "a2a-protocols"
---

# Build AI-Powered Microservices in Java Using ACP
**Author:** vishalmysore
**Published:** September 1, 2025

## Overview
ACPJava framework transforms existing Spring Boot services into AI-accessible agents using simple annotations.

## Key Concepts

### Agent Definition

```java
@Service
@Agent(groupName ="foodpreferences",
       groupDescription = "Provide persons name and find out what they like")
public class SimpleService {
    @Action(description = "Get the favourite food of a person")
    public String whatThisPersonFavFood(String name) {
        if("vishal".equalsIgnoreCase(name))
            return "Paneer Butter Masala";
        else if ("vinod".equalsIgnoreCase(name))
            return "Aloo Kofta";
        else
            return "Something delicious";
    }
}
```

### Client Integration

```java
public class ACPClientExample {
    public static void main(String[] args) {
        ACPClient client = new ACPClient("http://localhost:7860");
        List<AgentManifest> agents = client.listAgents(10, 0);

        Message message = new Message();
        message.setRole(MessageRole.USER);
        MessagePart part = new MessagePart();
        part.setContent("What food does Vishal like?");
        message.setParts(List.of(part));

        Run result = client.executeSync("foodpreferences", List.of(message));
    }
}
```

### Key Features
- Auto-generated agent manifests
- Natural language request handling
- Only two annotations needed: @Agent and @Action
- Supports sync, async, and streaming execution modes
