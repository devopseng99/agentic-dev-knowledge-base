---
title: "Build an AI Agent in a Next.js app using Web AI Framework"
url: "https://dev.to/mahamdev/build-an-ai-agent-in-a-nextjs-app-using-web-ai-framework-31fo"
author: "Maham Codes"
category: "ai-agent-nextjs-react"
---

# Build an AI Agent in a Next.js app using Web AI Framework

**Author:** Maham Codes
**Published:** October 16, 2024

## Overview

Step-by-step guide to building an AI agent in Next.js using the BaseAI framework from Langbase, demonstrating a summary agent pipe that processes text.

## Key Concepts

### Setup Steps

**1. Install Next.js**
```bash
npx create-next-app@latest nextjs-baseai-app
```

**2. Install BaseAI**
```bash
npx baseai@latest init
```

**3. Create a Summary AI Agent Pipe**
```bash
npx baseai@latest pipe
```
Creates a pipe at `baseai/pipes/summary.ts` with system prompt: "You are a helpful AI assistant. Make everything Less wordy."

**4. Set Environment Variables**
```bash
cp .env.baseai.example .env
```

**5. API Route Handler** (`app/api/langbase/pipes/run/route.ts`)
```typescript
import {Pipe} from '@baseai/core';
import {NextRequest} from 'next/server';
import pipeSummary from '../../../../../baseai/pipes/summary';

export async function POST(req: NextRequest) {
    const runOptions = await req.json();
    const pipe = new Pipe(pipeSummary());
    const result = await pipe.run(runOptions);
    return new Response(JSON.stringify(result));
}
```

**6. Add React Components**
```bash
npm install @radix-ui/react-slot class-variance-authority clsx tailwind-merge
```

**7. Pipe Run Page** (`app/pipe-run/page.tsx`)
```typescript
import PipeRunExample from '@/components/pipe-run';

export default function Page() {
    return (
        <div className="w-full max-w-md">
            <h1 className="text-2xl font-light text-gray-800 mb-1 text-center">
                Langbase AI Agent Pipe: Run
            </h1>
            <p className="text-muted-foreground text-base font-light mb-20 text-center">
                Run a pipe to generate a text completion
            </p>
            <PipeRunExample />
        </div>
    );
}
```

**8. Run the Application**
```bash
# Terminal 1
npx baseai@latest dev

# Terminal 2
npm run dev
```

**9. Deploy on Langbase**
```bash
npx baseai@latest auth
npx baseai@latest deploy
```
