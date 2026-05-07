---
title: "How to Build an Agentic AI RAG Application: A Step-by-Step Guide"
url: "https://dev.to/intersystems/how-to-build-an-agentic-ai-rag-application-a-step-by-step-guide-41p"
author: "InterSystems Developer"
category: "agentic-rag"
---

# How to Build an Agentic AI RAG Application: A Step-by-Step Guide

**Author:** InterSystems Developer
**Published:** May 19, 2025

## Overview
Builds an Agentic AI RAG application using IRIS vector search, OpenAI embeddings, Chainlit UI, and OpenAI Agents SDK with handoff-based multi-agent orchestration.

## Key Concepts

Four-step implementation using vector search for semantic understanding, with a triage agent routing to specialized agents (RAG, production, dashboard, web search).

## Code Examples

### Document Ingestion and Vector Store

```python
def ingestDoc(self):
    embeddings = OpenAIEmbeddings() 
    loader = TextLoader("/irisdev/app/docs/IRIS2025-1-Release-Notes.txt", encoding='utf-8')      
    documents = loader.load()        
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=400, chunk_overlap=0)
    texts = text_splitter.split_documents(documents)
    db = IRISVector.from_documents(
        embedding=embeddings,
        documents=texts,
        collection_name = self.COLLECTION_NAME,
        connection_string=self.CONNECTION_STRING,
    )
```

### RAG Search with Similarity Scoring

```python
def ragSearch(self, prompt):
    embeddings = OpenAIEmbeddings() 
    db2 = IRISVector(
        embedding_function=embeddings,    
        collection_name=self.COLLECTION_NAME,
        connection_string=self.CONNECTION_STRING,
    )
    docs_with_score = db2.similarity_search_with_score(prompt)
    relevant_docs = ["".join(str(doc.page_content)) + " " for doc, _ in docs_with_score]
    template = f"""
    Prompt: {prompt}
    Relevant Documents: {relevant_docs}
    """
    return template
```

### Vector Search Agent with Chainlit

```python
@function_tool
@cl.step(name="Vector Search Agent (RAG)", type="tool", show_input=False)
async def iris_RAG_search():
    """Provide IRIS Release Notes details"""
    if not ragOprRef.check_VS_Table():
         msg = cl.user_session.get("ragclmsg")
         msg.content = "Ingesting Vector Data..."
         await msg.update()
         ragOprRef.ingestDoc()
    if ragOprRef.check_VS_Table():
         msg = cl.user_session.get("ragclmsg")
         msg.content = "Searching Vector Data..."
         await msg.update()                 
         return ragOprRef.ragSearch(cl.user_session.get("ragmsg"))   
    else:
         return "Error while getting RAG data"

vector_search_agent = Agent(
    name="RAGAgent",
    handoff_description="Specialist agent for Release Notes",
    instructions="You provide assistance with Release Notes.",
    tools=[iris_RAG_search]
)
```

### Triage Agent with Handoffs

```python
triage_agent = Agent(
    name="Triage agent",
    instructions=(
        "Handoff to appropriate agent based on user query."
        "if they ask about Release Notes, handoff to the vector_search_agent."
        "If they ask about production, handoff to the production agent."
        "If they ask about dashboard, handoff to the dashboard agent."
    ),
    handoffs=[vector_search_agent, production_agent, dashboard_agent, processes_agent, order_agent, web_search_agent]
)
```

### Message Handler with Runner

```python
@cl.on_message
async def main(message: cl.Message):
    msg = cl.Message(content="Thinking...")
    await msg.send()
    agent = cast(Agent, cl.user_session.get("agent"))
    config = cast(RunConfig, cl.user_session.get("config"))
    history = cl.user_session.get("chat_history") or []
    history.append({"role": "user", "content": message.content})
    try:
        result = Runner.run_sync(agent, history, run_config=config)
        response_content = result.final_output
        msg.content = response_content
        await msg.update()
        history.append({"role": "developer", "content": response_content})
        cl.user_session.set("chat_history", history)
    except Exception as e:
        msg.content = f"Error: {str(e)}"
        await msg.update()
```
