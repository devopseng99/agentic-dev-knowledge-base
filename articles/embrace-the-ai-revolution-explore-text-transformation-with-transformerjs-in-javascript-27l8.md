---
title: "Embrace the AI Revolution: Explore Text Transformation with Transformers.js in JavaScript"
url: "https://dev.to/robertobutti/embrace-the-ai-revolution-explore-text-transformation-with-transformerjs-in-javascript-27l8"
author: "Roberto B."
category: "huggingface-llm-agents"
---
# Embrace the AI Revolution: Explore Text Transformation with Transformers.js in JavaScript
**Author:** Roberto B.  **Published:** March 9, 2024

## Overview
This tutorial introduces Transformers.js, a JavaScript library enabling natural language processing tasks through pre-trained transformer models. The article demonstrates how developers can implement NLP capabilities directly in JavaScript environments without deep ML expertise, covering translation, question-answering, and text-to-speech.

## Key Concepts
- Transformer Architecture — based on "Attention is All You Need" research
- NLP Applications — translation, summarization, sentiment analysis, NER, question-answering
- Pre-trained Models — available via Hugging Face; automatically cached locally on first use
- Model Types — BERT (context understanding), GPT (text generation), T5 (text-to-text tasks)
- Pipeline Function — simplifies model access and inference execution

## Code Examples

### Installation
```shell
npm i --save @xenova/transformers
npm i --save wavefile
```

### Package Configuration
```json
{
  "type": "module",
  "dependencies": {
    "@xenova/transformers": "^2"
  }
}
```

### Translation Example
```javascript
import { pipeline } from "@xenova/transformers";
const translator = await pipeline('translation', 'Xenova/nllb-200-distilled-600M');
const output = await translator("There are many things we don't know about space...", {
  src_lang: 'eng_Latn',
  tgt_lang: 'ita_Latn',
});
console.log(output)
```

### Question-Answering Example
```javascript
import { pipeline } from "@xenova/transformers";
const answerer = await pipeline('question-answering');
const context = "My name is Roberto, and I enjoy programming primarily in PHP...";
const question = "Which is my favourite programming language?";
const answer = await answerer(question, context);
console.log(answer)
```

### Text-to-Speech Example
```javascript
import { pipeline } from "@xenova/transformers";
import wavefile from "wavefile";
import fs from "fs";

const synthesizer = await pipeline("text-to-speech", "Xenova/speecht5_tts", {
  quantized: false,
});
const speaker_embeddings = "https://huggingface.co/datasets/Xenova/transformers.js-docs/resolve/main/speaker_embeddings.bin";
const out = await synthesizer("Hello, with Transformers you can transform text into audio.", {
  speaker_embeddings,
});
const wav = new wavefile.WaveFile();
wav.fromScratch(1, out.sampling_rate, "32f", out.audio);
fs.writeFileSync("out.wav", wav.toBuffer());
```
