---
title: "Integrate Hugging Face Spaces & Gradio with a React application"
url: "https://dev.to/ganes1410/integrate-hugging-face-spaces-gradio-with-a-react-application-4a82"
author: "Ganesh R"
category: "huggingface-llm-agents"
---
# Integrate Hugging Face Spaces & Gradio with a React application
**Author:** Ganesh R  **Published:** October 12, 2024

## Overview
This tutorial guides developers through creating and deploying machine learning models using Hugging Face and Gradio, then integrating them into React applications. The article demonstrates building a cat image classifier and exposing it via API using the @gradio/client package.

## Key Concepts
- Hugging Face Spaces — cloud platform for hosting ML models
- Gradio — framework for building ML model user interfaces
- fast.ai — library for training vision models
- @gradio/client — package for connecting React apps to Gradio APIs
- Git LFS — required for tracking large model files

## Code Examples

### Python - Basic Gradio App
```python
import gradio as gr

def greet(name):
    return "Hello " + name + "!!"

demo = gr.Interface(fn=greet, inputs="text", outputs="text")
demo.launch()
```

### Python - Model Training (fast.ai)
```python
path = untar_data(URLs.PETS)/'images'
dls = ImageDataLoaders.from_name_func(
       path, get_image_files(path), valid_pct=0.2, seed=42,
       label_func=is_cat, item_tfms=Resize(224))

learn = vision_learner(dls, resnet34, metrics=error_rate)
learn.fine_tune(1)

learn.path = Path('.')
learn.export('cats_classifier.pkl')
```

### Python - Prediction Function
```python
model = load_learner('cats_classifier.pkl')

def predict(image):
    img = PILImage.create(image)
    _,_,probs = model.predict(img)
    return {'Not a Cat': float("{:.2f}".format(probs[0].item())),
            'Cat': float("{:.2f}".format(probs[1].item()))}

demo = gr.Interface(fn=predict, inputs=gr.Image(), outputs='label')
demo.launch()
```

### JavaScript/React - Gradio Client Integration
```javascript
import { Client } from "@gradio/client";

const response_0 = await fetch("https://raw.githubusercontent.com/gradio-app/gradio/main/test/test_files/bus.png");
const exampleImage = await response_0.blob();

const client = await Client.connect("ganesh1410/basic-classifier");
const result = await client.predict("/predict", {
    image: exampleImage,
});

console.log(result.data);
```
