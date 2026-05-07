---
title: "Run Models in the Browser With Transformers.js"
url: "https://dev.to/kenzic/run-models-in-the-browser-with-transformersjs-7g8"
author: "Chris McKenzie"
category: "huggingface-llm-agents"
---
# Run Models in the Browser With Transformers.js
**Author:** Chris McKenzie  **Published:** September 21, 2023

## Overview
This tutorial demonstrates how to run machine learning models directly in web browsers using Transformers.js, a JavaScript library built on Hugging Face's pretrained models. The article guides developers through building a text summarization application that executes AI inference client-side using ONNX Runtime.

## Key Concepts
- Transformers.js — JavaScript implementation enabling NLP, computer vision, audio, and multimodal processing in browsers
- ONNX Runtime — cross-platform ML model accelerator
- Model Selection Trade-offs — balancing accuracy, speed, and file size
- Client-Side Inference — running models without server dependency for privacy and reduced latency

## Recommended Models
- Xenova/t5-small — fast, lower accuracy
- Xenova/t5-base — moderate speed and accuracy
- Xenova/distilbart-cnn-6-6 — high accuracy, slower, ~1GB download
- Xenova/bart-large-cnn — best accuracy, slowest, ~1GB+ download

## Code Examples

### Import Library
```javascript
import { pipeline } from 'https://cdn.jsdelivr.net/npm/@xenova/transformers@2.3.0';
```

### Initialize Pipeline
```javascript
const summarization = await pipeline(
    'summarization',
    'Xenova/t5-small'
);
```

### HTML Structure
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Summary Generator</title>
    <script src="main.js" type="module" defer></script>
</head>
<body>
    <textarea id="long-text-input"></textarea>
    <button id="generate-button" disabled>Generate Summary</button>
    <div id="output-div"></div>
</body>
</html>
```

### CSS Styling
```css
button:disabled {
    background-color: #b3c2c8;
    cursor: not-allowed;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
```

### Event Handler
```javascript
generateButton.addEventListener('click', async () => {
    spinner.classList.add('show');
    generateButton.setAttribute("disabled", true);
    const result = await summarization(longTextInput.value, {
        min_length: 50,
        max_length: 250
    });
    output.innerHTML = result[0].summary_text;
    spinner.classList.remove('show');
});
```
