---
title: "Adding DALL-E to your Elixir app"
url: "https://dev.to/byronsalty/adding-dall-e-to-your-elixir-app-16b5"
author: "Byron Salty"
category: "ai-image-video-generation"
---
# Adding DALL-E to your Elixir app
**Author:** Byron Salty  **Published:** 2024-01-03

## Overview
Documents integrating OpenAI's DALL-E 3 into an Elixir/Phoenix application (Teleprompt, an image generation game). Provides practical Elixir code for async image generation and S3 storage.

## Key Concepts

### Setup
Create an OpenAI account, generate an API key (`sk-...`), and store it in environment variables.

### Architecture
Uses a GenServer to asynchronously handle DALL-E requests. The GenServer pattern prevents blocking the main web request while waiting for image generation.

### API Request Implementation

**Endpoint:** `https://api.openai.com/v1/images/generations`

```elixir
defmodule Teleprompt.DalleServer do
  use GenServer

  def generate_image(prompt) do
    GenServer.cast(__MODULE__, {:generate, prompt})
  end

  def handle_cast({:generate, prompt}, state) do
    headers = [
      {"Authorization", "Bearer #{System.get_env("OPENAI_API_KEY")}"},
      {"Content-Type", "application/json"}
    ]

    body = Jason.encode!(%{
      model: "dall-e-3",
      prompt: prompt,
      n: 1,
      size: "1024x1024",
      quality: "standard"
    })

    case HTTPoison.post!("https://api.openai.com/v1/images/generations", body, headers) do
      %HTTPoison.Response{status_code: 200, body: response_body} ->
        image_data = Jason.decode!(response_body)
        image_url = get_in(image_data, ["data", Access.at(0), "url"])
        store_image(image_url)
      _ ->
        {:error, "Generation failed"}
    end

    {:noreply, state}
  end
end
```

### File Processing Strategy
Rather than relying on OpenAI's CDN URLs permanently:
1. Download generated images using `HTTPoison.get()`
2. Resize images for optimization
3. Upload to AWS S3 for persistent storage
4. Notify listeners via PubSub when complete

```elixir
defp store_image(url) do
  case HTTPoison.get(url) do
    {:ok, %HTTPoison.Response{body: image_data}} ->
      # Resize with ImageMagick or similar
      resized = resize_image(image_data)
      # Upload to S3
      ExAws.S3.put_object("my-bucket", "images/#{UUID.uuid4()}.png", resized)
      |> ExAws.request!()
      # Broadcast via PubSub
      Phoenix.PubSub.broadcast(MyApp.PubSub, "images", {:new_image, s3_url})
    _ ->
      {:error, "Download failed"}
  end
end
```

### Key Insights
- Use GenServer-based async pattern to avoid blocking web requests
- Always move images from OpenAI CDN to self-hosted infrastructure (URLs expire)
- Use `get_in()` with Access patterns for clean nested JSON extraction
- DALL-E 3 vs DALL-E 2: DALL-E 3 has better quality but higher cost; specify via `model` parameter
