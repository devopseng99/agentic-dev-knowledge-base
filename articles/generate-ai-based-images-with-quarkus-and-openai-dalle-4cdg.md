---
title: "Generate AI-based Images with Quarkus and OpenAI DALL.E"
url: "https://dev.to/fushji/generate-ai-based-images-with-quarkus-and-openai-dalle-4cdg"
author: "Antonio Perrone"
category: "ai-media-generation"
---
# Generate AI-based Images with Quarkus and OpenAI DALL.E
**Author:** Antonio Perrone  **Published:** August 21, 2023

## Overview
This tutorial demonstrates integrating OpenAI's image generation API with Quarkus using REST Client Reactive. The author guides developers through building a Java application that accepts text prompts and returns AI-generated images via DALL.E.

## Key Concepts

- OpenAI DALL.E API integration
- Quarkus REST Client Reactive framework
- Declarative REST client patterns with Jakarta EE annotations
- API authentication via bearer tokens
- Response handling and URI redirects

```java
public class CreateImageRequest {
    @JsonProperty("prompt")
    private String prompt;
    @JsonProperty("n")
    private int n;
    @JsonProperty("size")
    private String size;
    // getters/setters
}
```

```java
@RegisterRestClient(baseUri = "https://api.openai.com")
@Path("/v1")
public interface OpenAIRestClient {
    @POST
    @Path("/images/generations")
    @ClientHeaderParam(name = "Authorization", value = "Bearer ${openai.api.key}")
    CreateImageResponse generateImage(CreateImageRequest request);
}
```

```java
@Path("/quarkus-openai")
public class OpenAIEndpoint {
    @RestClient
    private OpenAIRestClient openAIRestClient;
    
    @GET
    @Path("/generate-image")
    public Response generateImage(@QueryParam("description") String description) {
        // Implementation
    }
}
```

```bash
mvn io.quarkus.platform:quarkus-maven-plugin:3.2.3.Final:create \
-DprojectGroupId=com.foojay.openai \
-Dextensions='resteasy-reactive-jackson,rest-client-reactive-jackson'
```

- GitHub: https://github.com/fushji/quarkus-openai-app
