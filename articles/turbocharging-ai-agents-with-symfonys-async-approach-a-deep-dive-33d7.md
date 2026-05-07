---
title: "Turbocharging AI Agents with Symfony's Async Approach: A Deep Dive"
url: "https://dev.to/mattleads/turbocharging-ai-agents-with-symfonys-async-approach-a-deep-dive-33d7"
author: "Matt Mochalkin"
category: "immutable-arch-rust-flink"
---
# Turbocharging AI Agents with Symfony's Async Approach: A Deep Dive
**Author:** Matt Mochalkin  **Published:** August 29, 2025

## Overview
Building resilient AI agents in Symfony using the Messenger Component with CQRS-based bus architecture (Command Bus, Query Bus, Event Bus) and Redis transport. Commands dispatched to queue and processed asynchronously by the worker process.

## Key Concepts

```bash
composer require symfony/messenger
composer require symfony/redis-messenger
```

CQRS bus configuration (`config/packages/messenger.yaml`):
```yaml
framework:
    messenger:
        default_bus: core.command.bus
        buses:
            core.command.bus:
                default_middleware:
                    enabled: true
                    allow_no_handlers: false
                    allow_no_senders: false
            core.query.bus:
                default_middleware:
                    enabled: true
                    allow_no_handlers: true
                    allow_no_senders: true
            core.event.bus:
                default_middleware:
                    enabled: true
                    allow_no_handlers: true
                    allow_no_senders: true
        transports:
            main.transport:
                dsn: '%env(MESSENGER_TRANSPORT_DSN)%'
        routing:
            '*': [main.transport]
```

Message handler:
```php
#[AsMessageHandler(bus: 'core.command.bus', fromTransport: 'main.transport')]
readonly class AIAgentSummarizeMessageHandler
{
    public function __construct(
        private AIAgentService $aiAgentService,
        private GeminiAIAgentService $geminiAIAgentService,
        protected MessageBusInterface $messageBus
    ){}

    public function __invoke(AIAgentSummarizeMessage $message): void
    {
        $result = $this->aiAgentService->action(
            $this->geminiAIAgentService,
            $message->getDataCollection(),
            $message->getPrompt()
        );

        if (!is_null($result)) {
            $this->messageBus->dispatch(
                new Envelope(new NotifySummarizedMessage(...))
            );
        }
    }
}
```

```bash
./bin/console messenger:consume --all -vv
./bin/console app:summarize
```
