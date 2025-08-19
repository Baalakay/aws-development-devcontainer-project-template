# 🚀 CursorRIPER START Phase - AWS CDK Project Template

## 📋 **Standard START Phase Questions for AWS CDK Projects**

This template ensures consistent initialization of AWS CDK projects and creates a reusable foundation for future projects.

---

## 🏗️ **Project Foundation Questions**

### 1. **Project Type Confirmation**
- [ ] Is this an AWS CDK project?
- [ ] What is the primary use case/domain for this project?
- [ ] Will this project be used as a template for other AWS CDK projects?

### 2. **Technology Stack Confirmation**
- [ ] **Python Version**: Confirm Python 3.12+ for CDK compatibility?
- [ ] **Package Manager**: Use pip (CDK requirement) or other?
- [ ] **Container Support**: Docker devcontainer for development?
- [ ] **Local Testing**: AWS SAM for local testing or direct AWS deployment?

---

## ☁️ **AWS Service Configuration Questions**

### 3. **Core Infrastructure Services**

#### **S3 (Object Storage)**
- [ ] **Will S3 be used?** (Yes/No)
- [ ] **If YES**: What base name for S3 resources? (Recommended: `{PROJECT_NAME}-storage`)
- [ ] **Environment suffix**: Use `-{environment}` format? (e.g., `{PROJECT_NAME}-storage-dev`)

#### **DynamoDB (NoSQL Database)**
- [ ] **Will DynamoDB be used?** (Yes/No)
- [ ] **If YES**: What base name for DynamoDB resources? (Recommended: `{PROJECT_NAME}-data`)
- [ ] **Environment suffix**: Use `-{environment}` format? (e.g., `{PROJECT_NAME}-data-dev`)

#### **Lambda (Serverless Compute)**
- [ ] **Will Lambda be used?** (Yes/No)
- [ ] **If YES**: What base name for Lambda resources? (Recommended: `{PROJECT_NAME}-function`)
- [ ] **Environment suffix**: Use `-{environment}` format? (e.g., `{PROJECT_NAME}-function-dev`)

#### **IAM (Identity & Access Management)**
- [ ] **Will IAM be used?** (Yes/No)
- [ ] **If YES**: What base name for IAM resources? (Recommended: `{PROJECT_NAME}-role`)
- [ ] **Environment suffix**: Use `-{environment}` format? (e.g., `{PROJECT_NAME}-role-dev`)

#### **CloudWatch (Monitoring & Logging)**
- [ ] **Will CloudWatch be used?** (Yes/No)
- [ ] **If YES**: What base name for CloudWatch resources? (Recommended: `{PROJECT_NAME}-log`)
- [ ] **Environment suffix**: Use `-{environment}` format? (e.g., `{PROJECT_NAME}-log-dev`)

### 4. **Advanced AWS Services**

#### **Step Functions (Workflow Orchestration)**
- [ ] **Will Step Functions be used?** (Yes/No)
- [ ] **If YES**: What base name for Step Function resources? (Recommended: `{PROJECT_NAME}-workflow`)
- [ ] **Environment suffix**: Use `-{environment}` format?

#### **SQS (Message Queuing)**
- [ ] **Will SQS be used?** (Yes/No)
- [ ] **If YES**: What base name for SQS resources? (Recommended: `{PROJECT_NAME}-queue`)
- [ ] **Environment suffix**: Use `-{environment}` format?

#### **SNS (Notifications)**
- [ ] **Will SNS be used?** (Yes/No)
- [ ] **If YES**: What base name for SNS resources? (Recommended: `{PROJECT_NAME}-notification`)
- [ ] **Environment suffix**: Use `-{environment}` format?

#### **API Gateway (REST/HTTP APIs)**
- [ ] **Will API Gateway be used?** (Yes/No)
- [ ] **If YES**: What base name for API Gateway resources? (Recommended: `{PROJECT_NAME}-api`)
- [ ] **Environment suffix**: Use `-{environment}` format?

#### **VPC/Networking**
- [ ] **Will VPC be used?** (Yes/No)
- [ ] **If YES**: What base name for VPC resources? (Recommended: `{PROJECT_NAME}-vpc`)
- [ ] **Environment suffix**: Use `-{environment}` format?

#### **RDS (Relational Database)**
- [ ] **Will RDS be used?** (Yes/No)
- [ ] **If YES**: What base name for RDS resources? (Recommended: `{PROJECT_NAME}-db`)
- [ ] **Environment suffix**: Use `-{environment}` format?

#### **ElastiCache (Caching)**
- [ ] **Will ElastiCache be used?** (Yes/No)
- [ ] **If YES**: What base name for ElastiCache resources? (Recommended: `{PROJECT_NAME}-cache`)
- [ ] **Environment suffix**: Use `-{environment}` format?

#### **OpenSearch (Search & Analytics)**
- [ ] **Will OpenSearch be used?** (Yes/No)
- [ ] **If YES**: What base name for OpenSearch resources? (Recommended: `{PROJECT_NAME}-search`)
- [ ] **Environment suffix**: Use `-{environment}` format?

