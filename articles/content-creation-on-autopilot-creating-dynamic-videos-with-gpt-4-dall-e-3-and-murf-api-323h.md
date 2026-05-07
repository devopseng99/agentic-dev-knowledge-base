---
title: "Prompt to Video: Creating Dynamic Videos with GPT-4, DALL-E 3, and Murf API"
url: "https://dev.to/devgeetech/content-creation-on-autopilot-creating-dynamic-videos-with-gpt-4-dall-e-3-and-murf-api-323h"
author: "Joel Gee Roy"
category: "ai-media-generation"
---
# Prompt to Video: Creating Dynamic Videos with GPT-4, DALL-E 3, and Murf API
**Author:** Joel Gee Roy  **Published:** November 7, 2023

## Overview
The project demonstrates automating video generation from text prompts by chaining multiple AI services. Users submit a simple prompt (e.g., "Documentary on penguins"), and the system returns a complete video. GPT-4 generates a structured script, DALL-E 3 creates images, Murf API produces voiceovers, and MoviePy combines these elements into a final video file.

## Key Concepts

- **Multi-AI Pipeline:** Sequential use of GPT-4, DALL-E, and text-to-speech services
- **Structured Output:** GPT-4 generates JSON with text, image prompts, and voice IDs
- **Voice Selection:** AI automatically chooses appropriate voices based on video genre
- **Media Synthesis:** Downloads and stitches images and audio into video clips

```python
from fastapi import FastAPI
app = FastAPI()

@app.get("/")
def get_root():
    return {"message": "Hello World"}
```

```python
def get_script(prompt=str):
    res = client.chat.completions.create(
        model="gpt-4-1106-preview",
        response_format={"type": "json_object"},
        messages=[
            {
                "role": "system",
                "content": "You are an automated system that helps generate 10-second videos..."
            },
            {"role": "user", "content": prompt}
        ]
    )
    json_str = res.choices[0].message.content
    return json.loads(json_str)
```

```python
def get_image(prompt=str):
    response = client.images.generate(
        model="dall-e-3",
        prompt=prompt,
        size="1024x1024",
        quality="standard",
        n=1
    )
    image_url = response.data[0].url
    return image_url
```

```python
def get_voiceover_url(text=str, voice_id=str):
    url = "https://api.murf.ai/v1/speech/generate-with-key"
    payload = json.dumps({
        "voiceId": voice_id,
        "text": text
    })
    headers = {
        "Content-Type": "application/json",
        "api-key": settings.murf_ai_api_key
    }
    response = requests.request("POST", url, headers=headers, data=payload)
    return response.json()["audioFile"]
```

```python
from moviepy.editor import ImageClip, AudioFileClip, concatenate_videoclips

def get_final_video(data_list):
    video_clips = []
    for data in data_list:
        audio_clip = AudioFileClip(audio_path)
        video_clip = ImageClip(image_path, duration=(int(audio_clip.duration) + 1))
        video_clip = video_clip.set_audio(audio_clip)
        video_clips.append(video_clip)
    
    final_video = concatenate_videoclips(video_clips)
    final_video.write_videofile("output_video.mp4", fps=24, codec="libx264")
```

- GitHub: https://github.com/devgeetech/ai-video-generator
