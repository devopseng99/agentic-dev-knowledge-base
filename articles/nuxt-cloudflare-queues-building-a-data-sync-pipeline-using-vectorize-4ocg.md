---
title: "Nuxt & Cloudflare Queues: Building a Data Sync Pipeline using Vectorize"
url: "https://dev.to/keithmifsud/nuxt-cloudflare-queues-building-a-data-sync-pipeline-using-vectorize-4ocg"
author: "Keith Mifsud"
category: "cloudflare-vectorize"
---

# Nuxt & Cloudflare Queues: Building a Data Sync Pipeline using Vectorize
**Author:** Keith Mifsud
**Published:** December 30, 2025

## Overview
Part 2 of a series: Setting up Cloudflare Vectorize and implementing queues to populate a vector store with location embeddings using bge-m3 model (1024 dimensions).

## Key Concepts

### Queue Setup
```bash
npx wrangler queues create vector-sync-queue
```

```toml
[[queues.producers]]
queue = "vector-sync-queue"
binding = "VECTOR_SYNC_QUEUE"

[[queues.consumers]]
queue = "vector-sync-queue"
max_batch_size = 10
max_batch_timeout = 5
```

### Vector Repository
```typescript
export class CloudflareVectorAIRepository implements LocationVectorRepository {
  public async upsertLocations(locations: Location[]): Promise<number> {
    const AI_BATCH_SIZE = 10;
    let successfulUpserts = 0;
    for (let i = 0; i < locations.length; i += AI_BATCH_SIZE) {
      const batch = locations.slice(i, i + AI_BATCH_SIZE);
      const textsToEmbed = batch.map((loc) => this.buildTextForEmbedding(loc));
      const vectors = await this.embedTextBatch(textsToEmbed);
      const vectorObjects = batch.map((loc, idx) => ({
        id: loc.id, values: vectors[idx],
        metadata: { locationId: loc.id },
      })).filter(Boolean);
      await this.vectorIndex.upsert(vectorObjects);
      successfulUpserts += vectorObjects.length;
    }
    return successfulUpserts;
  }

  private async embedTextBatch(texts: string[]): Promise<number[][]> {
    const response = await this.ai.run('@cf/baai/bge-m3', {
      text: texts, response_format: 'embedding_vector',
    });
    return response.data ?? response.response;
  }
}
```
