# σ₃: Technical Context
*v1.0 | Created: 2024-12-19 | Updated: 2024-12-19*
*Π: INITIALIZING | Ω: START*

## 🛠️ Technology Stack

### 🖥️ Frontend
- **Streamlit**: Web application framework (referenced in requirements.txt)
- **Ag-Grid**: Data grid component with custom theming

### ☁️ Backend & Infrastructure
- **AWS CDK**: Infrastructure as Code framework
- **Python 3.12**: Primary development language
- **AWS Lambda**: Serverless compute
- **AWS S3**: Object storage
- **AWS DynamoDB**: NoSQL database
- **AWS Step Functions**: Workflow orchestration
- **AWS SQS**: Message queuing
- **AWS IAM**: Identity and access management
- **AWS CloudWatch**: Logging and monitoring

### 🔧 Development Tools
- **pip**: Package management (required for CDK)
- **Docker**: Containerization via devcontainer

- **AWS SAM**: Serverless Application Model for local testing

### 📊 Data Processing
- **AWS Bedrock**: LLM integration for vision analysis
- **CSV-centric approach**: ML feature and prediction storage
- **SageMaker Canvas**: Interactive ML demos

## 🌍 Environment Configuration
- **Dev**: Account configurable via lib/config.py, us-east-1, shorter retention, relaxed security
- **Staging**: Account configurable via lib/config.py, us-east-1, medium retention, standard security
- **Production**: Account configurable via lib/config.py, us-east-1, full retention, strict security

## 🔐 Security & Compliance
- **MFA Authentication**: Required for AWS operations
- **Profile-based access**: "mfa-auth" profile for AWS toolkit
- **AWS deployment**: Direct deployment to AWS environments
- **Credential sharing**: Containers share host AWS credentials

## 🔧 Project Configurationn- **Configurable Naming**: Project name and resource naming controlled via `lib/config.py`n- **Configurable Accounts**: AWS account IDs controlled via `lib/config.py`n- **Template Ready**: Easy to reuse for other AWS CDK projects by changing PROJECT_NAME and AWS_ACCOUNTSn- **Environment Aware**: Automatic environment-specific configurationsnn## 📁 Project Structure
```
/
├── .memory-bank/          # CursorRIPER memory system
├── .devcontainer/         # Development container config
├── lib/                   # CDK stack definitions
├── lambdas/               # Lambda function code
├── lambda-layers/         # Shared Lambda dependencies
├── scripts/               # Utility scripts
├── assets/                # Static assets
└── cdk.out/              # CDK synthesis output
```