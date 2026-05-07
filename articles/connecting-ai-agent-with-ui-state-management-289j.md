---
title: "Connecting AI Agent with UI - State Management"
url: "https://dev.to/shaikr786/connecting-ai-agent-with-ui-state-management-289j"
author: "Reshma Shaik"
category: "ai-agent-image-generation"
---

# Connecting AI Agent with UI - State Management

**Author:** Reshma Shaik
**Published:** February 28, 2025

## Overview
Building an AI image generation tool in Next.js using CopilotKit and Unsplash API with React state management hooks.

## Key Concepts

### State Management

```typescript
const [images, setImages] = useState<ImageObject[]>([]);
const [imagePrompt, setImagePrompt] = useState<string>("");
const [needsUserInput, setNeedsUserInput] = useState(false);
```

### Reading UI State

```typescript
useCopilotReadable({
  description: "User-provided prompt for image generation",
  value: imagePrompt,
});
```

### Copilot Action Handler

```typescript
useCopilotAction({
  name: "generateImage",
  description: "Generate an image based on user description",
  parameters: [],
  handler: async () => {
    if (!imagePrompt.trim()) {
      setNeedsUserInput(true);
      return "I need a description to generate an image.";
    }
    const newImage = await fetchImageByPrompt(imagePrompt);
    if (!newImage) {
      setNeedsUserInput(true);
      return "I couldn't generate an image. Please provide new prompt.";
    }
    setNeedsUserInput(false);
    setImagePrompt("");
    setImages((prev) => [...prev, newImage]);
    return `Generated an image for: "${imagePrompt}"`;
  },
});
```

### Image Fetching

```typescript
const fetchImageByPrompt = async (prompt: string): Promise<ImageObject | null> => {
  try {
    const response = await fetch(`https://source.unsplash.com/featured/?${encodeURIComponent(prompt)}`);
    return { id: crypto.randomUUID(), url: response.url, prompt };
  } catch (error) {
    return null;
  }
};
```
