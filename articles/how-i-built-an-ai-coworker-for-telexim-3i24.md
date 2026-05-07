---
title: "How I Built an AI Coworker for Telex.im"
url: "https://dev.to/i_ce_u/how-i-built-an-ai-coworker-for-telexim-3i24"
author: "Isaac"
category: "groq-api-agent"
---

# How I Built an AI Coworker for Telex.im

**Author:** Isaac
**Published:** November 3, 2025

## Overview
A conversational AI agent integrated with Telex.im that generates blog posts using Go, LangChain Go, and Groq's fast API (750+ tokens/second with Llama 3.1).

## Key Concepts

### Technology Stack
- **Go**: Speed and concurrency
- **LangChain Go**: Conversation and LLM management
- **Groq**: 750+ tokens/second inference with Llama 3.1
- **A2A JSON RPC 2.0**: Communication protocol
- **Telex.im**: Integration platform

### Configuration Module
```go
package config

import "os"

type Config struct {
    GroqAPIKey string
    Port       string
}

func Load() *Config {
    groqAPIKey := os.Getenv("GROQ_API_KEY")
    if groqAPIKey == "" {
        panic("GROQ_API_KEY not set")
    }
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }
    return &Config{
        GroqAPIKey: groqAPIKey,
        Port:       port,
    }
}
```

### Blog Service
```go
type BlogPostService struct {
    llm llms.Model
}

func NewBlogPostService(groqAPIKey string) *BlogPostService {
    llm, err := openai.New(
        openai.WithToken(groqAPIKey),
        openai.WithBaseURL("https://api.groq.com/openai/v1"),
        openai.WithModel("groq/compound"),
    )
    if err != nil {
        panic(fmt.Sprintf("failed to create blogpost service: %v", err))
    }
    return &BlogPostService{llm: llm}
}

func (s *BlogPostService) Generate(ctx context.Context, session *requests.SessionData, title string) (string, error) {
    messages := []llms.MessageContent{
        llms.TextParts(llms.ChatMessageTypeSystem, s.getSystemPrompt()),
        llms.TextParts(llms.ChatMessageTypeSystem, "You are a blog writer. Create engaging, well-structured blog posts."),
        llms.TextParts(llms.ChatMessageTypeHuman, fmt.Sprintf(`Create a cool blog post based on the following:
Title and Content: %s
Generate a well-structured blogpost with:
- A catchy headline
- An engaging introduction
- 3-4 key points or sections with clear headings
- A conclusion or call-to-action
Keep it concise and professional.`, title)),
    }

    memoryVars, err := session.Memory.LoadMemoryVariables(ctx, map[string]any{})
    if err == nil {
        if history, ok := memoryVars["history"].(string); ok && history != "" {
            messages = append(messages, llms.TextParts(llms.ChatMessageTypeHuman, history))
        }
    }
    messages = append(messages, llms.TextParts(llms.ChatMessageTypeHuman, title))

    response, err := s.llm.GenerateContent(ctx, messages, llms.WithTemperature(0.7))
    if err != nil {
        return "", err
    }
    return response.Choices[0].Content, nil
}
```

### Session Management
```go
type AgentService struct {
    llm      llms.Model
    blogSvc  *BlogService
    sessions map[string]*models.SessionData
    mu       sync.RWMutex
}

func (s *AgentService) getOrCreateSession(taskID string) *models.SessionData {
    s.mu.Lock()
    defer s.mu.Unlock()
    if session, exists := s.sessions[taskID]; exists {
        return session
    }
    session := &models.SessionData{
        ContextID: uuid.New().String(),
        History:   []models.HistoryMessage{},
        Memory:    memory.NewConversationBuffer(),
    }
    s.sessions[MessageID] = session
    return session
}
```

### Running
```bash
export GROQ_API_KEY="gsk_your_key_here"
go run main.go
```
