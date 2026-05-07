---
title: "Calling LangChain from Go (Part 1)"
url: "https://dev.to/aairom/calling-langchain-from-go-part-1alain-airom-ayrom-18i2"
author: "Alain Airom"
category: "rust-go-java-agents"
---

# Calling LangChain from Go (Part 1)
**Author:** Alain Airom
**Published:** December 31, 2024

## Overview
Explores integrating LangChain with Go using the langchaingo repository, demonstrating IBM watsonx.ai integration with a Fyne-based dialog interface and tiktoken-go token counting.

## Key Concepts

```go
package main

import (
    "context"
    "fmt"
    "log"
    "os"
    "github.com/joho/godotenv"
    "github.com/tmc/langchaingo/llms"
    "github.com/tmc/langchaingo/llms/watsonx"
)

func main() {
    err := godotenv.Load()
    if err != nil { log.Fatal("Error loading .env file") }
    model := "ibm/granite-13b-instruct-v2"
    llm, err := watsonx.New(model)
    if err != nil { log.Fatal(err) }
    ctx := context.Background()
    completion, err := llms.GenerateFromSinglePrompt(ctx, llm, prompt)
    if err != nil { log.Fatal(err) }
    fmt.Println(completion)
}
```
