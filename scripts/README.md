# Cleanup Scripts for Loss Register Project

This directory contains cleanup scripts that handle retained resources that CDK cannot destroy automatically. These scripts ensure clean deployments by properly cleaning up resources in the correct order.

## 🚨 Important Notes

- **S3 Buckets are PRESERVED by default** for data protection
- **Event source mappings are cleaned up FIRST** to prevent orphaned connections
- **Resources are discovered dynamically** from CloudFormation stack outputs
- **No hard-coded resource names** - everything is discovered automatically

## 📁 Script Files

### 1. `cleanup-application-resources.sh`
**Purpose**: Cleans up application stack resources (Lambda, SQS, Step Functions)

**What it cleans up**:
- Lambda functions
- SQS queues  
- Step Functions
- CloudWatch log groups
- **Event source mappings (CRITICAL - prevents deployment conflicts)**

**When to use**: Before destroying application stack or when you need to clean up application resources

### 2. `cleanup-infrastructure-resources.sh`
**Purpose**: Cleans up infrastructure stack resources (DynamoDB, IAM, CloudWatch)

**What it cleans up**:
- DynamoDB tables
- IAM roles
- CloudWatch log groups
- Custom resource Lambda functions

**What it preserves**:
- S3 buckets (data protection)

**When to use**: After destroying infrastructure stack or when you need to clean up retained resources

### 3. `cleanup-all.sh`
**Purpose**: Runs both cleanup scripts in the correct order

**Execution order**:
1. Application resources cleanup (with event source mapping cleanup)
2. Infrastructure resources cleanup
3. Manual cleanup of any remaining resources

**When to use**: Complete project cleanup or when you want to ensure everything is cleaned up

## 🚀 Usage

### **Primary Method: Automatic Cleanup (Recommended)**

The CDK stacks now include **automatic post-destroy cleanup** that runs every time you use `cdk destroy`:

```bash
# Normal workflow - cleanup happens automatically
cdk destroy  # ✅ Post-destroy Lambda hooks clean up retained resources
cdk deploy   # ✅ Fresh deployment with no conflicts
```

**No manual cleanup needed** - the Lambda functions handle everything automatically!

### **Fallback Method: Manual Cleanup Scripts (Rarely Needed)**

The manual cleanup scripts are provided as a **fallback option** for edge cases:

```bash
# Only needed if CDK destroy fails or cleanup Lambda fails
cdk destroy  # ❌ Fails or cleanup Lambda fails
./scripts/cleanup-all.sh  # 🔧 Manual cleanup as fallback
cdk deploy   # ✅ Fresh deployment
```

### **When Manual Scripts Are Useful:**

1. **CDK destroy fails** and cleanup Lambda doesn't run
2. **Partial deployments** where some resources exist outside CDK
3. **Debugging** resource cleanup issues
4. **Manual resource management** outside of CDK workflow

### **Manual Script Usage (If Needed)**

```bash
# Clean up application resources only
./scripts/cleanup-application-resources.sh

# Clean up infrastructure resources only  
./scripts/cleanup-infrastructure-resources.sh

# Clean up everything (complete fallback)
./scripts/cleanup-all.sh
```

### Environment-Specific Usage

The scripts automatically detect the environment from the CloudFormation stack names:
- **Dev**: `Dev-JlLossRegisterInfrastructureStack` / `Dev-JlLossRegisterApplicationStack`
- **Staging**: `Staging-JlLossRegisterInfrastructureStack` / `Staging-JlLossRegisterApplicationStack`
- **Production**: `Prod-JlLossRegisterInfrastructureStack` / `Prod-JlLossRegisterApplicationStack`

## 🔧 How It Works

### 1. Dynamic Resource Discovery
- Scripts query CloudFormation stack outputs for resource names
- No hard-coded resource names or account IDs
- Environment-specific targeting based on stack names

### 2. Proper Cleanup Order
- **Phase 1**: Event source mappings (Lambda-SQS connections)
- **Phase 2**: Application resources (Lambda, SQS, Step Functions)
- **Phase 3**: Infrastructure resources (DynamoDB, IAM, CloudWatch)
- **Phase 4**: S3 buckets preserved (data protection)

### 3. Safety Features
- Confirmation prompts before deletion
- Resource existence checks before deletion
- Comprehensive error handling and logging
- Graceful failure handling

## 📊 Resource Types and Cleanup Behavior

| Resource Type | Cleanup Script | Action | Reason |
|---------------|----------------|---------|---------|
| **S3 Buckets** | All | ❌ PRESERVED | Data protection |
| **DynamoDB Tables** | Infrastructure | ✅ DELETED | Clean slate |
| **IAM Roles** | Infrastructure | ✅ DELETED | Clean slate |
| **Lambda Functions** | Application | ✅ DELETED | Clean slate |
| **SQS Queues** | Application | ✅ DELETED | Clean slate |
| **Step Functions** | Application | ✅ DELETED | Clean slate |
| **CloudWatch Logs** | Both | ✅ DELETED | Clean slate |
| **Event Source Mappings** | Application | ✅ DELETED | Prevent conflicts |

## 🚨 Critical Cleanup Order

**Event source mappings MUST be cleaned up FIRST** because:

1. **Lambda SQS connections are NOT automatically removed** when Lambda functions are deleted
2. **Orphaned mappings can cause deployment issues** and errors
3. **Manual cleanup required** to prevent resource conflicts
4. **Deployment failures** can occur if mappings remain

## 🔍 Troubleshooting

### Common Issues

1. **"Stack does not exist" error**
   - Run `./scripts/cleanup-all.sh` for manual cleanup of any remaining resources

2. **Permission denied errors**
   - Ensure AWS CLI is configured with appropriate permissions
   - Check IAM user/role permissions

3. **Resources not found**
   - Resources may have already been cleaned up
   - Check CloudFormation console for stack status

### Debug Mode

Add `set -x` at the top of any script to enable debug output:

```bash
#!/bin/bash
set -x  # Enable debug mode
# ... rest of script
```

## 📝 Logging

All scripts provide detailed logging:
- Resource discovery process
- Deletion operations
- Success/failure status
- Summary of operations performed

## 🎯 Best Practices

1. **Use `cdk destroy` as primary method** - cleanup happens automatically via Lambda hooks
2. **Manual cleanup scripts are fallback only** - rarely needed in normal operation
3. **Preserve S3 buckets** unless data deletion is explicitly required
4. **Test the full deploy → destroy → deploy cycle** to ensure automatic cleanup works
5. **Monitor CloudFormation console** during operations to verify cleanup success

## 🔄 CDK Post-Destroy Integration

The CDK stacks now include post-destroy cleanup Lambda functions that automatically run during `cdk destroy`. This provides:

- **Fully automated cleanup** - No manual script execution needed
- **Proper ordering** - Cleanup happens after CDK destroy completes
- **Error handling** - CDK manages cleanup failures gracefully
- **Atomic operations** - Either everything succeeds or everything rolls back

## 📚 Related Documentation

- [CDK Infrastructure Stack](../lib/infrastructure_stack.py)
- [CDK Application Stack](../lib/application_stack.py)
- [Post-Destroy Cleanup Lambda](../lambdas/post_destroy_cleanup/)
- [Project README](../README.md)
