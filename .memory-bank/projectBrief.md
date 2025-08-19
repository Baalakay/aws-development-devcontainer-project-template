# σ₁: Project Brief
*v1.0 | Created: 2024-12-19 | Updated: 2024-12-19*
*Π: INITIALIZING | Ω: START*

## 🏆 Overview

**Incident Extractor Application** - A serverless AWS-based system for processing and analyzing incident data using AI/ML capabilities. The application leverages AWS Bedrock for LLM vision analysis and provides a multi-stage deployment pipeline for development, staging, and production environments.

## 📋 Requirements

### 🎯 Core Requirements
- [R₁] **Multi-Environment Deployment**: Support for Dev, Staging, and Production environments
- [R₂] **Serverless Architecture**: AWS Lambda-based processing with Step Functions orchestration
- [R₃] **AI/ML Integration**: AWS Bedrock integration for LLM vision analysis
- [R₄] **Data Processing Pipeline**: S3 → Lambda → Step Functions → SQS workflow
- [R₅] **Environment Isolation**: Separate configurations and policies per deployment stage

### 🛡️ Security Requirements
- [R₆] **MFA Authentication**: Required for all AWS operations
- [R₇] **IAM Security**: Least-privilege access policies
- [R₈] **Environment Security**: Progressive security hardening across stages
- [R₉] **AWS Deployment**: Direct deployment to AWS environments

### 🚨 Critical Technical Requirements
- [R₁₄] **Bedrock Converse API**: MUST use `converse()` method, NEVER `invoke_model()`
- [R₁₅] **Model ID**: Use Claude 3.7 Sonnet v2: `us.anthropic.claude-3-7-sonnet-20250219-v1:0`
- [R₁₆] **System Prompts**: Format as `[{"text": "prompt"}]` for Converse API
- [R₁₇] **API Compliance**: Follow AWS Bedrock Converse API documentation

### 🔧 Technical Requirements
- [R₁₀] **Python CDK**: Infrastructure as Code using Python 3.12
- [R₁₁] **Package Management**: pip for dependency management (CDK requirement)
- [R₁₂] **Container Support**: Docker devcontainer for development
- [R₁₃] **Monitoring**: CloudWatch integration for observability

## 🎯 Success Criteria
- [SC₁] Successful deployment to all three environments
- [SC₂] AWS deployment validation of all infrastructure components
- [SC₃] Integration testing of AI/ML workflows
- [SC₄] Performance validation across environment stages
- [SC₅] Security compliance verification

## 📊 Current Status
- **Phase**: Π₂ (INITIALIZING)
- **Completion**: 15% (Basic structure in place)
- **Next Milestone**: Complete infrastructure stack implementation
- **Blockers**: None identified

## 🔄 Next Steps
1. Complete infrastructure stack implementation
2. Implement application stack workflows
3. Add Lambda function implementations
4. Configure monitoring and alerting
5. Implement testing framework
6. Deploy to AWS for validation