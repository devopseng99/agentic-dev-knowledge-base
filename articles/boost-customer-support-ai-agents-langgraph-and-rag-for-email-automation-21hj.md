---
title: "Boost Customer Support: AI Agents, LangGraph and RAG for Email Automation"
url: "https://dev.to/kaymen99/boost-customer-support-ai-agents-langgraph-and-rag-for-email-automation-21hj"
author: "Aimen Kerrour"
category: "ai-agents-automation"
---

# Build the Ultimate AI Email Automation with AI Agents, RAG, and LangGraph

**Author:** Aimen Kerrour
**Published:** January 5, 2025
**Modified:** February 22, 2025

## Overview

This technical guide explores building an AI-powered customer support email automation system using LangGraph, LangChain, and Retrieval-Augmented Generation (RAG). The system monitors inboxes, categorizes emails, generates responses, and performs quality assurance before sending.

## Key Technologies

### LangChain and LangGraph

LangChain is a framework for developing AI applications with various LLMs (GPT-4o, Google Gemini, LLAMA3). LangGraph extends these capabilities by coordinating multiple chains across multi-step computation in cyclic patterns, functioning as a workflow orchestrator that manages complex processes through graph-based representations.

### Retrieval-Augmented Generation (RAG)

RAG addresses LLM limitations by connecting models to external data sources. It retrieves relevant information from knowledge bases (documentation, FAQs, company records) to generate contextually accurate responses, essentially equipping AI with reference materials before answering.

## System Architecture

The automation workflow consists of four main stages:

### A. Email Monitoring and Categorization

Using the Gmail API, the system continuously monitors the inbox and categorizes incoming emails into:
- **Customer Complaint:** Dissatisfaction or issue reports
- **Product Inquiry:** Information requests about offerings
- **Customer Feedback:** Opinions, suggestions, or praise
- **Unrelated:** Non-operational content (ignored)

### B. Dynamic Response Generation

**Complaints and Feedback:** Routed to an AI writer agent for personalized responses without RAG requirements.

**Product Inquiries:** Leverage RAG to retrieve accurate information from the knowledge base, then use the writer agent to craft comprehensive responses.

### C. AI Quality Assurance

An AI proofreader agent ensures:
- Professional formatting and readability
- Direct relevance to customer queries
- Appropriate tone alignment with brand standards

### D. Automated Email Dispatch

Approved emails are promptly sent to customers.

## Implementation Details

### Knowledge Base Setup

The RAG pipeline requires four steps:

1. **Load Documents:** Import agency information files
2. **Chunk Documents:** Split content into manageable segments (300-character chunks with 50-character overlap recommended)
3. **Generate Embeddings:** Convert chunks to vector representations using Google's embedding model
4. **Create Vector Database:** Store embeddings in Chroma DB locally (production uses Pinecone or Qdrant)

```python
from langchain_community.document_loaders import TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_chroma import Chroma

# Load documents
loader = TextLoader("./data/agency.txt")
docs = loader.load()

# Split into chunks
doc_splitter = RecursiveCharacterTextSplitter(chunk_size=300, chunk_overlap=50)
doc_chunks = doc_splitter.split_documents(docs)

# Create embeddings and vector store
embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
vectorstore = Chroma.from_documents(doc_chunks, embeddings, persist_directory="db")

# Create retriever
vectorstore_retriever = vectorstore.as_retriever(search_kwargs={"k": 3})
```

### LangGraph Workflow

The automation graph structure includes:

