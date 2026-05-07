---
title: "A 3D Body from Eight Questions — No Photo, No GPU"
url: "https://dev.to/arkadiuss/a-3d-body-from-eight-questions-no-photo-no-gpu-4277"
author: "Arkadiusz"
category: "3d-ai-generation"
---
# A 3D Body from Eight Questions — No Photo, No GPU
**Author:** Arkadiusz  **Published:** 2026-04-22

## Overview
A questionnaire-based system that generates 3D body models from eight simple questions without requiring photos or GPU processing. Achieves height accuracy of 0.3 cm, mass accuracy of 0.3 kg, and body measurements within 3–4 cm.

## Key Concepts

### Backstory
Research by Bartol et al. (2022) showed that simple linear regression from just height and weight predicts 15 body measurements at 1.2–1.6 cm MAE. However, identical height/weight can produce vastly different body shapes.

### Features Beyond Height & Weight
Additional questionnaire inputs:
- **Build/Belly:** Athletic versus soft body composition
- **Shape:** Distribution of weight (wider hips versus larger bust)
- **Cup size:** Relevant for women

Body shape alone can create 25 cm bust and 30 cm hip differences at identical height/weight.

### Model Architecture
- Two gender-specific MLPs (separate male/female networks)
- Two hidden layers with 256 units each
- ReLU activation with dropout
- 85 KB weight file, trains in ~60 minutes on laptop
- 20 input features (one-hot encoded from 8 questions) → 58 Anny body parameters

### Physics-Aware Loss Function
The innovation centers on including the body model's forward pass in the loss calculation:

1. MLP outputs feed into Anny model (body mesh)
2. Mesh generates blendshapes and calculates volume
3. Volume × density = mass
4. Loss compares predicted mass/height against user-provided targets
5. Gradients flow backward through volume calculations

### Results

| Metric | Male | Female |
|--------|------|--------|
| Height (mean/p95/max) | 0.3/0.8/3.9 cm | 0.3/0.8/4.6 cm |
| Mass (mean/p95/max) | 0.5/1.2/3.3 kg | 0.4/1.0/2.1 kg |
| Bust (mean/p95/max) | 4.9/11.9/18.4 cm | 2.7/6.6/11.0 cm |
| Waist (mean/p95/max) | 4.3/10.0/20.7 cm | 4.0/9.0/13.0 cm |
| Hips (mean/p95/max) | 3.3/8.4/14.8 cm | 3.3/8.0/13.3 cm |

The photo-based pipeline achieves 5–8 cm accuracy; the questionnaire surpasses it without photos.

### Lessons Learned
- **Body Density Corrections:** Anny incorrectly used uniform 980 kg/m³ density; implemented Navy formula with per-gender tissue density values
- **Ancestry Blendshapes:** Adding ancestry to the questionnaire resolved 3 kg noise floor
- **Measurement Precision:** A 2 cm shift across all torso circumferences changes computed mass by ~2 kg

## GitHub Links
- https://github.com/datar-psa/clad-body
