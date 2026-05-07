---
title: "RAG on AWS: Building an AI-powered Knowledge Base with Amazon Bedrock and Pinecone using CloudFormation"
url: "https://dev.to/ddesio/rag-on-aws-building-an-ai-powerd-knowledge-base-with-amazon-bedrock-and-pinecone-using-aws-nl1"
author: "Davide De Sio"
category: "knowledge-base-embeddings"
---

# RAG on AWS: Building an AI-powered Knowledge Base with Amazon Bedrock and Pinecone

**Author:** Davide De Sio
**Published:** March 7, 2025

## Overview
Establishing an AI-powered knowledge base using CloudFormation, Amazon Bedrock, Pinecone, and S3 with dimension 1024 and cosine metric for the embedding model.

## Code Examples

### CloudFormation - Bedrock Knowledge Base

```yaml
KnowledgeBase:
  Type: "AWS::Bedrock::KnowledgeBase"
  Properties:
    Name: !Ref KnowledgeBaseName
    Description: "Knowledge base integrating Amazon Bedrock with Pinecone"
    RoleArn: !GetAtt BedrockIAMRole.Arn
    KnowledgeBaseConfiguration:
      Type: "VECTOR"
      VectorKnowledgeBaseConfiguration:
        EmbeddingModelArn: !Ref EmbeddingModel
    StorageConfiguration:
      Type: "PINECONE"
      PineconeConfiguration:
        ConnectionString: !Ref PineconeConnectionString
        CredentialsSecretArn: !Ref PineconeApiKeySecret
        FieldMapping:
          TextField: !Ref TextField
          MetadataField: !Ref MetadataField
        Namespace: !Sub "${KnowledgeBaseName}-namespace"
```

### IAM Role

```yaml
BedrockIAMRole:
  Type: "AWS::IAM::Role"
  Properties:
    AssumeRolePolicyDocument:
      Version: "2012-10-17"
      Statement:
        - Effect: "Allow"
          Principal:
            Service: "bedrock.amazonaws.com"
          Action: "sts:AssumeRole"
    Policies:
      - PolicyName: "BedrockAccessPolicy"
        PolicyDocument:
          Version: "2012-10-17"
          Statement:
            - Effect: "Allow"
              Action: ["s3:ListBucket"]
              Resource: !Sub "arn:aws:s3:::${KnowledgeBaseS3Bucket}"
            - Effect: "Allow"
              Action: ["s3:GetObject", "s3:PutObject"]
              Resource: !Sub "arn:aws:s3:::${KnowledgeBaseName}-bucket/*"
            - Effect: "Allow"
              Action: ["bedrock:InvokeModel"]
              Resource: "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0"
```

### Secrets Manager

```yaml
PineconeApiKeySecret:
  Type: "AWS::SecretsManager::Secret"
  Properties:
    Name: !Sub "${KnowledgeBaseName}-PineconeApiKey"
    SecretString: !Ref PineconeApiKey
```
