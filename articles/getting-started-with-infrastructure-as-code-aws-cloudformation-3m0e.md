---
title: "Getting Started with Infrastructure as Code: AWS CloudFormation"
url: "https://dev.to/umoren/getting-started-with-infrastructure-as-code-aws-cloudformation-3m0e"
author: "Samuel Umoren"
category: "templatized-software"
---
# Getting Started with Infrastructure as Code: AWS CloudFormation
**Author:** Samuel Umoren  **Published:** April 19, 2023

## Overview
This guide introduces AWS CloudFormation as an Infrastructure as Code solution, explaining how to use JSON or YAML templates to provision, manage, and replicate cloud infrastructure consistently across regions.

## Key Concepts
- **Templates**: Blueprint documents (JSON/YAML format) defining AWS resources and their configurations
- **Stacks**: Live instantiations of templates; collections of AWS resources created and managed as a single unit
- **Change Sets**: Mechanism to preview differences between updated and current templates before applying modifications
- **Parameters**: Customizable input values allowing templates to be reusable across different deployments
- **Outputs**: Values exported from created resources, making information accessible outside the stack
- **Resources**: Core template section defining specific AWS services and their properties

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'A simple AWS CloudFormation template to create an S3 bucket'

Parameters:
  BucketName:
    Description: 'The name of the S3 bucket'
    Type: String

Resources:
  MyS3Bucket:
    Type: 'AWS::S3::Bucket'
    Properties:
      BucketName: !Ref BucketName

Outputs:
  BucketURL:
    Description: 'The URL of the created S3 bucket'
    Value: !GetAtt MyS3Bucket.WebsiteURL
```

```json
{
  "Resources": {
    "S3Bucket": {
      "Type": "AWS::S3::Bucket",
      "Properties": {
        "BucketName": "my-sample-bucket"
      }
    }
  }
}
```

```bash
aws cloudformation create-stack --stack-name <STACK_NAME> --template-body file://s3_bucket_template.yaml --parameters ParameterKey=BucketName,ParameterValue=<BUCKET_NAME>
```

```bash
aws cloudformation update-stack --stack-name my-new-s3-stack --template-body file://s3_bucket_template.yaml --parameters ParameterKey=BucketName,ParameterValue=your-unique-bucket-name
```

```bash
aws cloudformation delete-stack --stack-name my-new-s3-stack
```

```bash
aws cloudformation describe-stacks --stack-name <STACK_NAME> --query "Stacks[0].Outputs[?OutputKey=='BucketURL'].OutputValue" --output text
```

Sample template: https://gist.github.com/Umoren/afc57c954817f37dd4062dd0bf26f39c
