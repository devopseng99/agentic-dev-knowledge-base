---
title: "From Waiting to Streaming: How to Handle LLM Responses Like a Pro (Especially with JSON)"
url: "https://dev.to/abhinav__ap/from-waiting-to-streaming-how-to-handle-llm-responses-like-a-pro-especially-with-json-2lgh"
author: "AbHiNaV PrAkAsH"
category: "llm-streaming"
---

# From Waiting to Streaming: How to Handle LLM Responses Like a Pro (Especially with JSON)

**Author:** AbHiNaV PrAkAsH
**Published:** June 15, 2025

## Overview
Addresses reducing perceived latency with LLMs by streaming data progressively, with special attention to the JSON streaming challenge where incomplete JSON cannot parse.

## Code Examples

### Python - Google Gen AI SDK Streaming

```python
from google import genai

client = genai.Client(api_key="YOUR_GEMINI_API_KEY")
response = client.models.generate_content_stream(
    model="gemini-2.0-flash",
    contents="Write a story about AI"
)
for chunk in response:
    if chunk.text:
        updateUI(chunk.text)
```

### JavaScript - JSON Streaming Request

```javascript
import { makeStreamingJsonRequest } from "http-streaming-request";

const stream = makeStreamingJsonRequest({
    url: "/api/generate-users",
    method: "POST",
    payload: { count: 10 }
});
for await (const data of stream) {
    updateUserList(data);
}
```

### React Hook Implementation

```jsx
import { useJsonStreaming } from "http-streaming-request";

const UserGenerator = () => {
    const { data: users, run } = useJsonStreaming({
        url: "/api/generate-users",
        method: "POST",
    });

    const handleGenerate = () => {
        run({ payload: { count: 20, prompt: "Generate diverse user profiles" } });
    };

    return (
        <div>
            <button onClick={handleGenerate}>Generate Users</button>
            {users && users.map((user, index) => (
                <div key={index} className="user-card">
                    <h3>{user.name}</h3>
                    <p>Age: {user.age}</p>
                </div>
            ))}
        </div>
    );
};
```

### FastAPI Backend

```python
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
from google import genai

app = FastAPI()
client = genai.Client(api_key="YOUR_GEMINI_API_KEY")

@app.post("/api/generate-users-v2")
async def generate_users_v2(request: Dict[str, Any]):
    def generate():
        response = client.models.generate_content_stream(
            model="gemini-2.0-flash", contents=full_prompt
        )
        for chunk in response:
            if chunk.text:
                yield chunk.text

    return StreamingResponse(generate(), media_type="application/json",
        headers={"Cache-Control": "no-cache"})
```
