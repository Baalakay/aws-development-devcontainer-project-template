# 🚀 AWS CDK Project Templates

This folder contains all the documentation and tools needed to use this project as a reusable AWS CDK template.

## 📚 **Template Documentation**

### **1. Template Summary (`TEMPLATE_SUMMARY.md`)**
- **Complete overview** of what this template provides
- **Features and benefits** of using this template
- **Use cases and industries** this template solves
- **Template structure** and organization

### **2. Customization Guide (`TEMPLATE_CUSTOMIZATION.md`)**
- **Step-by-step instructions** for customizing the template
- **Advanced customization options** for power users
- **Troubleshooting guide** for common issues
- **Complete file structure** explanation

### **3. Quick Reference (`TEMPLATE_QUICK_REFERENCE.md`)**
- **3-step quick customization** process
- **Resource naming preview** showing what gets renamed
- **Critical rules** that must be followed
- **Essential commands** for verification

## 🛠️ **Template Tools**

### **4. Verification Script (`verify_template.py`)**
- **Automated configuration checking**
- **Resource naming preview**
- **Critical rules verification**
- **Deployment information**

## 🔄 **How to Use This Template**

### **Quick Start:**
1. **Copy this entire project** to a new directory
2. **Edit 2 files**:
   - `lib/config.py` - Change project name and AWS accounts
   - `package.json` - Change project name
3. **Run `npm install`** to update dependencies
4. **Run `python .aws-templates/verify_template.py`** to verify configuration
5. **Deploy with `cdk deploy`**

### **What Gets Renamed Automatically:**
- All AWS resource names follow `{PROJECT_NAME}-{service}-{environment}` pattern
- Lambda functions, S3 buckets, DynamoDB tables, IAM roles, etc.
- No need to manually rename individual resources

## 🎯 **Template Benefits**

- **Skip 2-3 weeks** of infrastructure setup
- **Skip 1-2 weeks** of security configuration  
- **Skip 1 week** of monitoring setup
- **Skip 1 week** of documentation
- **Production-ready** AWS CDK foundation
- **Security-compliant** configurations
- **Multi-environment** deployment ready

## 🚨 **Critical Rules**

- **Bedrock API**: Use `converse()`, NEVER `invoke_model()`
- **Model ID**: `us.anthropic.claude-3-7-sonnet-20250219-v1:0`
- **System Prompts**: Format as `[{"text": "prompt"}]`
- **Naming**: Follow `{PROJECT_NAME}-{service}-{environment}` pattern

---

**🎉 This template is ready to be copied and customized for new AWS CDK projects!**
