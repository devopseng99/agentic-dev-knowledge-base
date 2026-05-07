---
title: "Use Mistral AI to build generative AI applications with Go"
url: "https://dev.to/aws/use-mistral-ai-to-build-generative-ai-applications-with-go-2hpa"
author: "Abhishek Gupta"
category: "mistral-ai-agent"
---

# Use Mistral AI to build generative AI applications with Go

**Author:** Abhishek Gupta
**Published:** August 9, 2024

## Overview
Tutorial on using Mistral AI models (Mistral 7B, Mixtral 8x7B, Mistral Large) on Amazon Bedrock with the AWS SDK for Go, covering basic invocation, multi-turn chat, and streaming responses.

## Key Concepts

### Basic Model Invocation

```go
const modelID7BInstruct = "mistral.mistral-7b-instruct-v0:2"
const promptFormat = "<s>[INST] %s [/INST]"

func main() {
    msg := "Hello, what's your name?"

    payload := MistralRequest{
        Prompt: fmt.Sprintf(promptFormat, msg),
    }
}
```

### Request/Response Structs

```go
type MistralRequest struct {
    Prompt        string   `json:"prompt"`
    MaxTokens     int      `json:"max_tokens,omitempty"`
    Temperature   float64  `json:"temperature,omitempty"`
    TopP          float64  `json:"top_p,omitempty"`
    TopK          int      `json:"top_k,omitempty"`
    StopSequences []string `json:"stop,omitempty"`
}
```

### Invoke Model via Bedrock

```go
output, err := brc.InvokeModel(context.Background(), &bedrockruntime.InvokeModelInput{
    Body:        payloadBytes,
    ModelId:     aws.String(modelID7BInstruct),
    ContentType: aws.String("application/json"),
})

var resp MistralResponse
err = json.Unmarshal(output.Body, &resp)
fmt.Println("response string:\n", resp.Outputs[0].Text)
```

### Multi-Turn Chat with Mixtral 8x7B

```go
const userMessageFormat = "[INST] %s [/INST]"
const modelID8X7BInstruct = "mistral.mixtral-8x7b-instruct-v0:1"
const bos = "<s>"
const eos = "</s>"

func main() {
    reader := bufio.NewReader(os.Stdin)
    first := true
    var msg string

    for {
        fmt.Print("\nEnter your message: ")
        input, _ := reader.ReadString('\n')
        input = strings.TrimSpace(input)

        if first {
            msg = bos + fmt.Sprintf(userMessageFormat, input)
        } else {
            msg = msg + fmt.Sprintf(userMessageFormat, input)
        }

        payload := MistralRequest{
            Prompt: msg,
        }

        response, err := send(payload)
        fmt.Println("[Assistant]:", response)
        msg = msg + response + eos + " "
        first = false
    }
}
```

### Streaming Responses

```go
output, err := brc.InvokeModelWithResponseStream(context.Background(),
    &bedrockruntime.InvokeModelWithResponseStreamInput{
    Body:        payloadBytes,
    ModelId:     aws.String(modelID7BInstruct),
    ContentType: aws.String("application/json"),
})

func processStreamingOutput(output *bedrockruntime.InvokeModelWithResponseStreamOutput,
    handler StreamingOutputHandler) (MistralResponse, error) {

    var combinedResult string
    resp := MistralResponse{}
    op := Outputs{}

    for event := range output.GetStream().Events() {
        switch v := event.(type) {
        case *types.ResponseStreamMemberChunk:
            var pr MistralResponse
            err := json.NewDecoder(bytes.NewReader(v.Value.Bytes)).Decode(&pr)
            if err != nil {
                return resp, err
            }

            handler(context.Background(), []byte(pr.Outputs[0].Text))
            combinedResult += pr.Outputs[0].Text
            op.StopReason = pr.Outputs[0].StopReason
        }
    }

    op.Text = combinedResult
    resp.Outputs = []Outputs{op}
    return resp, nil
}
```
