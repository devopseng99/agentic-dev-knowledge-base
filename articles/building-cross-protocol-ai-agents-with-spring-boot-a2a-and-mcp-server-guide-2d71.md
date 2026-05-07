---
title: "Building Cross-Protocol AI Agents with Spring Boot: A2A and MCP Server Guide"
url: "https://dev.to/vishalmysore/building-cross-protocol-ai-agents-with-spring-boot-a2a-and-mcp-server-guide-2d71"
author: "vishalmysore"
category: "ai-agent-spring-boot-java"
---

# Building Cross-Protocol AI Agents with Spring Boot: A2A and MCP Server Guide

**Author:** vishalmysore
**Published:** May 28, 2025

## Overview

Guide demonstrating a Spring Boot application supporting both A2A (Agent-to-Agent) and MCP (Model Context Protocol) protocols for AI agent communication with integrated security features.

## Key Concepts

### Dependencies (pom.xml)

```xml
<dependency>
    <groupId>io.github.vishalmysore</groupId>
    <artifactId>a2ajava</artifactId>
    <version>0.1.8.2</version>
</dependency>
<dependency>
    <groupId>io.github.vishalmysore</groupId>
    <artifactId>tools4ai-annotations</artifactId>
    <version>0.0.2</version>
</dependency>
<dependency>
    <groupId>io.github.vishalmysore</groupId>
    <artifactId>tools4ai-security</artifactId>
    <version>0.0.3</version>
</dependency>
```

### Application Setup

```java
@SpringBootApplication
@EnableAgent
@EnableAgentSecurity  // Optional security
public class AgentApplication {
    public static void main(String[] args) {
        SpringApplication.run(AgentApplication.class, args);
    }
}
```

### Agent Service

```java
@Agent(groupName = "cooking", description = "Cooking related actions")
@Service
public class CookingService {

    @Action(description = "Compare two recipes")
    @PreAuthorize("hasRole('USER')")
    public String compareRecipes(String recipe1, String recipe2) {
        return "Comparison of " + recipe1 + " and " + recipe2;
    }

    @Action(description = "Get nutritional information")
    public String getNutrition(String dish) {
        return "Nutritional info for " + dish;
    }
}
```

### Security Configuration

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.httpBasic(Customizer.withDefaults())
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/.well-known/**").permitAll()
                .anyRequest().authenticated());
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

### Testing A2A Protocol

```bash
curl http://localhost:7860/.well-known/agent.json
```

### Testing MCP Protocol

```bash
curl -X POST http://localhost:7860/mcp \
  -u user:password \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/list","id":1}'
```
