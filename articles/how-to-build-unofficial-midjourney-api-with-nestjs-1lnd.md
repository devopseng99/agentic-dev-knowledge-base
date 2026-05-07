---
title: "How to build a Midjourney API with Nest.js"
url: "https://dev.to/confidentai/how-to-build-unofficial-midjourney-api-with-nestjs-1lnd"
author: "Jeffrey Ip"
category: "ai-media-generation"
---
# How to build a Midjourney API with Nest.js
**Author:** Jeffrey Ip  **Published:** November 29, 2023

## Overview
This tutorial demonstrates building an unofficial Midjourney API using TypeScript and Nest.js. The article explains Discord bot architecture and how to interact with Midjourney through Discord's API endpoints to generate AI images programmatically.

## Key Concepts
- Discord bot creation and configuration
- Discord API v9 interactions endpoint
- Command payload structure for image generation
- Message polling for retrieving generated images
- Base64 image encoding

```typescript
@Controller('discord')
export class DiscordController {
  constructor(private discordService: DiscordService) {}

  @Post('imagine')
  async imagine(@Body('prompt') prompt: string): Promise<any> {
    return this.discordService.sendImagineCommand(prompt);
  }
}
```

```typescript
@Injectable()
export class DiscordService {
  constructor(private readonly httpService: HttpService) {}

  async sendImagineCommand(prompt: string): Promise<any> {
    const postUrl = "https://discord.com/api/v9/interactions";
    // Configuration payload with Discord API fields
  }
}
```

```typescript
async fetchAndEncodeImage(url: string): Promise<string> {
  const response = await this.httpService.get(url, {
    responseType: 'arraybuffer',
  }).toPromise();
  
  const base64 = Buffer.from(response.data, 'binary').toString('base64');
  return `data:${response.headers['content-type']};base64,${base64}`;
}
```

Note: For educational purposes only, not recommended for production use.
