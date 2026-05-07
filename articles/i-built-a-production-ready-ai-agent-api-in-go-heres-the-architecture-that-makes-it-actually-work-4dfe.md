---
title: "I Built a Production-Ready AI Agent API in Go -- Here's the Architecture That Makes It Actually Work"
url: "https://dev.to/itodona/i-built-a-production-ready-ai-agent-api-in-go-heres-the-architecture-that-makes-it-actually-work-4dfe"
author: "Izu Tolandona"
category: "ai-agent-go-golang"
---

# I Built a Production-Ready AI Agent API in Go

**Author:** Izu Tolandona
**Published:** February 21, 2026

## Overview
Production-ready AI Agent API in Go with JWT authentication, API key management, rate limiting, workflow engine (Eino), streaming responses via SSE, and human-in-the-loop approvals. 18MB Docker image, runs on $6/month VPS. Uses DDD architecture with strict inward dependency.

## Key Concepts

### Why Go for AI Agents
- **Memory:** 10-20MB RAM at idle vs 80-150MB for Python FastAPI
- **Cold start:** Milliseconds vs 2 seconds for Python
- **Single binary:** No requirements.txt, no virtual environments
- **Concurrency:** Goroutines are 2KB stack, handles thousands of concurrent sessions
- **Type safety:** Compiler catches shape mismatches at compile time

### Project Structure (DDD)

```
go-agent-api/
  cmd/api/main.go              # DI container
  internal/
    domain/                    # Pure Go, zero external deps
      entity/                  # User, Token, Conversation, Message
      repository/              # Interfaces only
      service/                 # Domain services
    application/               # Orchestration, depends only on domain
      usecase/                 # auth/, chat/, tool/, user/
      dto/                     # Request/response shapes
      port/                    # Interfaces for external services
    infrastructure/            # The outside world
      eino/                    # Workflow graph and state
      http/                    # Handlers, middleware, router
      llm/                     # LiteLLM client
      persistence/             # PostgreSQL repos + Redis
```

### Dependency Rule

```go
// DOMAIN: knows nothing about PostgreSQL
type UserRepository interface {
    FindByEmail(ctx context.Context, email string) (*entity.User, error)
}

// INFRASTRUCTURE: implements the domain interface
type userRepository struct {
    pool *pgxpool.Pool
}
func (r *userRepository) FindByEmail(ctx context.Context, email string) (*entity.User, error) {
    // pgx query here
}
```

### Explicit DI in main.go

```go
// Database
db, err := postgres.NewConnection(ctx, cfg.Database)
redisClient, err := redis.NewConnection(ctx, cfg.Redis)

// Repositories
userRepo := postgres.NewUserRepository(db)
tokenRepo := postgres.NewTokenRepository(db)
convRepo := postgres.NewConversationRepository(db)

// LLM Provider
llmProvider := litellm.NewClient(cfg.LLM.BaseURL, cfg.LLM.APIKey)

// Tool Registry
toolRegistry := tool.NewToolRegistry()
toolRegistry.RegisterAll(
    builtin.NewCalculatorTool(),
    builtin.NewWebSearchTool(cfg.Tools.WebSearchAPIKey),
)

// Use Cases
sendMessageUC := chat.NewSendMessageUseCase(convRepo, msgRepo, llmProvider, cfg.LLM.DefaultModel)
```

### Docker Compose Stack

```yaml
services:
  api:         # Go binary (128MB memory limit)
  postgres:    # PostgreSQL 16
  redis:       # Redis 7
  litellm:     # LLM proxy (GPT-4o, Claude, Gemini)
  migrate:     # golang-migrate
```

### Adding a New Tool

```go
type WeatherTool struct{ tool.BaseTool }
func (t *WeatherTool) Name() string { return "get_weather" }

// In main.go:
toolRegistry.RegisterAll(builtin.NewWeatherTool(cfg.Tools.WeatherAPIKey))
```

### Quick Start

```bash
git clone https://github.com/wyuneed/go-agent-api
cd go-agent-api
cp .env.example .env
make docker-up
make migrate-up
make run
```
