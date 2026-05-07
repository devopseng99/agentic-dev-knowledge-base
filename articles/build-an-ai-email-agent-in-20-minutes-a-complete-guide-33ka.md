---
title: "Build an AI Email Agent in 20 Minutes: A Complete Guide"
url: "https://dev.to/heyarviind/build-an-ai-email-agent-in-20-minutes-a-complete-guide-33ka"
author: "Arvind"
category: "ai-agent-email-automation"
---

# Build an AI Email Agent in 20 Minutes: A Complete Guide

**Author:** Arvind
**Published:** December 3, 2025

## Overview

A tutorial for building a production-ready AI email agent using AIThreads, LangChain, and OpenAI that processes incoming emails, classifies intent, and generates intelligent auto-replies with escalation logic.

## Key Concepts

### Agent Setup with LangChain

```python
from langchain.chat_models import ChatOpenAI
from langchain.agents import initialize_agent, Tool, AgentType
from langchain.tools import tool
import os

llm = ChatOpenAI(
    model="gpt-4",
    temperature=0.5,
    api_key=os.getenv("OPENAI_API_KEY")
)

@tool
def classify_email_intent(email_content: str) -> str:
    """Classify the intent of an email"""
    classification_prompt = f"""
    Classify this email into ONE category:
    - FAQ: Common questions about products/services
    - ORDER_STATUS: Questions about orders or shipments
    - COMPLAINT: Customer complaint or angry
    - REFUND: Refund request
    - ESCALATE: Complex issue needing human attention
    - OTHER: Doesn't fit categories

    Email: {email_content}
    Return only the category name.
    """
    response = llm.predict(classification_prompt)
    return response.strip()

@tool
def should_escalate(email_content: str, classification: str) -> bool:
    """Determine if email needs human attention"""
    escalation_prompt = f"""
    Should this email be escalated to a human? (yes/no)
    Classification: {classification}

    Escalate if:
    - Customer is very angry or frustrated
    - Issue is complex or unusual
    - Requires data lookup we can't do
    - Multiple complaints

    Email: {email_content}
    Answer with just 'yes' or 'no'.
    """
    decision = llm.predict(escalation_prompt).strip().lower()
    return decision == 'yes'

tools = [
    Tool(name="Classify Intent", func=classify_email_intent,
         description="Classify what the email is about"),
    Tool(name="Check Escalation", func=should_escalate,
         description="Decide if email needs human review"),
]

agent = initialize_agent(
    tools,
    llm,
    agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
    verbose=True
)
```

### Webhook Server (Flask)

```python
from flask import Flask, request, jsonify
import os
from agent import process_email
import requests

app = Flask(__name__)
AITHREADS_API_KEY = os.getenv("AITHREADS_API_KEY")
INBOX_ID = "your_inbox_id_here"

@app.route("/webhook/email", methods=["POST"])
def handle_email():
    try:
        data = request.json
        email_id = data.get("id")
        sender_email = data.get("from")[0].get("email")
        subject = data.get("subject", "(No subject)")
        body = data.get("text", "")

        result = process_email(body, sender_email)

        if result["action"] == "reply":
            send_response = requests.post(
                f"https://api.aithreads.io/v1/inboxes/{INBOX_ID}/emails",
                headers={"Authorization": f"Bearer {AITHREADS_API_KEY}"},
                json={
                    "to": sender_email,
                    "subject": f"Re: {subject}",
                    "text": result["response"],
                    "in_reply_to": email_id
                }
            )
            return jsonify({"status": "success", "action": "replied"}), 200

        elif result["action"] == "escalate":
            return jsonify({"status": "success", "action": "escalated"}), 200

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
```

### Knowledge Base Integration

```python
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter

loader = TextLoader("faq.txt")
documents = loader.load()
text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
docs = text_splitter.split_documents(documents)

embeddings = OpenAIEmbeddings()
db = Chroma.from_documents(docs, embeddings, persist_directory="./chroma_db")

def search_knowledge_base(query: str):
    results = db.similarity_search(query, k=3)
    return "\n".join([doc.page_content for doc in results])
```
