---
title: "Building AI Agents with A2A and MCP Protocol: A Hands-on Implementation Guide"
url: "https://dev.to/vishalmysore/building-ai-agents-with-a2a-and-mcp-protocol-a-hands-on-implementation-guide-4fbl"
author: "vishalmysore"
category: "a2a-protocols"
---

# Building AI Agents with A2A and MCP Protocol: A Hands-on Implementation Guide
**Author:** vishalmysore
**Published:** June 7, 2025

## Overview
Comprehensive implementation guide for AI agents using A2A and MCP protocols across four JVM languages (Java, Scala, Kotlin, Groovy), with deployment strategies, security, multi-server setup, and agentic mesh patterns.

## Key Concepts

A2A is for agent-to-agent communication; MCP is for agent-to-tool integration.

### Java + Spring Boot Implementation

```java
@SpringBootApplication
@EnableAgent
public class Application {
}

@Service
@Agent(groupName = "food preferences", groupDescription = "Provide persons name and find out what they like")
public class SimpleService {
 @Action(description = "Get the favourite food of a person")
 public String whatThisPersonFavFood(String name) {
  if("vishal".equalsIgnoreCase(name))
   return "Paneer Butter Masala";
  else if ("vinod".equalsIgnoreCase(name))
   return "aloo kofta";
  else
   return "something yummy";
 }
}
```

Any method annotated with @Action becomes automatically exposed as an A2A or MCP tool. Agent card at: `https://localhost:7860/.well-known/agent.json`

### Kotlin Implementation

```kotlin
@Agent(
 groupName = "GeoSpatial Route Planner Agent",
 groupDescription = "Provides route planning, traffic analysis, and map generation"
)
class RoutePlannerAgent {
 @Action(description = "Generates custom map with points of interest")
 fun generateCustomMap(points: List<String>, radius: Double): String {
  return "Custom map generated with ${points.size} points within $radius mile radius"
 }
}
```

### Adding Security with Spring Security

```java
@Agent(groupName = "car booking", groupDescription = "actions related to car booking")
public class CarBookingAgent {
 @PreAuthorize("hasRole('USER')")
 @Action(description = "Book a car for the given details")
 public String bookCar(String carType, String pickupLocation, String dropLocation) {
  return "Car of type " + carType + " booked from " + pickupLocation + " to " + dropLocation;
 }

 @PreAuthorize("hasRole('ADMIN')")
 @Action(description = "Cancel a car booking")
 public String cancelCarBooking(String bookingId) {
  return "Booking " + bookingId + " cancelled";
 }
}
```

### A2A Client

```java
A2AAgent a2aagent = new A2AAgent();
a2aagent.connect("http://localhost:7860/");
Object task = a2aagent.remoteMethodCall("get me list of books");
```

### MCP Client

```java
MCPAgent mcpAgent = new MCPAgent();
mcpAgent.connect("https://vishalmysore-a2amcpspring.hf.space/");
AgentInfo mcpCard = mcpAgent.getInfo();
CallToolResult result = (CallToolResult) mcpAgent.remoteMethodCall("holdBook",
 "vishal needs to read harry potter book 1");
```

### Agentic Mesh with AgentCatalog

```java
AgentCatalog agentCatalog = new AgentCatalog();
agentCatalog.addAgent("http://localhost:7862/");
agentCatalog.addAgent("http://localhost:7863/");
String answer = agentCatalog.processQuery("what is the recipe for Gulab Jamun").getTextResult();
```

### Claude Desktop Integration

```json
{
 "mcpServers": {
  "yogaserver": {
   "command": "java",
   "args": ["-jar", "PATH_TO_YOUR_JAR/mcp-connector-full.jar", "http://localhost:7866"],
   "timeout": 30000
  }
 }
}
```

### Mesh Patterns
- Sequential chains, voting, fallback, concurrent calls
- Actor-based mesh with Akka-style behaviors
- Reactive streams for task processing
