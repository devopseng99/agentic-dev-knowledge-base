---
title: "A Practical Guide to Building AI Agents with Java and Spring AI - Part 6: Multi-Modal Multi-Model"
url: "https://dev.to/yuriybezsonov/a-practical-guide-to-building-ai-agents-with-java-and-spring-ai-part-6-multi-modal-multi-model-3664"
author: "Yuriy Bezsonov"
category: "multimodal"
---

# A Practical Guide to Building AI Agents with Java and Spring AI - Part 6: Multi-Modal Multi-Model

**Author:** Yuriy Bezsonov
**Date Published:** December 22, 2025
**Tags:** #java #springboot #tutorial #ai

---

## Overview

This article extends a multi-part series on building AI agents with Java and Spring AI. Part 6 introduces multi-modal capabilities (vision and document analysis) and multi-model support to enable agents to process images, extract structured data from receipts, and utilize different AI models for specific tasks.

## Key Problem Statement

Text-only AI agents cannot analyze images, extract information from receipts or invoices, process travel documents, interpret diagrams, or verify expense compliance from uploaded files. Users expect to upload receipt photos and have the AI automatically extract amounts, dates, merchants, and policy compliance information.

## Core Concepts

### Multi-Modal AI
Models that process multiple input types: text, images, documents, PDFs, screenshots, and diagrams combined with natural language prompts.

### Multi-Model Architecture
Using different AI models optimized for different tasks:
- Chat Model: Conversational interactions and reasoning
- Document Model: Vision and document analysis
- Embedding Model: Semantic search and RAG

## Implementation Architecture

```
User Request
     |
[ChatController]
     |
Has Image/Document?
     |-- Yes -> [DocumentChatService] -> Vision Model (Claude Sonnet)
     |-- No  -> [ChatService] -> Chat Model (Claude Sonnet/Amazon Nova)
                 |
           [Memory + RAG + MCP Tools]
                 |
             Response
```

## Configuration

Add model configuration to `application.properties`:

```properties
# Document processing model (vision-capable)
ai.agent.document.model=global.anthropic.claude-sonnet-4-5-20250929-v1:0
```

## DocumentChatService Implementation

```java
package com.example.ai.agent.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.model.tool.ToolCallingChatOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.MediaType;
import org.springframework.http.MediaTypeFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeType;
import org.springframework.util.MimeTypeUtils;
import reactor.core.publisher.Flux;
import java.util.Base64;

@Service
public class DocumentChatService {
    private static final Logger logger = LoggerFactory.getLogger(DocumentChatService.class);

    private final ChatClient documentChatClient;
    private final ChatService chatService;

    @Value("${ai.agent.document.model}")
    private String documentModel;

    public static final String DOCUMENT_ANALYSIS_PROMPT = """
        Extract expense information from this document.

        Required fields:
        - Document Type: [RECEIPT, INVOICE, TICKET, BILL, OTHER]
        - Expense Type: [MEALS, ACCOMMODATION, TRANSPORTATION, OFFICE_SUPPLIES, OTHER]
        - Amount and Currency
        - Date: [YYYY-MM-DD]

        Category-specific details:
        - ACCOMMODATION: check-in/out dates, nights, rate per night, location
        - MEALS: contains alcohol (yes/no)
        - TRANSPORTATION: type, route or location

        Check against the Expense Policy and provide approval status with reasoning.
        If not an expense document, provide a brief summary.
        For missing information, state "I don't know".
        """;

    public DocumentChatService(ChatModel chatModel, ChatService chatService) {
        this.documentChatClient = ChatClient.builder(chatModel)
                .defaultSystem(DOCUMENT_ANALYSIS_PROMPT)
                .build();
        this.chatService = chatService;
    }

    public Flux<String> processDocument(String prompt, String fileBase64, String fileName) {
        logger.info("Processing document: {}", fileName);

        return Flux.create(sink -> {
            // 1. Emit immediate feedback
            sink.next("Analyzing document...\n\n");

            // 2. Analyze document with multimodal AI
            String documentAnalysis = analyzeDocument(prompt, fileBase64, fileName);

            // 3. Stream structured summary with currency conversion
            String summaryPrompt = documentAnalysis + "\n\n" +
                "Based on the extracted information, provide a structured summary including:\n" +
                "- Amount in EUR: If original currency is EUR, use original amount. " +
                "Otherwise, convert to EUR using the document date (or current date if unavailable).\n\n" +
                "After presenting the information, ask the user to confirm and offer to register the expense.";

            chatService.processChat(summaryPrompt)
                .subscribe(
                    chunk -> sink.next(chunk),
                    error -> sink.error(error),
                    () -> sink.complete()
                );
        });
    }

    private String analyzeDocument(String prompt, String fileBase64, String fileName) {
        MimeType mimeType = determineMimeType(fileName);
        byte[] fileData = Base64.getDecoder().decode(fileBase64);
        ByteArrayResource resource = new ByteArrayResource(fileData);

        String userPrompt = (prompt != null && !prompt.trim().isEmpty())
                ? prompt
                : "Analyze this document";

        try {
            var chatResponse = documentChatClient
                    .prompt()
                    .options(ToolCallingChatOptions.builder()
                            .model(documentModel)
                            .build())
                    .user(userSpec -> {
                        userSpec.text(userPrompt);
                        userSpec.media(mimeType, resource);
                    })
                    .call().chatResponse();

            return (chatResponse != null)
                ? chatResponse.getResult().getOutput().getText()
                : "I don't know - no response received.";
        } catch (Exception e) {
            logger.error("Error analyzing document", e);
            return "I don't know - there was an error analyzing the document.";
        }
    }

    private MimeType determineMimeType(String fileName) {
        if (fileName != null && !fileName.trim().isEmpty()) {
            MediaType mediaType = MediaTypeFactory.getMediaType(fileName)
                    .orElse(MediaType.APPLICATION_OCTET_STREAM);
            return new MimeType(mediaType.getType(), mediaType.getSubtype());
        }
        return MimeTypeUtils.APPLICATION_OCTET_STREAM;
    }
}
```

