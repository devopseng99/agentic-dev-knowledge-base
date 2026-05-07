---
title: "Building a Serverless GraphQL Yoga Server with TypeScript on Cloudflare Workers with Cloudflare KV"
url: "https://dev.to/damianesteban/building-a-serverless-graphql-yoga-server-with-typescript-on-cloudflare-workers-with-cloudflare-kv-1pbm"
author: "Damian Esteban"
category: "cloudflare-workers"
---

# Building a Serverless GraphQL Yoga Server with TypeScript on Cloudflare Workers
**Author:** Damian Esteban
**Published:** August 22, 2023

## Overview
GraphQL Yoga server on Cloudflare Workers with KV for persistence. CRUD operations for data using serverless edge infrastructure.

## Key Concepts

### Setup
```bash
npm create cloudflare
npm install graphql graphql-yoga
wrangler kv:namespace create Animal_Rescues_KV
```

### GraphQL Server
```typescript
import { createSchema, createYoga } from 'graphql-yoga';
import gql from 'graphql-tag';
import { nanoid } from 'nanoid';

const yoga = createYoga<Env>({
  schema: createSchema({
    typeDefs: gql`
      type AnimalRescue { id: ID! name: String! species: AnimalRescueSpecies! }
      type Query { animalRescue(id: ID!): AnimalRescue animalRescues: [AnimalRescue] }
      type Mutation { addAnimalRescue(name: String!, species: AnimalRescueSpecies): AnimalRescue }
    `,
    resolvers: {
      Query: {
        animalRescue: async (_, { id }, { Animal_Rescues_KV }) => {
          const value = await Animal_Rescues_KV.get(id);
          return JSON.parse(value!);
        },
        animalRescues: async (_, {}, { Animal_Rescues_KV }) => {
          const records = await Animal_Rescues_KV.list();
          const all = await Promise.all(records.keys.map((k) => Animal_Rescues_KV.get(k.name)));
          return all.map((r) => JSON.parse(r!));
        },
      },
      Mutation: {
        addAnimalRescue: async (_, { name, species }, { Animal_Rescues_KV }) => {
          const item = { name, species, id: nanoid() };
          await Animal_Rescues_KV.put(item.id, JSON.stringify(item));
          return item;
        },
      },
    },
  }),
});

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    return yoga.fetch(request, env);
  },
};
```
