---
title: "Building a Retrieval-Augmented Generation (RAG) Application Using Deep Seek R1"
url: https://dev.to/koolkamalkishor/building-a-retrieval-augmented-generation-rag-application-using-deep-seek-r1-4mkk
author: KAMAL KISHOR
category: rag
---

# Building a Retrieval-Augmented Generation (RAG) Application Using Deep Seek R1

**Author:** KAMAL KISHOR
**Date Published:** January 28, 2025
**Tags:** #webdev #ai #javascript #beginners

---

## Article Overview

This tutorial demonstrates how to create a Retrieval-Augmented Generation (RAG) application from scratch using Deep Seek R1. RAG systems "combines retrieval systems with generative models to provide more accurate, context-rich answers."

---

## Key Architecture Components

The article outlines three essential parts of RAG applications:

1. **Retriever** -- locates relevant documents from a knowledge base
2. **Generator** -- produces answers using retrieved documents as context
3. **Knowledge Base** -- stores searchable information

---

## Implementation Steps

### Environment Setup

```bash
pip install deep-seek-r1 langchain transformers sentence-transformers faiss-cpu
```

```bash
mkdir rag-deepseek-app
cd rag-deepseek-app
python -m venv venv
source venv/bin/activate
```

### Building the Knowledge Base

```python
from deep_seek_r1 import DeepSeekRetriever
from sentence_transformers import SentenceTransformer
import os

embedding_model = SentenceTransformer('all-MiniLM-L6-v2')

data_dir = './data'
documents = []
for file_name in os.listdir(data_dir):
    with open(os.path.join(data_dir, file_name), 'r') as file:
        documents.append(file.read())

embeddings = embedding_model.encode(documents, convert_to_tensor=True)

retriever = DeepSeekRetriever()
retriever.add_documents(documents, embeddings)
retriever.save('knowledge_base.ds')
```

### Generation Pipeline

```python
from transformers import AutoModelForCausalLM, AutoTokenizer

generator_model = AutoModelForCausalLM.from_pretrained("gpt2")
tokenizer = AutoTokenizer.from_pretrained("gpt2")

def generate_response(query, retrieved_docs):
    input_text = query + "\n\n" + "\n".join(retrieved_docs)
    inputs = tokenizer.encode(input_text, return_tensors='pt', max_length=512, truncation=True)
    outputs = generator_model.generate(inputs, max_length=150, num_return_sequences=1)
    return tokenizer.decode(outputs[0], skip_special_tokens=True)
```

### Core Query Function

```python
def rag_query(query):
    retrieved_docs = retriever.search(query, top_k=3)
    response = generate_response(query, retrieved_docs)
    return response

query = "What is the impact of climate change on agriculture?"
response = rag_query(query)
print(response)
```

### Flask Deployment

```python
from flask import Flask, request, jsonify
from deep_seek_r1 import DeepSeekRetriever
from transformers import AutoModelForCausalLM, AutoTokenizer

retriever = DeepSeekRetriever.load('knowledge_base.ds')
generator_model = AutoModelForCausalLM.from_pretrained("gpt2")
tokenizer = AutoTokenizer.from_pretrained("gpt2")

def generate_response(query, retrieved_docs):
    input_text = query + "\n\n" + "\n".join(retrieved_docs)
    inputs = tokenizer.encode(input_text, return_tensors='pt', max_length=512, truncation=True)
    outputs = generator_model.generate(inputs, max_length=150, num_return_sequences=1)
    return tokenizer.decode(outputs[0], skip_special_tokens=True)

app = Flask(__name__)

@app.route('/query', methods=['POST'])
def query():
    data = request.json
    query = data.get('query', '')
    if not query:
        return jsonify({'error': 'Query is required'}), 400

    retrieved_docs = retriever.search(query, top_k=3)
    response = generate_response(query, retrieved_docs)
    return jsonify({'response': response})

if __name__ == '__main__':
    app.run(debug=True)
```

### Testing the API

```bash
curl -X POST http://127.0.0.1:5000/query -H "Content-Type: application/json" -d '{"query": "What is the future of AI in healthcare?"}'
```

---

## Key Takeaways

- RAG systems enhance generative AI by grounding responses in retrieved knowledge
- The pipeline requires embedding models, retrieval mechanisms, and generation models
- Flask enables straightforward API deployment for production access
- Modular design allows scaling to PDFs, databases, and other document formats
