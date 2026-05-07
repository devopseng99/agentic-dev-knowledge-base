---
title: "Extending a Video with Angular, Veo 3.1 Lite, Firebase Cloud Functions, and Firebase Cloud Storage"
url: "https://dev.to/gde/extending-a-video-with-angular-veo-31-lite-firebase-cloud-functions-and-firebase-cloud-storage-4ik9"
author: "Connie Leung"
category: "ai-media-generation"
---
# Extending a Video with Angular, Veo 3.1 Lite, Firebase Cloud Functions, and Firebase Cloud Storage
**Author:** Connie Leung  **Published:** April 18, 2026

## Overview
The article demonstrates building an AI video generation application using Google's newest Veo 3.1 Lite model. The developer migrates an existing application to leverage this cost-effective video generation capability through Firebase's serverless infrastructure, enabling image-to-video generation and video extension features.

## Key Concepts
- Veo 3.1 Lite model integration with Gemini API and Vertex AI
- Firebase Cloud Functions for asynchronous video processing
- Firebase Cloud Storage for video file persistence
- Polling mechanism for long-running AI operations
- Angular 21 integration with Firebase services

```typescript
export const VIDEO_CONFIG = (() => {
  process.loadEnvFile();
  const env = process.env;
  const isVeo31Used = (env.IS_VEO31_USED || "false") === "true";
  const pollingPeriod = Number(env.POLLING_PERIOD_MS || "10000");
  // validation logic...
})();
```

```typescript
async function getVideoUri(
  ai: GoogleGenAI,
  genVideosParams: GenerateVideosParameters,
  pollingPeriod: number,
): Promise<{ uri: string, mimeType: string }> {
  let operation = await ai.models.generateVideos(genVideosParams);
  while (!operation.done) {
    await new Promise((resolve) => setTimeout(resolve, pollingPeriod));
    operation = await ai.operations.getVideosOperation({ operation });
  }
}
```

```typescript
async extendVideo(prompt: string): Promise<void> {
  try {
    const result = await this.extendInterpolatedVideo(
      prompt,
      this.#extendVideoCounter(),
      this.videoResponse()
    );
    if (!result) return;
    this.videoResponse.set(result);
    this.#extendVideoCounter.update(count => count + 1);
  } catch (e) {
    this.videoError.set(e instanceof Error ? e.message : 'Error');
  }
}
```

- GitHub: https://github.com/railsstudent/ng-firebase-ai-nano-banana/blob/main/firebase-project/functions/src/video/extend-video.ts
