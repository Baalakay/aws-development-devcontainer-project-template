# σ₆: Protection Registry
*v1.0 | Created: 2024-12-19 | Updated: 2024-12-19*
*Π: INITIALIZING | Ω: START*

## 🛡️ Protected Regions

### 🔒 PROTECTED - DO NOT MODIFY
- [P₁] **AWS Account Configuration**: Account IDs and region settings in app.py
- [P₂] **CDK Context**: Configuration settings in cdk.json
- [P₃] **Project Structure**: Core directory layout and file organization

### 🛡️ GUARDED - ASK BEFORE MODIFYING
- [G₁] **Environment Configurations**: Stage-specific settings in stack classes
- [G₂] **Naming Conventions**: Resource naming patterns and conventions
- [G₃] **Security Policies**: IAM policies and access controls

### ℹ️ INFO - CONTEXT NOTE
- [I₁] **User Preferences**: MFA authentication, AWS deployment, pip package management
- [I₂] **Architecture Decisions**: Multi-stack CDK design pattern
- [I₃] **Technology Choices**: Python CDK, AWS services selection

### 🐞 DEBUG - DEBUGGING CODE
- [D₁] **Development Logs**: Debug output and development assistance
- [D₂] **Error Handling**: Exception handling and error reporting

### 🧪 TEST - TESTING CODE
- [T₁] **Test Framework**: Unit and integration test implementations
- [T₂] **AWS Testing**: AWS deployment validation

### ⚠️ CRITICAL - BUSINESS LOGIC
- [C₁] **Core Workflows**: Step Functions and Lambda function logic
- [C₂] **Data Processing**: S3 → Lambda → Step Functions → SQS pipeline
- [C₃] **AI/ML Integration**: Bedrock service integration and LLM workflows

### 🚨 CRITICAL - BEDROCK API USAGE
- [C₄] **Bedrock Converse API**: MUST use `bedrock_runtime.converse()` method
- [C₅] **Bedrock InvokeModel**: NEVER use `bedrock_runtime.invoke_model()` method
- [C₆] **Model ID**: Use Claude 3.7 Sonnet v2: `us.anthropic.claude-3-7-sonnet-20250219-v1:0`
- [C₇] **System Prompts**: Format as `[{"text": "system prompt"}]` for Converse API
- [C₈] **API Reference**: Follow AWS documentation: https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference-examples.html

## 📜 Protection History

### 2024-12-19
- **Framework Initialization**: Created protection registry
- **Documentation**: Established protection levels for all major components
- **User Preferences**: Documented critical user requirements and constraints

## ✅ Approvals

### Current Approvals
- None pending

### Approval History
- None recorded

## ⚠️ Permission Violations

### Violation Log
- None recorded

### Violation Prevention
- **Mode Enforcement**: CursorRIPER modes enforce appropriate permissions
- **Protection Scanning**: Regular scanning for protection violations
- **Backup System**: Automatic backups before any modifications

## 🔍 Protection Scanning

### Last Scan
- **Date**: 2024-12-19
- **Status**: Initial scan completed
- **Findings**: All critical components properly protected

### Scan Schedule
- **Frequency**: Before any modification operations
- **Scope**: All protected regions and critical components
- **Action**: Block unauthorized modifications and log violations

## 🛡️ Protection Guidelines

### For Developers
1. **Respect Protection Levels**: Never modify PROTECTED regions
2. **Request Permission**: Ask before modifying GUARDED regions
3. **Document Changes**: Record all modifications with rationale
4. **Test Safely**: Use designated testing regions for experiments

### For Reviewers
1. **Verify Protection**: Ensure protection levels are appropriate
2. **Approve Changes**: Grant permission for GUARDED modifications
3. **Monitor Violations**: Track and address any protection violations
4. **Update Registry**: Keep protection registry current