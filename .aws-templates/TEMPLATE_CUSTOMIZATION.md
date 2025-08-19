# 🚀 AWS CDK Project Template - Customization Guide

## 📋 **Quick Start Customization**

This guide shows you how to customize this AWS CDK project template for your own projects. The template is designed so you only need to change **2 files** to rename the entire project and update AWS accounts.

---

## 🔧 **Step 1: Change Project Name (Required)**

### **File to Edit**: `lib/config.py`

**Change this line:**
```python
PROJECT_NAME = "incident-extractor"  # ← Change this value
```

**To your project name:**
```python
PROJECT_NAME = "your-new-project-name"  # ← Your new project name here
```

**What this affects:**
- All AWS resource names
- Lambda function names
- S3 bucket names
- DynamoDB table names
- IAM role names
- CloudWatch log group names
- SQS queue names

**Example transformation:**
- `incident-extractor-storage-dev` → `your-new-project-storage-dev`
- `incident-extractor-data-dev` → `your-new-project-data-dev`
- `incident-extractor-processor-dev` → `your-new-project-processor-dev`

---

## 🌍 **Step 2: Update AWS Account IDs (Required)**

### **File to Edit**: `lib/config.py`

**Change this section:**
```python
AWS_ACCOUNTS = {
    "dev": "750389970429",      # ← Change to your dev account
    "staging": "750389970429",  # ← Change to your staging account
    "prod": ""                  # ← Change to your prod account
}
```

**To your AWS accounts:**
```python
AWS_ACCOUNTS = {
    "dev": "123456789012",      # ← Your dev account ID
    "staging": "123456789012",  # ← Your staging account ID
    "prod": "987654321098"      # ← Your production account ID
}
```

**What this affects:**
- CDK deployment targets
- Cross-account permissions (if configured)
- Resource ownership

---

## 📦 **Step 3: Update Package Configuration (Required)**

### **File to Edit**: `package.json`

**Change this line:**
```json
{
  "name": "incident-extractor",  // ← Change this value
  "dependencies": {
    "aws-cdk": "^2.1024.0"
  }
}
```

**To your project name:**
```json
{
  "name": "your-new-project",   // ← Your new project name here
  "dependencies": {
    "aws-cdk": "^2.1024.0"
  }
}
```

**After editing, run:**
```bash
npm install
```

**What this affects:**
- Package management
- CDK context
- Project identification

---

## 🔍 **Step 4: Verify Your Changes**

### **Check Configuration**
```bash
# Verify config.py changes
cat lib/config.py | grep -E "(PROJECT_NAME|AWS_ACCOUNTS)"

# Verify package.json changes
cat package.json | grep "name"
```

### **Expected Output:**
```bash
PROJECT_NAME = "your-new-project"
AWS_ACCOUNTS = {
    "dev": "123456789012",
    "staging": "123456789012",
    "prod": "987654321098"
}

"name": "your-new-project"
```

---

## 🚀 **Step 5: Test Your Customization**

### **Synthesize CDK Stacks**
```bash
# Install dependencies
pip install -r requirements.txt

# Synthesize stacks to verify naming
cdk synth
```

### **Expected Results:**
- All resource names should now use your new project name
- No errors related to invalid account IDs
- CloudFormation templates generated successfully

---

## 🎯 **Advanced Customization Options**

### **Option A: Change Environment Names**

**File**: `lib/config.py`

**Current:**
```python
ENVIRONMENT_CONFIGS = {
    'dev': { ... },
    'staging': { ... },
    'prod': { ... }
}
```

**Customize to:**
```python
ENVIRONMENT_CONFIGS = {
    'development': { ... },    # ← Changed from 'dev'
    'testing': { ... },        # ← Changed from 'staging'
    'production': { ... }      # ← Changed from 'prod'
}
```

**Note**: You'll also need to update `app.py` to match new environment names.

### **Option B: Add New AWS Services**

**File**: `lib/infrastructure_stack.py`

