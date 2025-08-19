# σ₂: System Patterns
*v1.0 | Created: 2024-12-19 | Updated: 2024-12-19*
*Π: INITIALIZING | Ω: START*

## 🏛️ Architecture Overview

### 🏗️ Stack Architecture
The application follows a two-tier stack pattern:
1. **InfrastructureStack**: Core AWS resources (S3, DynamoDB, IAM, Lambda layers)
2. **ApplicationStack**: Business logic and workflows (Lambda functions, Step Functions, SQS)

### 🔄 Deployment Stages
- **Dev**: Development environment with relaxed settings
- **Staging**: Pre-production validation environment
- **Production**: Live production environment (account TBD)

### 🧩 Component Patterns

#### Infrastructure Layer
- **S3 Buckets**: Environment-specific naming with retention policies
- **DynamoDB Tables**: NoSQL data storage with environment-specific configurations
- **IAM Roles**: Least-privilege access policies
- **Lambda Layers**: Shared dependency management

#### Application Layer
- **Lambda Functions**: Serverless compute units
- **Step Functions**: Workflow orchestration
- **SQS Queues**: Asynchronous message processing
- **S3 Notifications**: Event-driven triggers

### 🔗 Integration Patterns
- **Event-Driven**: S3 → Lambda → Step Functions → SQS
- **Layered Dependencies**: Application stack references infrastructure stack
- **Environment Isolation**: Separate configurations per deployment stage

### 📊 Data Flow Patterns
- **Input**: S3 file uploads trigger processing workflows
- **Processing**: Lambda functions with Bedrock integration for LLM analysis
- **Output**: Processed data stored in DynamoDB and S3
- **Monitoring**: CloudWatch logs and metrics

## 🎯 Design Principles
- **Environment Parity**: Consistent architecture across stages
- **Resource Isolation**: Stage-specific resource naming and policies
- **Scalability**: Serverless architecture for automatic scaling
- **Security**: IAM-based access control with MFA requirements
- **Observability**: Comprehensive logging and monitoring

## 🔄 Lifecycle Management
- **Development**: Direct AWS deployment to dev environment
- **Validation**: Staging deployment for testing
- **Production**: Controlled deployment with full security
- **Maintenance**: Environment-specific retention and backup policies