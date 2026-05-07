---
title: "Building an AI-Powered CLI with Golang and Google Gemini"
url: "https://dev.to/pradumnasaraf/building-an-ai-powered-cli-with-golang-and-google-gemini-45a1"
author: "Pradumna Saraf"
category: "ai-agent-go-golang"
---

# Building an AI-Powered CLI with Golang and Google Gemini

**Author:** Pradumna Saraf
**Published:** August 27, 2024

## Overview
Build a CLI tool (GenCLI) using Golang, Cobra, and Google's Gemini API that enables text-based questions and image analysis directly from the terminal.

## Key Concepts

### Project Setup

```bash
go mod init github.com/Pradumnasaraf/go-ai
go install github.com/spf13/cobra-cli@latest
cobra-cli init
```

### Install Gemini SDK

```bash
go get github.com/google/generative-ai-go
export GEMINI_API_KEY=<YOUR_API_KEY>
```

### Create Search Subcommand

```bash
cobra-cli add search
```

### Gemini API Integration

```go
import (
    "context"
    "fmt"
    "log"
    "os"
    "github.com/google/generative-ai-go/genai"
    "github.com/spf13/cobra"
    "google.golang.org/api/option"
)

func getResponse(args []string) {
    userArgs := strings.Join(args[0:], " ")

    ctx := context.Background()
    client, err := genai.NewClient(ctx, option.WithAPIKey(os.Getenv("GEMINI_API_KEY")))
    if err != nil {
        log.Fatal(err)
    }
    defer client.Close()

    model := client.GenerativeModel("gemini-1.5-flash")
    resp, err := model.GenerateContent(ctx, genai.Text(userArgs))
    if err != nil {
        log.Fatal(err)
    }

    fmt.Println(resp.Candidates[0].Content.Parts[0])
}
```

### Dynamic Prompt Command

```go
var searchCmd = &cobra.Command{
    Use:   "search",
    Short: "Search using Gemini AI",
    Args:  cobra.MinimumNArgs(1),
    Run: func(cmd *cobra.Command, args []string) {
        getResponse(args)
    },
}
```

### Usage

```bash
go run main.go search "What is artificial intelligence?"
```

### Publishing

```bash
go install github.com/Pradumnasaraf/go-ai@latest
```