## ChatController Updates

```java
import com.example.ai.agent.service.DocumentChatService;
    ...
    private final DocumentChatService documentChatService;

    public ChatController(ChatService chatService,
                         ChatMemoryService chatMemoryService,
                         ConversationSummaryService summaryService,
                         DocumentChatService documentChatService) {
        this.chatService = chatService;
        this.chatMemoryService = chatMemoryService;
        this.summaryService = summaryService;
        this.documentChatService = documentChatService;
    }

    @PostMapping(value = "message", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    public Flux<String> chat(@RequestBody ChatRequest request, Principal principal) {
        String userId = getUserId(request.userId(), principal);
        chatMemoryService.setCurrentUserId(userId);

        // Route to document analysis or regular chat
        return hasFile(request)
            ? documentChatService.processDocument(request.prompt(), request.fileBase64(), request.fileName())
            : chatService.processChat(request.prompt());
    }

    ...

    private boolean hasFile(ChatRequest request) {
        return request.fileBase64() != null && !request.fileBase64().trim().isEmpty();
    }

    public record ChatRequest(String prompt, String userId, String fileBase64, String fileName) {}
    ...
```

## Testing Multi-Modal Capabilities

Run the application:
```bash
./mvnw spring-boot:test-run
```

Download sample ticket image:
```bash
curl -o ticket-tram-cz.png https://raw.githubusercontent.com/aws-samples/java-on-aws/main/samples/spring-ai-te-agent/ai-agent/samples/ticket-tram-cz.png
```

Test through the UI at `http://localhost:8080`:
1. Click file upload button
2. Select ticket image
3. Type "Analyze this expense receipt"
4. Click Send

Expected output includes document type, amount, currency, expense category, and policy compliance status.

## How Multi-Modal Processing Works

1. Image upload: Browser converts image to base64
2. Routing: ChatController detects file and routes to DocumentChatService
3. Vision analysis: Claude Sonnet analyzes image and extracts expense data
4. Policy check: RAG retrieves relevant expense policies
5. Currency conversion: Tools convert amounts to EUR if needed
6. Structured response: Formats results with approval status

## Benefits of Multi-Model Architecture

- **Cost optimization:** Use cheaper models for simple chat, vision-capable models for documents
- **Performance optimization:** Specialized models for specific tasks
- **Capability matching:** Deploy models with appropriate strengths
- **Flexibility:** Switch models without code changes

## Key Takeaways

This article demonstrates building enterprise-ready AI agents with complete capabilities: memory management, knowledge bases, real-time information access, dynamic tool integration, and multi-modal document processing. The architecture enables seamless switching between different AI models based on task requirements while maintaining a unified user interface.

## Series Navigation

- Part 1: Create an AI Agent
- Part 2: Add Memory
- Part 3: Add Knowledge
- Part 4: Add Tools
- Part 5: Add MCP
- Part 6: Multi-Modal Multi-Model (current)

## Additional Resources

- Spring AI Multi-Modal Documentation
- Amazon Bedrock Converse API
- Claude Vision Capabilities
- Amazon Nova Models
