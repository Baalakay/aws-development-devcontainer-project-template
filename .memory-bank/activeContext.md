# σ₄: Active Context
*v1.0 | Created: 2024-12-19 | Updated: 2024-12-19*
*Π: INITIALIZING | Ω: START*

## 🔮 Current Focus

**Framework Initialization**: Setting up CursorRIPER memory system and documenting current project state. The project is in the START phase (Π₂) with basic CDK infrastructure structure in place.

## 📎 Context References

### 📄 Active Files
- [app.py] Main CDK application entry point
- [cdk.json] CDK configuration and context
- [lib/stages.py] Deployment stage definitions
- [lib/infrastructure_stack.py] Core infrastructure stack
- [lib/application_stack.py] Application logic stack

### 💻 Active Code
- [CDK Stacks] Infrastructure and Application stack classes
- [Stage Management] Multi-environment deployment configuration
- [Lambda Layers] Bedrock service integration layer

### 📚 Active Docs
- [CDK Documentation] AWS CDK Python API reference
- [Project Requirements] User preferences and constraints
- [Architecture Patterns] Multi-stack CDK design

### 📁 Active Folders
- [lib/] CDK stack definitions and core logic
- [lambdas/] Lambda function implementations (to be developed)
- [lambda-layers/] Shared dependencies (to be implemented)
- [scripts/] Utility scripts (to be developed)

### 🔄 Git References
- [Repository] incident-extractor-app
- [Branch] Main development branch
- [Status] Initial framework setup

### 📏 Active Rules
- [CursorRIPER] Framework initialization and memory management
- [AWS Best Practices] CDK development and deployment patterns
- [User Preferences] MFA authentication, AWS deployment, pip package management

### 🚨 Critical Rules
- [Bedrock API] MUST use `converse()` method, NEVER `invoke_model()`
- [Model ID] Use Claude 3.7 Sonnet v2: `us.anthropic.claude-3-7-sonnet-20250219-v1:0`
- [System Prompts] Format as `[{"text": "prompt"}]` for Converse API

## 📡 Context Status

### 🟢 Active
- [CDK Infrastructure] Basic stack structure implemented
- [Environment Configuration] Dev and Staging stages defined
- [Memory System] CursorRIPER framework initialization

### 🟡 Partially Relevant
- [Lambda Functions] Structure defined but not implemented
- [Workflow Logic] Step Functions defined but not implemented
- [Testing Framework] Not yet established

### 🟣 Essential
- [AWS CDK] Core framework for infrastructure management
- [Python Environment] Development and runtime environment
- [Docker Support] Development container configuration

### 🔴 Deprecated
- None identified at this stage

## 🎯 Immediate Actions
1. Complete memory system initialization
2. Document current architecture state
3. Identify implementation gaps
4. Plan next development phase

## 📝 Notes
- Project uses "incident-extractor" naming convention (configurable via lib/config.py)
- AWS account IDs configurable via lib/config.py
- Basic CDK structure is in place but requires completion
- Lambda functions and workflows need implementation
- Testing and validation framework needs establishment
- START phase template created for future AWS CDK projects
- Template documentation organized in `.aws-templates/` folder