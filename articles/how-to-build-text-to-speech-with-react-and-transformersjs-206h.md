---
title: "How to Build Text-to-Speech with React and Transformers.js (Background Removal)"
url: "https://dev.to/emojiiii/how-to-build-text-to-speech-with-react-and-transformersjs-206h"
author: "emojiiii"
category: "huggingface-llm-agents"
---
# How to Build Text-to-Speech with React and Transformers.js (Background Removal)
**Author:** emojiiii  **Published:** January 12, 2025

## Overview
This tutorial demonstrates building a browser-based background removal application using React and Transformers.js. The solution leverages AI models (RMBG-1.4 & ModNet) that execute locally in the browser using WebGPU, eliminating server dependencies while maintaining real-time processing capabilities.

## Key Concepts
- Image Segmentation — technique separating foreground subjects from backgrounds
- RMBG-1.4 & ModNet — pre-trained models optimized for background removal and human segmentation
- WebGPU and WebAssembly — technologies enabling efficient on-device AI processing
- Web Workers — offload computationally intensive tasks to prevent UI blocking
- Batch Processing Queue — sequential image handling system for scalability

## Code Examples

### Environment and Model Setup
```typescript
import {
  env,
  AutoModel,
  AutoProcessor,
  RawImage,
} from "@huggingface/transformers";

const setupEnvironment = () => {
  env.backends.onnx.wasm.proxy = false;
  if (!navigator.gpu) {
    throw new Error("WebGPU is not supported in this browser.");
  }
};

const initializeModel = async () => {
  const model = await AutoModel.from_pretrained("Xenova/modnet", {
    device: "webgpu",
  });
  const processor = await AutoProcessor.from_pretrained("Xenova/modnet");
  return { model, processor };
};
```

### Background Removal React Component
```typescript
import React, { useState, useCallback, useEffect } from "react";
import { useDropzone } from "react-dropzone";

const BackgroundRemover: React.FC = () => {
  const [model, setModel] = useState<any>(null);
  const [processor, setProcessor] = useState<any>(null);
  const [images, setImages] = useState<any[]>([]);
  const [isProcessing, setIsProcessing] = useState(false);

  useEffect(() => {
    (async () => {
      setupEnvironment();
      const { model: m, processor: p } = await initializeModel();
      setModel(m);
      setProcessor(p);
    })();
  }, []);

  const onDrop = useCallback(async (acceptedFiles: File[]) => {
    if (!model || !processor) return;
    setIsProcessing(true);

    for (const file of acceptedFiles) {
      const img = await RawImage.fromURL(URL.createObjectURL(file));
      const { pixel_values } = await processor(img);
      const { output } = await model({ input: pixel_values });

      const maskData = await RawImage.fromTensor(
        output[0].mul(255).to("uint8")
      ).resize(img.width, img.height);

      const canvas = document.createElement("canvas");
      canvas.width = img.width;
      canvas.height = img.height;
      const ctx = canvas.getContext("2d")!;

      ctx.drawImage(img.toCanvas(), 0, 0);
      const imageData = ctx.getImageData(0, 0, img.width, img.height);
      for (let j = 0; j < maskData.data.length; j++) {
        imageData.data[j * 4 + 3] = maskData.data[j];
      }
      ctx.putImageData(imageData, 0, 0);

      setImages(prev => [...prev, {
        id: crypto.randomUUID(),
        processed: canvas.toDataURL("image/png"),
        name: file.name,
      }]);
    }
    setIsProcessing(false);
  }, [model, processor]);

  const { getRootProps, getInputProps } = useDropzone({
    onDrop,
    accept: { "image/*": [".png", ".jpg", ".jpeg", ".webp"] },
    disabled: isProcessing || !model,
  });

  return (
    <div>
      <div {...getRootProps()} style={{ border: "2px dashed #666", padding: 20 }}>
        <input {...getInputProps()} />
        <p>{isProcessing ? 'Processing...' : 'Drop images here'}</p>
      </div>
      {images.map(img => (
        <img key={img.id} src={img.processed} alt="Processed" style={{ width: 200 }} />
      ))}
    </div>
  );
};
```

### Project Setup
```bash
pnpm create vite background-remover -- --template react-ts
cd background-remover
pnpm install @huggingface/transformers @emotion/react @emotion/styled @mui/material react-dropzone file-saver jszip
```
