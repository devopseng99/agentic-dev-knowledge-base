---
title: "Move Your Hugging Face LLM to S3 Like a Pro (Without Wasting Local Space!)"
url: "https://dev.to/codexmaker/move-your-hugging-face-llm-to-s3-like-a-pro-without-wasting-local-space-15kp"
author: "Samuel Vazquez"
category: "huggingface-llm-agents"
---
# Move Your Hugging Face LLM to S3 Like a Pro (Without Wasting Local Space!)
**Author:** Samuel Vazquez  **Published:** March 8, 2025

## Overview
This tutorial demonstrates how to efficiently transfer large language models (100+ GB) from Hugging Face to AWS S3 while managing local storage constraints. The guide works in AWS SageMaker Jupyter notebooks or local machines with AWS CLI configured, streaming downloads and uploads to avoid disk bloat.

## Key Concepts
- Streaming downloads and uploads to avoid disk bloat
- Automated file cleanup after successful S3 transfer
- Hugging Face cache management
- Disk space monitoring and optimization
- AWS S3 bucket integration with Python

## Code Examples

### Setup and Dependencies
```python
import os
import boto3
from huggingface_hub import hf_hub_download

s3_client = boto3.client('s3')
BUCKET_NAME = 'your-s3-bucket-name'
SAVE_DIR = "/home/sagemaker-user/"
repo_id = "deepseek-ai/DeepSeek-R1-Distill-Llama-70B"
```

### S3 Upload Function
```python
def upload_to_s3(local_file_path, s3_key):
    s3_client.upload_file(local_file_path, BUCKET_NAME, s3_key)
    print(f"Uploaded {local_file_path} to S3 bucket {BUCKET_NAME}")
```

### File Deletion Function
```python
def remove_local_file(file_path):
    try:
        os.remove(file_path)
        print(f"Removed local file {file_path}")
    except Exception as e:
        print(f"Error removing file {file_path}: {str(e)}")
```

### Main Processing Loop
```python
for file_name in model_files:
    local_file_path = hf_hub_download(
        repo_id=repo_id,
        filename=file_name,
        local_dir=SAVE_DIR
    )
    s3_key = f"models/deepseek/{file_name}"
    upload_to_s3(local_file_path, s3_key)
    remove_local_file(local_file_path)
```

### Cache Cleanup
```python
import shutil

def clear_huggingface_cache(cache_dir):
    try:
        shutil.rmtree(cache_dir)
        print(f"Cleared cache at {cache_dir}")
    except Exception as e:
        print(f"Error clearing cache: {str(e)}")
```

### Disk Space Monitoring
```python
def check_disk_space(directory):
    total, used, free = shutil.disk_usage(directory)
    print(f"Total: {total} GB, Used: {used} GB, Free: {free} GB")
```
