---
title: "My AI Agents as First-Class NestJS Citizens"
url: "https://dev.to/hosby/-ai-agents-as-first-class-nestjs-citizens-5723"
author: "Siddick FOFANA"
category: "immutable-arch-rust-flink"
---
# My AI Agents as First-Class NestJS Citizens
**Author:** Siddick FOFANA  **Published:** April 8, 2026

## Overview
`@orka-js/nestjs` integrates AI agents directly into NestJS using dependency injection, CQRS buses, event-driven decorators, semantic guards, and microservice patterns.

## Key Concepts

```bash
npm install @orka-js/nestjs @orka-js/agent @orka-js/openai @nestjs/common @nestjs/core reflect-metadata rxjs
```

OrkaModule registration:
```typescript
@Module({
  imports: [
    OrkaModule.forRoot({
      agents: {
        assistant: new StreamingToolAgent({ goal: 'Helpful assistant', tools: [] }, llm),
        analyst: new StreamingToolAgent({ goal: 'Data analyst', tools: [] }, llm),
      },
      path: 'ai',
    }),
  ],
})
export class AppModule {}
```

Dependency Injection with `@InjectAgent`:
```typescript
@Injectable()
export class OrderService {
  constructor(
    @InjectAgent('assistant') private agent: BaseAgent,
    private readonly db: OrderRepository,
  ) {}

  async summarize(orderId: string): Promise<string> {
    const order = await this.db.findById(orderId)
    const result = await this.agent.run(JSON.stringify(order))
    return result.output
  }
}
```

Event-Driven Agents with `@AgentReact`:
```typescript
@OnEvent('order.created')
@AgentReact()
async onOrderCreated(payload: OrderCreatedEvent) {}

@OnEvent('customer.churned')
@AgentReact({ agent: 'churnAgent', async: true })
onChurnDetected(payload: ChurnEvent): void {}
```

CQRS Integration:
```typescript
@AgentQueryHandler(SearchProductsQuery)
export class SearchProductsHandler extends OrkaQueryHandler<SearchProductsQuery> {
  constructor(@InjectAgent('search') protected agent: BaseAgent) {
    super()
  }
}
```

Semantic Guards (LLM-based intent validation):
```typescript
@UseGuards(new OrkaSemanticGuard(llm, 'Only allow requests from authenticated admin users'))
@Controller('admin')
export class AdminController {
  @Get('users')
  listUsers() { /* ... */ }
}
```

Agent Validation Pipe (natural language → typed DTOs):
```typescript
@Post('search')
async search(
  @Body(new AgentValidationPipe(ProductSearchSchema, llm))
  filters: ProductSearch,
) {
  return this.productService.search(filters)
}
```
