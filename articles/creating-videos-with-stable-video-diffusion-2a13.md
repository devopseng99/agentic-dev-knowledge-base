---
title: "Creating Videos with Stable Video Diffusion"
url: "https://dev.to/jeremycmorgan/creating-videos-with-stable-video-diffusion-2a13"
author: "Jeremy Morgan"
category: "ai-media-generation"
---
# Creating Videos with Stable Video Diffusion
**Author:** Jeremy Morgan  **Published:** February 12, 2024

## Overview
This tutorial guides developers through installing and running Stable Video Diffusion locally. The article demonstrates how to generate AI videos from static images using open-source tools, covering environment setup through video generation.

## Key Concepts
- Local deployment of generative AI video models
- Virtual environment configuration with Anaconda and Python 3.10
- GPU memory management optimization for video generation
- Streamlit-based web interface for model interaction
- Frame-rate and duration customization for output videos

```bash
git clone https://github.com/Stability-AI/generative-models.git && cd generative-models
conda create --name stablevideodiff python=3.10.0
conda activate stablevideodiff
pip3 install -r requirements/pt2.txt
pip3 install .
pip3 install -e git+https://github.com/Stability-AI/datapipelines.git@main#egg=sdata
export 'PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512'
PYTHONPATH=. streamlit run scripts/demo/video_sampling.py --server.port 8080
```

- GitHub: https://github.com/Stability-AI/generative-models.git
- Data Pipeline: https://github.com/Stability-AI/datapipelines.git
- Model Weights: https://huggingface.co/stabilityai/stable-video-diffusion-img2vid
