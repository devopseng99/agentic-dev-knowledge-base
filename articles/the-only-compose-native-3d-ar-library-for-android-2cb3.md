---
title: "The Only Compose-Native 3D & AR Library for Android"
url: "https://dev.to/thomasgorisse/the-only-compose-native-3d-ar-library-for-android-2cb3"
author: "Thomas Gorisse"
category: "3d-ai-generation"
---
# The Only Compose-Native 3D & AR Library for Android
**Author:** Thomas Gorisse  **Published:** 2026-04-13

## Overview
SceneView is a Compose-native 3D and AR library for Android that treats 3D declaratively, mirroring Compose's approach. Enables 3D product viewers, model configurators, and AR applications with 26+ composable node types.

## Key Concepts

### Installation

```kotlin
implementation("io.github.sceneview:sceneview:4.0.0")
```

### 3D Model Display Example

```kotlin
@Composable
fun ProductViewer() {
    val engine = rememberEngine()
    val modelLoader = rememberModelLoader(engine)

    SceneView(
        modifier = Modifier.fillMaxSize(),
        engine = engine,
        modelLoader = modelLoader,
        cameraManipulator = rememberCameraManipulator()
    ) {
        rememberModelInstance(modelLoader, "models/sneaker.glb")?.let {
            ModelNode(modelInstance = it, scaleToUnits = 1.0f, autoAnimate = true)
        }
    }
}
```

### AR Capabilities

```kotlin
implementation("io.github.sceneview:arsceneview:4.0.0")
```

AR furniture placement example:

```kotlin
@Composable
fun ARFurniturePlacement() {
    val engine = rememberEngine()
    val modelLoader = rememberModelLoader(engine)
    val anchors = remember { mutableStateListOf<Anchor>() }
    val chair = rememberModelInstance(modelLoader, "models/chair.glb")

    ARSceneView(
        modifier = Modifier.fillMaxSize(),
        engine = engine,
        modelLoader = modelLoader,
        planeRenderer = true,
        onTouchEvent = { hitResult, _ ->
            hitResult?.let { anchors.add(it.createAnchor()) }
        }
    ) {
        anchors.forEach { anchor ->
            chair?.let { model ->
                AnchorNode(anchor = anchor) {
                    ModelNode(
                        modelInstance = model,
                        scaleToUnits = 0.8f,
                        isEditable = true
                    )
                }
            }
        }
    }
}
```

### Built-In Node Types
26+ composable nodes including ModelNode, CubeNode, SphereNode, ImageNode, VideoNode, LightNode, TextNode, and ViewNode. Uses Google Filament for rendering.

### AI Integration
Library includes llms.txt API reference and MCP servers for Claude and Cursor:

```bash
npx sceneview-mcp
```

Industry-specific MCP servers for automotive, healthcare, gaming, and interior design.

### Cross-Platform Support
Android, iOS, macOS, visionOS, Web, Flutter, and React Native.

### License
Apache 2.0

## GitHub Links
- https://github.com/sceneview/sceneview (1.2k+ stars)
- MCP Server: https://www.npmjs.com/package/sceneview-mcp
