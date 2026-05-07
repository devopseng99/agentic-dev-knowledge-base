---
title: "From Zero to Hero: Building Your First LangChain Agent with RAG"
url: "https://dev.to/vaib/from-zero-to-hero-building-your-first-langchain-agent-with-rag-1c8h"
author: "vAIber"
category: "langchain-rag-tutorial"
---

# From Zero to Hero: Building Your First LangChain Agent with RAG

**Author:** vAIber
**Published:** June 1, 2025
**Tags:** #programming #ai #beginners #tutorial

---

## Overview

This comprehensive tutorial guides beginners through constructing an AI agent from scratch. The agent integrates three core capabilities: natural language understanding via an LLM, tool integration for specialized tasks, and RAG for accessing external knowledge bases.

## Project Goals

The completed agent will:
- Engage in conversational chat
- Execute mathematical calculations via a calculator tool
- Answer domain-specific questions using retrieval-augmented generation
- Provide interaction through a web interface

## Prerequisites

- Python fundamentals
- Basic HTML/CSS/JavaScript familiarity (optional)
- Willingness to experiment

---

## Part 0: Understanding AI Agents

An AI agent functions as an intelligent assistant capable of understanding requests, reasoning, and executing actions. Key components include:

1. **Large Language Model (Brain):** Core intelligence using tools like Google's Gemini
2. **Tools:** External functions enabling actions beyond LLM capabilities
3. **Knowledge Base (RAG):** Access to domain-specific information
4. **User Interface:** Communication mechanism

---

## Part 1: Development Environment Setup

### Installation Steps

**Python Setup:**
```bash
python -m venv venv
source venv/bin/activate  # macOS/Linux
# OR
venv\Scripts\activate  # Windows
```

**Install Dependencies:**
```bash
pip install Flask requests python-dotenv
```

**API Key Configuration:**
1. Obtain key from Google AI Studio
2. Create `.env` file in project root
3. Add: `GEMINI_API_KEY=YOUR_API_KEY_HERE`

---

## Part 2: LLM Integration (Gemini)

### Backend Implementation (app.py)

```python
import os
import json
import requests
from flask import Flask, request, jsonify, render_template
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__)

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY not found. Please set it in .env")

GEMINI_API_URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={GEMINI_API_KEY}"

KNOWLEDGE_BASE = {
    "company_info.txt": "Our company, 'AI Innovators Inc.', was founded in 2023...",
    "product_specs.txt": "Our flagship product, 'AgentX', is an advanced AI agent platform..."
}

def call_gemini_api(prompt_text):
    payload = {
        "contents": [{"role": "user", "parts": [{"text": prompt_text}]}],
        "generationConfig": {
            "temperature": 0.7,
            "maxOutputTokens": 2048
        }
    }

    headers = {"Content-Type": "application/json"}
    response = requests.post(GEMINI_API_URL, headers=headers, data=json.dumps(payload))

    if response.status_code == 200:
        response_data = response.json()
        return response_data.get("candidates", [])[0].get("content", {}).get("parts", [])[0].get("text", "")
    return "Error connecting to LLM"

@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    user_message = data.get('message')
    if not user_message:
        return jsonify({"error": "No message provided"}), 400
    agent_response = call_gemini_api(user_message)
    return jsonify({"reply": agent_response})

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
```

### Testing
```bash
curl -X POST -H "Content-Type: application/json" \
  -d "{\"message\":\"Hello, agent!\"}" \
  http://127.0.0.1:5000/chat
```

---

## Part 3: Tool Integration (Calculator)

### Calculator Tool Implementation

```python
def simple_calculator(expression):
    try:
        if not all(c in "0123456789+-*/(). " for c in expression):
            return "Error: Invalid characters in expression."
        return str(eval(expression))
    except Exception as e:
        return f"Error: {str(e)}"
```

### Tool Request Handling

The LLM is instructed to output `TOOL_REQUEST: CALCULATOR(expression)` for math queries. The backend then:
1. Parses the request
2. Executes the calculator
3. Feeds results back to LLM for natural language response

**System Prompt Guidance:**
```
You have access to: Calculator - Solves mathematical expressions.
To use: Respond with "TOOL_REQUEST: CALCULATOR(expression)"
Only use for math questions. Answer other queries directly.
```