```python
workflow.set_entry_point("load_emails")

# Check inbox status
workflow.add_edge("load_emails", "is_email_inbox_empty")
workflow.add_conditional_edges(
    "is_email_inbox_empty",
    nodes.check_new_emails,
    {"process": "categorize_email", "empty": END}
)

# Route based on category
workflow.add_conditional_edges(
    "categorize_email",
    nodes.route_email_based_on_category,
    {
        "product related": "construct_rag_queries",
        "not product related": "email_writer",
        "unrelated": "skip_unrelated_email"
    }
)

# RAG pipeline for product inquiries
workflow.add_edge("construct_rag_queries", "retrieve_from_rag")
workflow.add_edge("retrieve_from_rag", "email_writer")

# Quality assurance
workflow.add_edge("email_writer", "email_proofreader")
workflow.add_conditional_edges(
    "email_proofreader",
    nodes.must_rewrite,
    {"send": "send_email", "rewrite": "email_writer"}
)

# Loop back to check remaining emails
workflow.add_edge("send_email", "is_email_inbox_empty")
workflow.add_edge("skip_unrelated_email", "is_email_inbox_empty")
```

### Email Monitoring Implementation

The `GmailToolsClass` handles Gmail integration, fetching unanswered emails from the past 8 hours:

```python
class GmailToolsClass:
    def fetch_unanswered_emails(self, max_results=50):
        # Retrieve recent emails
        recent_emails = self.fetch_recent_emails(max_results)
        if not recent_emails:
            return []

        # Check draft replies to avoid processing already-answered threads
        drafts = self.fetch_draft_replies()
        threads_with_drafts = {draft['threadId'] for draft in drafts}

        # Filter for new, unanswered emails
        seen_threads = set()
        unanswered_emails = []
        for email in recent_emails:
            thread_id = email['threadId']
            if thread_id not in seen_threads and thread_id not in threads_with_drafts:
                seen_threads.add(thread_id)
                email_info = self._get_email_info(email['id'])
                if not self._should_skip_email(email_info):
                    unanswered_emails.append(email_info)
        return unanswered_emails
```

### Email Categorization

The categorization agent uses this system prompt:

"You are a highly skilled customer support specialist. Review the email and assign the correct category: product_enquiry, customer_complaint, customer_feedback, or unrelated. Base categorization strictly on provided content."

### Response Generation

**For complaints/feedback**, the writer agent receives:

"You are a professional email writer for a SaaS company. Draft thoughtful, empathetic responses addressing customer concerns while maintaining brand voice and professional standards."

**For product inquiries**, RAG retrieves relevant documentation before the writer agent crafts responses.

## Key Workflow Functions

**Email Categorization Node:**
```python
def categorize_email(self, state: GraphState) -> GraphState:
    """Categorizes the current email using the categorize_email agent."""
    current_email = state["emails"][-1]
    result = self.agents.categorize_email.invoke({"email": current_email.body})

    return {
        "email_category": result.category.value,
        "current_email": current_email
    }
```

**Draft Writing Node:**
```python
def write_draft_email(self, state: GraphState) -> GraphState:
    """Writes a draft email based on current email and retrieved information."""
    writer_messages = state.get('writer_messages', [])

    draft_result = self.agents.email_writer.invoke({
        "email_category": state["email_category"],
        "email_content": state["current_email"].body,
        "retrieved_documents": state["retrieved_documents"],
        "history": writer_messages
    })

    email = draft_result.email
    trials = state.get('trials', 0) + 1
    writer_messages.append(f"**Draft {trials}:**\n{email}")

    return {
        "generated_email": email,
        "trials": trials,
        "writer_messages": writer_messages
    }
```

## Process Flow Summary

1. **Monitor:** Gmail API continuously retrieves new emails
2. **Categorize:** AI agent classifies each email into one of four categories
3. **Route:** System directs emails to appropriate processing paths
4. **Generate:** AI writer creates context-appropriate responses (using RAG for product questions)
5. **Verify:** Proofreader agent checks quality, formatting, tone, and relevance
6. **Send:** Approved emails dispatch automatically
7. **Loop:** Process repeats for remaining emails

## Benefits

The system delivers rapid customer responses, consistent quality, intelligent categorization, and reduced manual workload through integration of LLMs, workflow orchestration, and retrieval augmentation.
