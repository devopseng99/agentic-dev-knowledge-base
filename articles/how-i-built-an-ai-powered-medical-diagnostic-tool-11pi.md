---
title: "How I Built an AI-Powered Medical Diagnostic Tool"
url: "https://dev.to/ratan_3511/how-i-built-an-ai-powered-medical-diagnostic-tool-11pi"
author: "Ratan"
category: "healthcare-ai"
---
# How I Built an AI-Powered Medical Diagnostic Tool
**Author:** Ratan  **Published:** May 6, 2025

## Overview
Documents the development of a comprehensive medical diagnostic system combining deep learning and NLP. Enables users—clinicians, researchers, and patients—to upload medical images or reports for instant AI-powered analysis. Dual pipeline architecture with separate imaging and text analysis workflows with explainability via heatmaps and confidence scoring.

## Key Concepts
- Dual Pipeline Architecture: separate imaging and text analysis workflows
- Explainability: heatmap visualizations and confidence scoring for transparency
- Modularity: extensible design supporting multiple medical imaging modalities
- Backend: FastAPI, Python, PyTorch, Transformers, OpenCV, PyMuPDF
- Frontend: React, Tailwind CSS
- ML Models: DenseNet, EfficientNet, ResNet, BioClinicalBERT
- Live tool: https://ai.allimageresizer.com/medical-diagnostics

```python
import timm
import torch

model = timm.create_model('densenet121', pretrained=True)
model.classifier = torch.nn.Linear(model.classifier.in_features, 14)
model.load_state_dict(torch.load('models/weights/chexpert_densenet121.pt'))
model.eval()
```

```python
def generate_heatmap(image, class_idx):
    output = model(image)
    model.zero_grad()
    output[0, class_idx].backward(retain_graph=True)
    gradients = self.get_activation_gradients()
    activations = self.get_activations().detach()
    weights = torch.mean(gradients, dim=[0, 2, 3])
    cam = torch.zeros(activations.shape[1:], dtype=torch.float32)
    for i, w in enumerate(weights):
        cam += w * activations[0, i, :, :]
    cam = np.maximum(cam.cpu(), 0)
    cam = cam / np.max(cam)
    return self.overlay_heatmap(cam, original_image)
```

```python
reference_ranges = {
    "hemoglobin": {"unit": "g/dL", "low": 12.0, "high": 16.0},
    "wbc": {"unit": "K/µL", "low": 4.5, "high": 11.0},
    "glucose": {"unit": "mg/dL", "low": 70, "high": 100}
}

def is_abnormal(lab_name, value):
    if lab_name.lower() in reference_ranges:
        range_info = reference_ranges[lab_name.lower()]
        return value < range_info["low"] or value > range_info["high"]
    return False
```

```javascript
async function analyzeMedicalImage(imageFile) {
  const formData = new FormData();
  formData.append('file', imageFile);
  formData.append('file_type', 'image');
  formData.append('analysis_type', 'comprehensive');

  const response = await fetch('https://your-api-endpoint/analyze', {
    method: 'POST',
    body: formData
  });
  return await response.json();
}
```

```bash
cd medical-diagnostic-tool
pip install -r requirements.txt
npm install

# Backend
cd medical_service
uvicorn main:app --reload

# Frontend
cd ..
npm start
```
