# 🚀 Template Customization - Quick Reference

## ⚡ **3-Step Quick Customization**

### **1. Change Project Name**
```bash
# Edit lib/config.py
PROJECT_NAME = "your-new-project-name"

# Edit package.json
"name": "your-new-project-name"

# Update dependencies
npm install
```

### **2. Change AWS Accounts**
```bash
# Edit lib/config.py
AWS_ACCOUNTS = {
    "dev": "YOUR-DEV-ACCOUNT",
    "staging": "YOUR-STAGING-ACCOUNT", 
    "prod": "YOUR-PROD-ACCOUNT"
}
```

### **3. Test Changes**
```bash
# Verify configuration
cat lib/config.py | grep -E "(PROJECT_NAME|AWS_ACCOUNTS)"

# Test CDK synthesis
cdk synth
```

---

## 🔍 **What Gets Renamed Automatically**

| Resource Type | Old Name | New Name |
|---------------|----------|----------|
| S3 Bucket | `incident-extractor-storage-dev` | `your-new-project-storage-dev` |
| DynamoDB Table | `incident-extractor-data-dev` | `your-new-project-data-dev` |
| Lambda Function | `incident-extractor-processor-dev` | `your-new-project-processor-dev` |
| IAM Role | `incident-extractor-lambda-role-dev` | `your-new-project-lambda-role-dev` |
| CloudWatch Logs | `incident-extractor-logs-dev` | `your-new-project-logs-dev` |
| SQS Queue | `incident-extractor-queue-dev` | `your-new-project-queue-dev` |

---

## 📁 **Files You Need to Edit**

- ✅ `lib/config.py` - Project name & AWS accounts
- ✅ `package.json` - Project name
- ❌ `lib/infrastructure_stack.py` - Uses config variables
- ❌ `lib/application_stack.py` - Uses config variables
- ❌ `app.py` - Uses config accounts

---

## 🚨 **Critical Rules to Remember**

- **Bedrock API**: Use `converse()`, NEVER `invoke_model()`
- **Model ID**: `us.anthropic.claude-3-7-sonnet-20250219-v1:0`
- **System Prompts**: Format as `[{"text": "prompt"}]`
- **Naming**: Follow `{PROJECT_NAME}-{service}-{environment}` pattern

---

## 🔄 **Template Reuse Workflow**

1. **Copy** this entire project
2. **Edit** the 2 config files above
3. **Run** `npm install`
4. **Deploy** to your AWS accounts
5. **Customize** business logic as needed

---

**🎯 That's it! Your new project is ready to deploy.**