---

## Part 4: Retrieval-Augmented Generation (RAG)

### Knowledge Base Retrieval

```python
relevant_knowledge = ""
prompt_words = [word.lower() for word in prompt_text.split() if len(word) > 3]
for doc_name, content in KNOWLEDGE_BASE.items():
    if any(word in content.lower() for word in prompt_words):
        relevant_knowledge += f"\n\n--- {doc_name} ---\n{content}"
```

### Integration into Prompt

Retrieved documents are prepended to system instructions, enabling the LLM to reference external information without hallucination.

**Note:** This keyword-based approach is basic. Production systems typically use vector embeddings and similarity search for semantic retrieval.

---

## Part 5: Web User Interface

### HTML Structure (templates/index.html)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My AI Agent</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .user-message { background-color: #DCF8C6; align-self: flex-end; }
        .agent-message { background-color: #E5E7EB; align-self: flex-start; }
        .message-bubble { padding: 8px 12px; border-radius: 12px; max-width: 70%; word-wrap: break-word; }
    </style>
</head>
<body class="bg-gray-100">
    <div class="container mx-auto max-w-2xl h-screen flex flex-col p-4">
        <h1 class="text-3xl font-bold text-gray-700 mb-4">AI Agent Chat</h1>
        <div id="chatbox" class="flex-grow bg-white p-4 rounded-lg shadow-md overflow-y-auto mb-4 flex flex-col space-y-2">
            <div class="agent-message message-bubble">Hello! How can I help you?</div>
        </div>
        <footer class="flex">
            <input type="text" id="userInput" class="flex-grow p-3 border rounded-l-lg" placeholder="Type message...">
            <button id="sendButton" class="bg-blue-500 text-white p-3 rounded-r-lg">Send</button>
        </footer>
    </div>
    <script>
        const chatbox = document.getElementById('chatbox');
        const userInput = document.getElementById('userInput');
        const sendButton = document.getElementById('sendButton');

        function addMessage(message, sender) {
            const messageDiv = document.createElement('div');
            messageDiv.classList.add('message-bubble');
            if (sender === 'user') {
                messageDiv.classList.add('user-message');
                messageDiv.textContent = message;
            } else {
                messageDiv.classList.add('agent-message');
                messageDiv.innerHTML = message.replace(/\n/g, '<br>');
            }
            chatbox.appendChild(messageDiv);
            chatbox.scrollTop = chatbox.scrollHeight;
        }

        async function sendMessage() {
            const messageText = userInput.value.trim();
            if (!messageText) return;
            addMessage(messageText, 'user');
            userInput.value = '';
            sendButton.disabled = true;
            try {
                const response = await fetch('/chat', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ message: messageText })
                });
                const data = await response.json();
                addMessage(data.reply, 'agent');
            } catch (error) {
                addMessage('Connection error. Please try again.', 'agent');
            } finally {
                sendButton.disabled = false;
                userInput.focus();
            }
        }

        sendButton.addEventListener('click', sendMessage);
        userInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') sendMessage();
        });
    </script>
</body>
</html>
```

---

## Part 6: Complete Project Structure

```
my_ai_agent/
    venv/
    templates/
        index.html
    .env
    app.py
```

---

## Part 7: Enhancement Opportunities

**Tool Expansion:** Web search integration, API connections (weather, stocks), code execution (with sandboxing)

**Advanced RAG:** Vector embeddings for semantic search, vector databases (FAISS, Chroma, Pinecone), document chunking strategies

**Memory Systems:** Short-term chat history context, long-term persistent conversation summaries

**Framework Exploration:** LangChain and LlamaIndex offer pre-built abstractions accelerating development.

---

## Key Takeaways

Building an AI agent requires integrating three essential components: language understanding, tool execution, and knowledge retrieval. This tutorial demonstrates a minimal but functional implementation using Flask, Google's Gemini API, and basic Python. While the RAG implementation uses keyword matching, production systems employ semantic search via embeddings. The agent architecture follows a two-step LLM pattern: first determining tool necessity, then generating user-facing responses. Frameworks like LangChain provide significant scaffolding for scaling agent complexity.
