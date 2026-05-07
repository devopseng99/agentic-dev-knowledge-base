---
title: "A Practical Guide to Building AI Agents with Java and Spring AI - Part 4 - Add Tools"
url: "https://dev.to/yuriybezsonov/a-practical-guide-to-building-ai-agents-with-java-and-spring-ai-part-4-add-tools-3g18"
author: "Yuriy Bezsonov"
category: "ai-agent-spring-boot-java"
---

# A Practical Guide to Building AI Agents with Java and Spring AI - Part 4 - Add Tools

**Author:** Yuriy Bezsonov
**Published:** November 25, 2025

## Overview

Demonstrates adding tool calling (function calling) capabilities to a Spring AI agent, enabling access to real-time information through external APIs.

## Key Concepts

### DateTimeService

```java
@Service
public class DateTimeService {
    @Tool(description = """
        Get current date and time in specified timezone.
        Parameters:
        - timeZone: e.g., 'UTC', 'America/New_York'
        Returns: ISO format (YYYY-MM-DDTHH:MM:SS)
        """)
    public String getCurrentDateTime(String timeZone) {
        return ZonedDateTime.now(ZoneId.of(timeZone))
                .format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }
}
```

### WeatherService

```java
@Service
public class WeatherService {
    private final WebClient webClient;

    public WeatherService(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.build();
    }

    @Tool(description = """
        Get weather forecast for a city on a specific date.
        Requires: city and date (YYYY-MM-DD format)
        Returns: Weather forecast with min/max temperatures.
        """)
    public String getWeather(String city, String date) {
        // Step 1: Geocoding API call to get coordinates
        String geoUrl = String.format(
            "https://geocoding-api.open-meteo.com/v1/search?name=%s&count=1",
            city);
        GeoResponse geo = webClient.get().uri(geoUrl)
            .retrieve().bodyToMono(GeoResponse.class).block();

        // Step 2: Weather API call
        String weatherUrl = String.format(
            "https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&daily=temperature_2m_max,temperature_2m_min&start_date=%s&end_date=%s",
            geo.latitude(), geo.longitude(), date, date);

        WeatherResponse weather = webClient.get().uri(weatherUrl)
            .retrieve().bodyToMono(WeatherResponse.class).block();

        return String.format("Weather in %s on %s: Min %.1f C, Max %.1f C",
            city, date, weather.minTemp(), weather.maxTemp());
    }
}
```

### Registering Tools with ChatClient

```java
@Service
public class ChatService {

    private final ChatClient chatClient;

    public ChatService(ChatClient.Builder chatClientBuilder,
                       DateTimeService dateTimeService,
                       WeatherService weatherService,
                       VectorStore vectorStore) {
        this.chatClient = chatClientBuilder
                .defaultSystem(SYSTEM_PROMPT)
                .defaultAdvisors(QuestionAnswerAdvisor.builder(vectorStore).build())
                .defaultTools(dateTimeService, weatherService)
                .build();
    }

    public Flux<String> streamResponse(String prompt) {
        return chatClient.prompt()
                .user(prompt)
                .stream()
                .content();
    }
}
```

### Dependencies

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webflux</artifactId>
</dependency>
```

## How Tool Calling Works

1. User asks a question (e.g., "What's the weather in Paris next week?")
2. AI analyzes and determines which tools to call
3. Tools fetch real-time data (weather, dates, etc.)
4. AI synthesizes results into a natural response

The `@Tool` annotation marks methods as callable by the AI. Spring AI handles the serialization/deserialization of parameters and results automatically.
