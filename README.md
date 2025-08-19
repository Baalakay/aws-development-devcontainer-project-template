# Incident Extractor Application

A serverless AWS CDK application for processing and analyzing incident data using AI/ML capabilities.

## 🚀 Quick Start

### Prerequisites
- Python 3.12+
- AWS CDK CLI
- Docker (for devcontainer)
- uv package manager

### Installation
```bash
# Install dependencies
uv sync

# Deploy to LocalStack for testing
cdk deploy --profile localstack

# Deploy to AWS
cdk deploy --profile mfa-auth
```

## 🔧 Configuration

### Project Naming
To reuse this project as a template for other AWS CDK projects:

1. **Edit `lib/config.py`**:
   ```python
   PROJECT_NAME = "your-new-project-name"
   ```

2. **Update `package.json`**:
   ```json
   {
     "name": "your-new-project-name"
   }
   ```

3. **Run `npm install`** to update package-lock.json

That's it! All resource naming throughout the project will automatically use your new project name.

## 🏗️ Architecture

- **InfrastructureStack**: Core AWS resources (S3, DynamoDB, IAM)
- **ApplicationStack**: Business logic and workflows (Lambda, Step Functions, SQS)
- **Multi-Environment**: Dev, Staging, and Production configurations

## 📚 Documentation

See `.memory-bank/` for comprehensive project documentation and CursorRIPER framework details.

## 🔐 Security

- MFA authentication required for AWS operations
- Environment-specific security policies
- LocalStack testing before AWS deployment