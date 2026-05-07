---
title: "Multi-Agent AI Systems: Grounding with Google Maps in Genkit"
url: "https://dev.to/wayne_gakuo/multi-agent-ai-systems-grounding-with-google-maps-in-genkit-4ijb"
author: "Wayne Gakuo"
category: "agent-sdks"
---

# Multi-Agent AI Systems: Grounding with Google Maps in Genkit
**Author:** Wayne Gakuo
**Published:** April 8, 2026

## Overview
Integrating Google Maps grounding into a Genkit multi-agent AI concierge, enabling interactive map experiences with real-time place data, coordinates, and reviews.

## Key Concepts

### Enabling Google Maps Tool in Genkit
```typescript
export const _findAndNavigateAgentToolLogic = ai.defineTool(
  {
    name: 'findAndNavigateAgentTool',
    description: 'Assists with finding routes and transportation options',
    inputSchema: z.object({
      input: z.string(),
      history: z.array(conversationMessageSchema).optional(),
    }),
    outputSchema: z.object({
      text: z.string(),
      mapsWidgetToken: z.string().optional(),
    }),
  },
  async ({input, history}) => {
    const response = await ai.generate({
      system: TRANSPORT_AGENT_PROMPT,
      messages: [...toGenkitMessages(history ?? []), {role: 'user', content: [{text: input}]}],
      config: {
        tools: [{ googleMaps: {enableWidget: true} }]
      },
    });
    const mapsWidgetToken = (response.custom as any)
      ?.candidates?.[0]?.groundingMetadata?.googleMapsWidgetContextToken;
    return { text: response.text, mapsWidgetToken };
  }
);
```

### Frontend Widget Rendering (Angular)
```typescript
@Component({
  selector: 'app-maps-widget',
  template: `<div #mapElement class="map-container"></div>`,
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
})
export class MapsWidget implements AfterViewInit {
  readonly token = input<string>('');
  async ngAfterViewInit() {
    await this.mapsLoader.importLibrary('places');
    const places = (window as any)['google']?.maps?.places;
    const el = new places.PlaceContextualElement({ contextToken: this.token() });
    this.container.nativeElement.appendChild(el);
  }
}
```
