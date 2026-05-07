---
title: "A Practical Guide to Building AI Agents with Java and Spring AI - Part 5 - Add MCP"
url: "https://dev.to/yuriybezsonov/a-practical-guide-to-building-ai-agents-with-java-and-spring-ai-part-5-add-mcp-4h2o"
author: "Yuriy Bezsonov"
category: "rust-go-java-agents"
---

# Building AI Agents with Java and Spring AI - Part 5 - Add MCP
**Author:** Yuriy Bezsonov
**Published:** December 16, 2025

## Overview
Integrates Model Context Protocol into Spring AI agent. MCP Server exposes flight and hotel tools via Streamable HTTP. Client discovers tools automatically without hardcoding. Add capabilities by starting new MCP servers -- no recompilation needed.

## Key Concepts

```java
@Tool(description = "Find hotels in a city for specific dates.")
public List<Hotel> findHotelsByCity(String city, LocalDate checkInDate, Integer numberOfNights) {
    return hotelService.findHotelsByCity(city, checkInDate, numberOfNights);
}
```

```properties
spring.ai.mcp.client.toolcallback.enabled=true
spring.ai.mcp.client.streamablehttp.connections.travel.url=http://localhost:8082
```

- Independent deployment of MCP servers
- Team autonomy for different systems
- Scalability per component
- Reusability across applications
