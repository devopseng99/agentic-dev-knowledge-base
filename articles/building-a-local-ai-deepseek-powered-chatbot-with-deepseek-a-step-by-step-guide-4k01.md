---
title: "Building a Local AI Deepseek Powered Chatbot with Deepseek: A Step-by-Step Guide"
url: "https://dev.to/extinctsion/building-a-local-ai-deepseek-powered-chatbot-with-deepseek-a-step-by-step-guide-4k01"
author: "Aditya"
category: "deepseek-ai-agent"
---

# Building a Local AI Deepseek Powered Chatbot with Deepseek: A Step-by-Step Guide

**Author:** Aditya
**Published:** February 8, 2025

## Overview
Guide for building a locally-hosted chatbot using Deepseek via Ollama with a Flask backend and simple HTML frontend, emphasizing privacy and reduced latency over cloud solutions.

## Key Concepts

### Backend (app.py)

```python
from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

def generate_response(prompt):
    command = ["ollama", "run", "deepseek", "--prompt", prompt]
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        response = result.stdout.strip()
    except subprocess.CalledProcessError as e:
        response = f"Error generating response: {e}"
    return response

@app.route("/chat", methods=["POST"])
def chat():
    data = request.get_json()
    user_message = data.get("message", "")
    if not user_message:
        return jsonify({"error": "No message provided"}), 400
    response_text = generate_response(user_message)
    return jsonify({"response": response_text})

@app.route("/")
def home():
    return app.send_static_file("index.html")

if __name__ == "__main__":
    app.run(debug=True)
```

### Frontend (index.html)

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Local AI Chatbot with Deepseek</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    #chatbox { border: 1px solid #ccc; padding: 10px;
               height: 300px; width: 80%; margin-bottom: 10px; overflow-y: scroll; }
    .message { margin: 5px 0; }
    .user { color: blue; }
    .bot { color: green; }
  </style>
</head>
<body>
  <h1>Local AI Chatbot with Deepseek</h1>
  <div id="chatbox"></div>
  <input type="text" id="message" placeholder="Type your message here..." style="width:70%;">
  <button id="send">Send</button>

  <script>
    document.getElementById("send").addEventListener("click", function() {
      const inputField = document.getElementById("message");
      const message = inputField.value.trim();
      if (!message) return;
      const chatbox = document.getElementById("chatbox");
      chatbox.innerHTML += `<div class="message user"><strong>You:</strong> ${message}</div>`;
      fetch("/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ message: message })
      })
      .then(response => response.json())
      .then(data => {
        chatbox.innerHTML += `<div class="message bot"><strong>Bot:</strong> ${data.response}</div>`;
        inputField.value = "";
        chatbox.scrollTop = chatbox.scrollHeight;
      })
      .catch(err => console.error("Error:", err));
    });
  </script>
</body>
</html>
```

### Setup
```bash
python -m venv chatbot-env
source chatbot-env/bin/activate
pip install flask
python app.py
```

Access at `http://127.0.0.1:5000/`
