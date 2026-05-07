---
title: "Build an AI SMS Chatbot with Replicate, LLaMA 2, and LangChain"
url: "https://dev.to/lizziepika/build-an-ai-sms-chatbot-with-replicate-llama-2-and-langchain-3i72"
author: "Lizzie Siegle"
category: "ai-image-video-generation"
---
# Build an AI SMS Chatbot with Replicate, LLaMA 2, and LangChain
**Author:** Lizzie Siegle  **Published:** 2023-09-12

## Overview
Tutorial demonstrating how to create an SMS-based conversational AI (responding as the Star Wars character Ahsoka) using Replicate's API for model hosting, LLaMA 2 for the language model, LangChain for conversation history, and Twilio for SMS delivery.

## Key Concepts

### Technology Stack
- **LLaMA 2:** Meta's second-generation large language model (13B parameter variant), optimized for chat interactions
- **Replicate:** Cloud API platform that hosts and manages machine learning models — pay-per-prediction, no GPU needed
- **LangChain:** Framework for chaining prompts and maintaining conversation history
- **Twilio:** Programmable messaging platform for SMS delivery

### Core Implementation

```python
from flask import Flask, request
from langchain.llms import Replicate
from langchain.chains import ConversationChain
from langchain.memory import ConversationBufferWindowMemory
from langchain.prompts import PromptTemplate
from twilio.twiml.messaging_response import MessagingResponse
import os

app = Flask(__name__)

# Configure LLaMA 2 via Replicate
llm = Replicate(
    model="meta/llama-2-13b-chat:f4e2de70d66816a838a89eeeb621910adffb0dd0baba3976c96980970978018d",
    model_kwargs={"temperature": 0.75, "max_length": 500}
)

# Define Ahsoka persona
template = """You are Ahsoka Tano from Star Wars. Respond in character.
Current conversation:
{history}
Human: {input}
Ahsoka:"""

prompt = PromptTemplate(input_variables=["history", "input"], template=template)
memory = ConversationBufferWindowMemory(k=5)
conversation = ConversationChain(llm=llm, prompt=prompt, memory=memory)

@app.route("/sms", methods=["POST"])
def sms_reply():
    message = request.form.get("Body", "")
    response_text = conversation.predict(input=message)

    twiml = MessagingResponse()
    twiml.message(response_text)
    return str(twiml)

if __name__ == "__main__":
    app.run(debug=True, port=5000)
```

### Configuration Steps
1. Create Python virtual environment and install dependencies
2. Obtain Replicate API token and set `REPLICATE_API_TOKEN`
3. Configure prompt template defining persona
4. Build Flask application handler at `/sms` endpoint
5. Expose local server via ngrok
6. Update Twilio phone number webhook settings to ngrok URL

### Key Points
- `ConversationBufferWindowMemory(k=5)` keeps the last 5 exchanges for context
- Replicate handles all model infrastructure; no GPU required
- Flask + ngrok enables rapid local development before deployment

## GitHub Repository
[elizabethsiegle/replicate-llama2-sms-chatbot](https://github.com/elizabethsiegle/replicate-llama2-sms-chatbot)