### 5. **AI/ML Services**

#### **Bedrock (LLM Integration)**
- [ ] **Will Bedrock be used?** (Yes/No)
- [ ] **If YES**: What base name for Bedrock resources? (Recommended: `{PROJECT_NAME}-ai`)
- [ ] **Environment suffix**: Use `-{environment}` format?
- [ ] **Specific models**: Which Bedrock models will be used?

#### **SageMaker**
- [ ] **Will SageMaker be used?** (Yes/No)
- [ ] **If YES**: What base name for SageMaker resources? (Recommended: `{PROJECT_NAME}-ml`)
- [ ] **Environment suffix**: Use `-{environment}` format?

#### **Comprehend (NLP)**
- [ ] **Will Comprehend be used?** (Yes/No)
- [ ] **If YES**: What base name for Comprehend resources? (Recommended: `{PROJECT_NAME}-nlp`)
- [ ] **Environment suffix**: Use `-{environment}` format?

#### **Rekognition (Computer Vision)**
- [ ] **Will Rekognition be used?** (Yes/No)
- [ ] **If YES**: What base name for Rekognition resources? (Recommended: `{PROJECT_NAME}-vision`)
- [ ] **Environment suffix**: Use `-{environment}` format?

### 6. **Additional AWS Services**
- [ ] **Other services to be used?** (List any additional AWS services)
- [ ] **For each additional service**: Base name and environment suffix preferences

---

## 🔐 **Security & Compliance Questions**

### 7. **Authentication & Authorization**
- [ ] **MFA Requirements**: Will MFA be enforced? (Yes/No)
- [ ] **IAM Policies**: Strict least-privilege or relaxed for development?
- [ ] **Cross-Account Access**: Will resources be shared across AWS accounts?

### 8. **Environment Security**
- [ ] **Security Model**: Progressive hardening (Dev → Staging → Production)?
- [ ] **Public Access**: Any resources need public access?
- [ ] **Encryption**: Default AWS encryption or custom KMS keys?

---

## 🌍 **Environment Configuration Questions**

### 9. **Deployment Stages**
- [ ] **Environments**: Which environments will be supported? (Dev, Staging, Production, etc.)
- [ ] **Account Strategy**: Same account for all environments or separate accounts?
- [ ] **Region Strategy**: Single region or multi-region deployment?

### 10. **Environment-Specific Configurations**
- [ ] **Resource Scaling**: Different resource sizes per environment?
- [ ] **Retention Policies**: Different data retention per environment?
- [ ] **Monitoring**: Different alerting/monitoring per environment?

---

## 🚀 **Development Workflow Questions**

### 11. **Testing Strategy**
- [ ] **Unit Testing**: Will unit tests be implemented?
- [ ] **Integration Testing**: Will integration tests be implemented?
- [ ] **End-to-End Testing**: Will E2E tests be implemented?

### 12. **Deployment Strategy**
- [ ] **CI/CD Pipeline**: Will automated deployment be implemented?
- [ ] **Manual Deployment**: Manual deployment for development?
- [ ] **Rollback Strategy**: Automated rollback capabilities?

### 13. **Monitoring & Observability**
- [ ] **CloudWatch Dashboards**: Custom dashboards needed?
- [ ] **Custom Metrics**: Custom CloudWatch metrics needed?
- [ ] **Log Aggregation**: Centralized logging strategy?
- [ ] **Alerting**: Automated alerting and notifications?

---

## 📊 **Template Configuration Questions**

### 14. **Template Reusability**
- [ ] **Configurable Elements**: What should be easily configurable for future projects?
- [ ] **Documentation**: What documentation should be included for template users?
- [ ] **Examples**: What working examples should be included?

### 15. **Success Criteria**
- [ ] **START Phase Complete**: What defines successful completion of START phase?
- [ ] **Template Ready**: What defines the project as ready for template use?
- [ ] **Next Phase**: What phase should follow START phase completion?

---

## 🔄 **Template Usage Instructions**

### **For Future Projects Using This Template:**

1. **Copy the entire project directory**
2. **Edit `lib/config.py`**:
   - Change `PROJECT_NAME`
   - Update `AWS_ACCOUNTS` if different accounts
3. **Update `package.json`** name field
4. **Run `npm install`** to update package-lock.json
5. **Answer the START phase questions above**
6. **Customize AWS service configurations as needed**
7. **Move to PLAN phase for project-specific requirements**

### **Benefits of This Template:**
- ✅ **Consistent Architecture**: Same CDK structure across projects
- ✅ **Configurable Naming**: Easy resource naming customization
- ✅ **Environment Support**: Multi-stage deployment ready
- ✅ **Service Integration**: Common AWS services pre-configured
- ✅ **Documentation**: Comprehensive project documentation
- ✅ **Memory System**: CursorRIPER framework included

---

*This template ensures that every AWS CDK project starts with the same solid foundation and can be easily customized for different use cases.*