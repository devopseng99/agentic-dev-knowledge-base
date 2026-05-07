---
title: "Build AI-Powered Microservices in Java Using Agent Communication Protocol (ACP)"
url: "https://dev.to/vishalmysore/build-ai-powered-microservices-in-java-using-agent-communication-protocol-acp-208m"
author: "vishalmysore"
category: "ai-agent-spring-boot-java"
---

# Build AI-Powered Microservices in Java Using Agent Communication Protocol (ACP)

**Author:** vishalmysore
**Published:** September 1, 2025

## Overview

Introduces ACPJava, a lightweight, annotation-driven Java framework that converts Spring Boot classes into intelligent AI agents with zero boilerplate, enabling existing services to become AI-accessible without rewriting the codebase.

## Key Concepts

### Primary Annotations

- `@Agent` - Marks a service as an AI agent with group metadata
- `@Action` - Designates methods as discoverable capabilities

### Simple Agent Example

```java
@Agent(groupName = "food", description = "Food preference actions")
@Service
public class FoodPreferenceService {

    @Action(description = "Get food preferences for a person")
    public String getFoodPreference(String personName) {
        // Business logic
        if (personName.equalsIgnoreCase("John")) {
            return "Pizza, Pasta, Salad";
        }
        return "No preferences found";
    }
}
```

### Multi-Action Agent

```java
@Agent(groupName = "automotive", description = "Car-related services")
@Service
public class CarService {

    @Action(description = "Compare two cars on features and price")
    public String compareCars(String car1, String car2) {
        return "Comparing " + car1 + " vs " + car2;
    }

    @Action(description = "Process a cash purchase for a car")
    public String purchaseCash(String carModel, double amount) {
        return "Cash purchase of " + carModel + " for $" + amount;
    }

    @Action(description = "Calculate loan-based financing")
    public String purchaseLoan(String carModel, double downPayment, int termMonths) {
        return "Loan for " + carModel + ": $" + downPayment + " down, " + termMonths + " months";
    }
}
```

### Client Integration

```java
ACPClient client = new ACPClient("http://localhost:8080");

// Discover available agents
List<AgentManifest> agents = client.discoverAgents();

// Natural language request
String result = client.sendRequest(
    "Compare Tesla Model 3 and BMW i4"
);
```

### Auto-Generated Manifests

The framework automatically creates comprehensive metadata describing available agents and capabilities, enabling external systems to discover and interact with agents programmatically.

## Key Features

1. Auto-generated agent manifests
2. Natural language request mapping to specific agent actions
3. Seamless communication flow from AI clients to business logic
4. Zero boilerplate required
