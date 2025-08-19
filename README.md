# Incident Extractor Application

A serverless AWS CDK application for processing and analyzing incident data using AI/ML capabilities.

## 🚀 Quick Start

### Prerequisites
- Python 3.12+
- AWS CDK CLI
- Docker (for devcontainer)
- pip package manager

### Installation
```bash
# Install dependencies
pip install -r requirements.txt

# Deploy to AWS Dev environment
cdk deploy --profile default

# Deploy to AWS
cdk deploy --profile mfa-auth
```

## 🔧 Configuration

### Project Configuration
To reuse this project as a template for other AWS CDK projects:

1. **Edit `lib/config.py`**:
   ```python
   PROJECT_NAME = "your-new-project-name"
   AWS_ACCOUNTS = {
       "dev": "your-dev-account",
       "staging": "your-staging-account", 
       "prod": "your-prod-account"
   }
   ```

2. **Update `package.json`**:
   ```json
   {
     "name": "your-new-project-name"
   }
   ```

3. **Run `npm install`** to update package-lock.json

That's it! All resource naming and AWS accounts throughout the project will automatically use your new configuration.

## 🏗️ Architecture

- **InfrastructureStack**: Core AWS resources (S3, DynamoDB, IAM)
- **ApplicationStack**: Business logic and workflows (Lambda, Step Functions, SQS)
- **Multi-Environment**: Dev, Staging, and Production configurations

## 📚 Documentation

See `.memory-bank/` for comprehensive project documentation and CursorRIPER framework details.

## 🔐 Security

- MFA authentication required for AWS operations
- Environment-specific security policies
- AWS deployment with MFA authentication