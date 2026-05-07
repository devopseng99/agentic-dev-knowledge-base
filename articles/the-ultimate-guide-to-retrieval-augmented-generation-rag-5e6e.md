---
title: "The Ultimate Guide to Retrieval-Augmented Generation (RAG)"
url: "https://dev.to/codemaker2015/the-ultimate-guide-to-retrieval-augmented-generation-rag-5e6e"
author: "Vishnu Sivan"
category: "retrieval augmented generation agent"
---

# The Ultimate Guide to Retrieval-Augmented Generation (RAG)

**Author:** Vishnu Sivan
**Published:** December 16, 2024

## Overview
Comprehensive guide covering RAG fundamentals, seven RAG variants (Native, Retrieve and Rerank, Multimodal, Graph, Hybrid, Agentic Router, Multi-Agent), RAG vs fine-tuning comparison, and a complete PDF chat system implementation using LangChain, FAISS, and Streamlit.

## Key Concepts

### Seven RAG Types
1. **Native RAG** - Tightly integrated retriever-generator
2. **Retrieve and Rerank RAG** - Refines through reranking models
3. **Multimodal RAG** - Text, images, audio, video
4. **Graph RAG** - Knowledge graphs for entity relationships
5. **Hybrid RAG** - Dense and sparse retrieval combined
6. **Agentic RAG (Router)** - Dynamic query routing to appropriate modules
7. **Multi-Agent RAG** - Specialized agents for distinct tasks

### PDF Chat Implementation

```bash
pip install langchain langchain_community openai faiss-cpu PyPDF2 streamlit python-dotenv tiktoken
```

```python
def get_pdf_text(pdf_files):
    text = ""
    for pdf_file in pdf_files:
        reader = PdfReader(pdf_file)
        for page in reader.pages:
            text += page.extract_text()
    return text
```

```python
def get_chunk_text(text):
    text_splitter = CharacterTextSplitter(
        separator="\n",
        chunk_size=1000,
        chunk_overlap=200,
        length_function=len
    )
    chunks = text_splitter.split_text(text)
    return chunks
```

```python
def get_vector_store(text_chunks):
    embeddings = OpenAIEmbeddings(
        openai_api_key=OPENAI_API_KEY,
        model=OPENAI_EMBEDDING_MODEL_NAME
    )
    vectorstore = FAISS.from_texts(texts=text_chunks, embedding=embeddings)
    return vectorstore
```

```python
def get_conversation_chain(vector_store):
    llm = ChatOpenAI(
        openai_api_key=OPENAI_API_KEY,
        model_name=OPENAI_MODEL_NAME,
        temperature=0
    )
    memory = ConversationBufferMemory(
        memory_key='chat_history',
        return_messages=True
    )
    system_template = """
    Use the following pieces of context and chat history to answer the question at the end.
    If you don't know the answer, just say that you don't know, don't try to make up an answer.

    Context: {context}
    Chat history: {chat_history}
    Question: {question}
    Helpful Answer:
    """
    prompt = PromptTemplate(
        template=system_template,
        input_variables=["context", "question", "chat_history"],
    )
    conversation_chain = ConversationalRetrievalChain.from_llm(
        verbose=True,
        llm=llm,
        retriever=vector_store.as_retriever(),
        memory=memory,
        combine_docs_chain_kwargs={"prompt": prompt}
    )
    return conversation_chain
```

```python
def main():
    st.set_page_config(page_title='Chat with PDFs', page_icon=':books:')

    if "conversation" not in st.session_state:
        st.session_state.conversation = None
    if "chat_history" not in st.session_state:
        st.session_state.chat_history = None

    st.header('Chat with PDFs :books:')
    question = st.text_input("Ask anything to your PDF:")

    if question:
        handle_user_input(question)

    with st.sidebar:
        st.subheader("Upload your Documents Here: ")
        pdf_files = st.file_uploader(
            "Choose your PDF Files and Press Process button",
            type=['pdf'],
            accept_multiple_files=True
        )

        if pdf_files and st.button("Process"):
            with st.spinner("Processing your PDFs..."):
                raw_text = get_pdf_text(pdf_files)
                text_chunks = get_chunk_text(raw_text)
                vector_store = get_vector_store(text_chunks)
                st.session_state.conversation = get_conversation_chain(vector_store)

if __name__ == '__main__':
    main()
```

### Vector Databases
- **FAISS** - Facebook AI's high-dimensional vector solution
- **Chroma** - Open-source in-memory for LLM applications
- **Weaviate** - Self-hosted or managed with vector and object storage
- **Pinecone** - Cloud-based managed similarity search

GitHub: github.com/codemaker2015/pdf-chat-using-RAG
