---
title: "Building Your First AI Agent with LangChain: From Chatbot to Autonomous Assistant"
url: "https://dev.to/kumail_dev110/building-your-first-ai-agent-with-langchain-from-chatbot-to-autonomous-assistant-263h"
author: "Muhammad Kumail"
category: "building chatbot agent"
---

# Building Your First AI Agent with LangChain: From Chatbot to Autonomous Assistant

**Author:** Muhammad Kumail
**Published:** April 17, 2026

## Overview

A practical guide to building an AI agent with LangChain in Python that combines internet search, Wikipedia, and RAG document QA capabilities with conversation memory, all within 30 minutes.

## Key Concepts

An agent operates through four key functions: thinking (understanding requests via LLMs), deciding (selecting appropriate tools), acting (executing chosen actions), and learning (retaining context).

### Complete Agent Implementation

```python
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
from langchain.agents import initialize_agent, AgentType, Tool
from langchain.tools import DuckDuckGoSearchRun, WikipediaQueryRun
from langchain.utilities import WikipediaAPIWrapper
from langchain.memory import ConversationBufferMemory
from langchain.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain.vectorstores import FAISS
from langchain.chains import RetrievalQA
from dotenv import load_dotenv

load_dotenv()

llm = ChatOpenAI(model="gpt-4", temperature=0)

# Tool 1: Internet Search
search = DuckDuckGoSearchRun()

# Tool 2: Wikipedia
wikipedia = WikipediaQueryRun(api_wrapper=WikipediaAPIWrapper())

# Tool 3: RAG (Your Documents)
loader = TextLoader("my_document.txt")
documents = loader.load()
text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
docs = text_splitter.split_documents(documents)
embeddings = OpenAIEmbeddings()
vectorstore = FAISS.from_documents(docs, embeddings)
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever()
)

# Define All Tools
tools = [
    Tool(
        name="Internet Search",
        func=search.run,
        description="Use this to search the internet for current information"
    ),
    Tool(
        name="Wikipedia",
        func=wikipedia.run,
        description="Use this to look up detailed information from Wikipedia"
    ),
    Tool(
        name="Document QA",
        func=qa_chain.run,
        description="Use this to answer questions from uploaded documents"
    )
]

# Memory
memory = ConversationBufferMemory(
    memory_key="chat_history",
    return_messages=True
)

# Create Agent
agent = initialize_agent(
    tools=tools,
    llm=llm,
    agent=AgentType.CHAT_CONVERSATIONAL_REACT_DESCRIPTION,
    memory=memory,
    verbose=True,
    handle_parsing_errors=True
)

# Chat Loop
print("AI Agent Ready! Type 'quit' to exit.\n")

while True:
    user_input = input("You: ")
    if user_input.lower() == "quit":
        print("Goodbye!")
        break
    response = agent.run(user_input)
    print(f"Agent: {response}\n")
```