**Add new services following the pattern:**
```python
# Example: Add RDS Database
self.database = rds.DatabaseInstance(
    self, "Database",
    instance_identifier=f"{base_name}-db{env_suffix}",
    # ... other configuration
)
```

**Don't forget to:**
1. Add import: `from aws_cdk import aws_rds as rds`
2. Add to CloudWatch outputs
3. Update IAM permissions if needed

### **Option C: Modify Resource Configurations**

**File**: `lib/config.py`

**Add new configuration options:**
```python
ENVIRONMENT_CONFIGS = {
    'dev': {
        'retention_days': 7,
        'public_access_blocked': False,
        'timeout_seconds': 30,
        'memory_size': 256,
        'max_receive_count': 1,
        'database_size': 'db.t3.micro',        # ← New option
        'enable_backup': False                 # ← New option
    },
    # ... other environments
}
```

---

## 📁 **File Structure After Customization**

```
your-new-project/
├── lib/
│   ├── config.py              # ← Your project name & accounts
│   ├── infrastructure_stack.py # ← Uses config variables
│   └── application_stack.py   # ← Uses config variables
├── lambdas/
│   └── processor/
│       └── index.py           # ← Your business logic
├── lambda-layers/
│   └── bedrock-service/       # ← AI/ML integration
├── package.json               # ← Your project name
├── requirements.txt           # ← Python dependencies
├── cdk.json                  # ← CDK configuration
├── app.py                    # ← Uses config accounts
└── README.md                 # ← Update with your project details
```

---

## ⚠️ **Important Notes**

### **What NOT to Change:**
- **CDK version** in `requirements.txt` (unless you know what you're doing)
- **Stack structure** in `lib/stages.py` (unless you understand CDK stages)
- **Resource types** (unless you're adding new services)

### **What You CAN Change:**
- Project names and resource naming patterns
- AWS account IDs and regions
- Environment configurations and settings
- Resource sizes and configurations
- Business logic in Lambda functions

---

## 🔄 **Template Reuse Workflow**

### **For Each New Project:**

1. **Copy this template** to a new directory
2. **Edit `lib/config.py`**:
   - Change `PROJECT_NAME`
   - Update `AWS_ACCOUNTS`
3. **Edit `package.json`**:
   - Change project name
   - Run `npm install`
4. **Customize resources** as needed
5. **Deploy to your AWS accounts**

### **Benefits:**
- 🚀 **Skip Infrastructure Setup**: All AWS resources pre-configured
- 🏗️ **Consistent Architecture**: Same CDK structure across projects
- 🔧 **Easy Customization**: Change names and accounts in one place
- 📚 **Complete Documentation**: Full project documentation included
- 🛡️ **Security Best Practices**: Pre-configured security policies

---

## 🆘 **Troubleshooting**

### **Common Issues:**

**Issue**: CDK synthesis fails with naming errors
**Solution**: Check that `PROJECT_NAME` in `config.py` doesn't contain invalid characters

**Issue**: Deployment fails with account errors
**Solution**: Verify `AWS_ACCOUNTS` in `config.py` contains valid account IDs

**Issue**: Resources not renamed properly
**Solution**: Ensure you ran `npm install` after updating `package.json`

**Issue**: Import errors in Python
**Solution**: Check that `requirements.txt` dependencies are installed

---

## 📞 **Need Help?**

### **Template Features:**
- **Multi-environment support**: Dev, Staging, Production
- **Security-first design**: Progressive security hardening
- **Monitoring ready**: CloudWatch integration
- **AI/ML integration**: Bedrock service layer
- **Event-driven architecture**: S3 → Lambda → DynamoDB → SQS

### **Included Services:**
- **S3**: Object storage with lifecycle policies
- **DynamoDB**: NoSQL database with TTL
- **Lambda**: Serverless compute functions
- **SQS**: Message queuing
- **IAM**: Identity and access management
- **CloudWatch**: Logging and monitoring
- **Parameter Store**: Configuration management
- **Bedrock**: AI/ML integration

---

**🎉 Congratulations! You now have a fully customizable AWS CDK project template that can be reused for any project requiring these AWS services.**
