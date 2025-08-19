#!/bin/bash
# Unified Cleanup Script for Loss Register Project
# Single script that handles all cleanup operations with flags
# This script does NOT handle resource cleanup directly - it delegates to individual functions

set -e

# Configuration
BASE_NAME="jl-bat-loss-register"
REGION="us-east-1"

# Environment (will be set by command line argument)
ENVIRONMENT=""

# CDK Stack Names (derived from configuration)
INFRASTRUCTURE_STACK_NAME=""
APPLICATION_STACK_NAME=""

# CDK Resource Patterns (hard-coded patterns we know work)
CDK_INFRA_PATTERN=""

# Parse command line arguments
CLEANUP_MODE=""
ENVIRONMENT=""
DELETE_S3_BUCKETS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dev)
            if [ -z "$ENVIRONMENT" ]; then
                ENVIRONMENT="dev"
            else
                echo "ERROR: Only one environment allowed (--dev, --staging, --integration, --test, or --innovative)"
                exit 1
            fi
            shift
            ;;
        --staging)
            if [ -z "$ENVIRONMENT" ]; then
                ENVIRONMENT="staging"
            else
                echo "ERROR: Only one environment allowed (--dev, --staging, --integration, --test, or --innovative)"
                exit 1
            fi
            shift
            ;;
        --integration)
            if [ -z "$ENVIRONMENT" ]; then
                ENVIRONMENT="integration"
            else
                echo "ERROR: Only one environment allowed (--dev, --staging, --integration, --test, or --innovative)"
                exit 1
            fi
            shift
            ;;
        --test)
            if [ -z "$ENVIRONMENT" ]; then
                ENVIRONMENT="test"
            else
                echo "ERROR: Only one environment allowed (--dev, --staging, --integration, --test, or --innovative)"
                exit 1
            fi
            shift
            ;;
        --innovative)
            if [ -z "$ENVIRONMENT" ]; then
                ENVIRONMENT="innovative"
            else
                echo "ERROR: Only one environment allowed (--dev, --staging, --integration, --test, or --innovative)"
                exit 1
            fi
            shift
            ;;
        --infra)
            if [ -z "$CLEANUP_MODE" ]; then
                CLEANUP_MODE="infra"
            else
                echo "ERROR: Only one cleanup mode allowed (--infra, --app, or --all)"
                exit 1
            fi
            shift
            ;;
        --app)
            if [ -z "$CLEANUP_MODE" ]; then
                CLEANUP_MODE="app"
            else
                echo "ERROR: Only one cleanup mode allowed (--infra, --app, or --all)"
                exit 1
            fi
            shift
            ;;
        --all)
            if [ -z "$CLEANUP_MODE" ]; then
                CLEANUP_MODE="all"
            else
                echo "ERROR: Only one cleanup mode allowed (--infra, --app, or --all)"
                exit 1
            fi
            shift
            ;;
        --delete-s3-buckets)
            DELETE_S3_BUCKETS=true
            shift
            ;;
        *)
            echo "ERROR: Unknown option: $1"
            echo "Usage: $0 [--dev|--staging|--integration|--test|--innovative] [--infra|--app|--all] [--delete-s3-buckets]"
            echo ""
            echo "Required (one of each):"
            echo "  Environment (one only):"
            echo "    --dev              Development environment"
            echo "    --staging          Staging environment"
            echo "    --integration      Integration environment"
            echo "    --test             Test environment"
            echo "    --innovative       Innovative environment"
            echo ""
            echo "  Cleanup Mode (one only):"
            echo "    --infra            Clean up infrastructure resources only"
            echo "    --app              Clean up application resources only"
            echo "    --all              Clean up both (infrastructure first, then application)"
            echo ""
            echo "Optional:"
            echo "  --delete-s3-buckets  Delete S3 buckets instead of preserving them"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [ -z "$ENVIRONMENT" ]; then
    echo "ERROR: Must specify one environment: --dev, --staging, --integration, --test, or --innovative"
    echo "Usage: $0 [--dev|--staging|--integration|--test|--innovative] [--infra|--app|--all] [--delete-s3-buckets]"
    exit 1
fi

if [ -z "$CLEANUP_MODE" ]; then
    echo "ERROR: Must specify one cleanup mode: --infra, --app, or --all"
    echo "Usage: $0 [--dev|--staging|--integration|--test|--innovative] [--infra|--app|--all] [--delete-s3-buckets]"
    exit 1
fi

# Set CDK stack names and patterns based on environment
# These names must match the construct IDs in lib/stages.py
case $ENVIRONMENT in
    "dev")
        INFRASTRUCTURE_STACK_NAME="Dev-JlLossRegisterInfrastructureStack"
        APPLICATION_STACK_NAME="Dev-JlLossRegisterApplicationStack"
        CDK_INFRA_PATTERN="Dev-JlLossRegisterInfrast-"
        ;;
    "staging")
        INFRASTRUCTURE_STACK_NAME="Staging-JlLossRegisterInfrastructureStack"
        APPLICATION_STACK_NAME="Staging-JlLossRegisterApplicationStack"
        CDK_INFRA_PATTERN="Staging-JlLossRegisterInfrast-"
        ;;
    "integration")
        INFRASTRUCTURE_STACK_NAME="Integration-JlLossRegisterInfrastructureStack"
        APPLICATION_STACK_NAME="Integration-JlLossRegisterApplicationStack"
        CDK_INFRA_PATTERN="Integration-JlLossRegisterInfrast-"
        ;;
    "test")
        INFRASTRUCTURE_STACK_NAME="Test-JlLossRegisterInfrastructureStack"
        APPLICATION_STACK_NAME="Test-JlLossRegisterApplicationStack"
        CDK_INFRA_PATTERN="Test-JlLossRegisterInfrast-"
        ;;
    "innovative")
        INFRASTRUCTURE_STACK_NAME="Innovative-JlLossRegisterInfrastructureStack"
        APPLICATION_STACK_NAME="Innovative-JlLossRegisterApplicationStack"
        CDK_INFRA_PATTERN="Innovative-JlLossRegisterInfrast-"
        ;;
    *)
        echo "ERROR: Invalid environment: $ENVIRONMENT"
        exit 1
        ;;
esac

echo "Unified Cleanup Script for ${BASE_NAME}-${ENVIRONMENT}"
echo "========================================================"
echo "Cleanup Mode: $CLEANUP_MODE"
if [ "$DELETE_S3_BUCKETS" = true ]; then
    echo "S3 Buckets: Will be DELETED (--delete-s3-buckets flag provided)"
else
    echo "S3 Buckets: Will be preserved (data protection)"
fi
echo ""

# Function to check if infrastructure stack exists
check_infrastructure_stack() {
    echo "Checking if infrastructure stack exists..."
    
    # Check if stack exists and get its status
    local stack_status
    stack_status=$(aws cloudformation describe-stacks --stack-name "$INFRASTRUCTURE_STACK_NAME" --query "Stacks[0].StackStatus" --output text 2>/dev/null || echo "DOES_NOT_EXIST")
    
    if [ "$stack_status" != "DOES_NOT_EXIST" ] && [ "$stack_status" != "DELETE_COMPLETE" ]; then
        echo "ERROR: Infrastructure stack '$INFRASTRUCTURE_STACK_NAME' still exists with status: $stack_status"
        echo "This script is for POST-DESTROY cleanup only."
        echo "Please run 'cdk destroy $INFRASTRUCTURE_STACK_NAME' first."
        return 1
    else
        echo "Infrastructure stack does not exist or is fully deleted - safe to proceed with cleanup"
        return 0
    fi
}

# Function to check if application stack exists
check_application_stack() {
    echo "Checking if application stack exists..."
    
    # Check if stack exists and get its status
    local stack_status
    stack_status=$(aws cloudformation describe-stacks --stack-name "$APPLICATION_STACK_NAME" --query "Stacks[0].StackStatus" --output text 2>/dev/null || echo "DOES_NOT_EXIST")
    
    if [ "$stack_status" != "DOES_NOT_EXIST" ] && [ "$stack_status" != "DELETE_COMPLETE" ]; then
        echo "ERROR: Application stack '$APPLICATION_STACK_NAME' still exists with status: $stack_status"
        echo "This script is for POST-DESTROY cleanup only."
        echo "Please run 'cdk destroy $APPLICATION_STACK_NAME' first."
        return 1
    else
        echo "Application stack does not exist or is fully deleted - safe to proceed with cleanup"
        return 0
    fi
}

# Function to cleanup infrastructure resources
cleanup_infrastructure_resources() {
    echo "Phase 1: Cleaning up infrastructure resources..."
    echo "======================================================="
    
    echo "Searching for infrastructure resources with pattern: $BASE_NAME-$ENVIRONMENT"
    
    echo ""
    echo "Phase 2: Cleaning up DynamoDB tables..."
    local dynamodb_tables
    # Get all tables and filter for project-specific ones
    echo "DEBUG: Searching for tables with pattern: $BASE_NAME-{*}-$ENVIRONMENT"
    # Use a more specific pattern to avoid matching other environments
    # The pattern should match: jl-bat-loss-register-*-dev (where * is any suffix)
    dynamodb_tables=$(aws dynamodb list-tables --query "TableNames[]" --output text 2>/dev/null | tr -s '[:space:]' '\n' | grep "$BASE_NAME.*-$ENVIRONMENT$" || echo "")
    echo "DEBUG: Found tables: '$dynamodb_tables'"
    
    if [ ! -z "$dynamodb_tables" ] && [ "$dynamodb_tables" != "None" ]; then
        echo "  Found DynamoDB tables to clean up:"
        echo "$dynamodb_tables" | while read -r table_name; do
            if [ ! -z "$table_name" ] && [ "$table_name" != "None" ]; then
                echo "  Removing DynamoDB table: $table_name"
                if aws dynamodb delete-table --table-name "$table_name" >/dev/null 2>&1; then
                    echo "    DynamoDB table deleted: $table_name"
                    echo "    Waiting for table deletion to complete..."
                    aws dynamodb wait table-not-exists --table-name "$table_name" >/dev/null 2>&1
                    echo "    Table deletion confirmed"
                else
                    echo "    Failed to delete DynamoDB table: $table_name"
                fi
            fi
        done
    else
        echo "  No DynamoDB tables to clean up"
    fi
    
    echo ""
    echo "Phase 3: Cleaning up IAM roles..."
    local iam_roles
    # EXACT match only - only roles defined in the infrastructure stack
    iam_roles=$(aws iam list-roles --query "Roles[?starts_with(RoleName, '$BASE_NAME-$ENVIRONMENT')].RoleName" --output text 2>/dev/null || echo "")
    
    if [ ! -z "$iam_roles" ] && [ "$iam_roles" != "None" ]; then
        echo "$iam_roles" | while read -r role_name; do
            if [ ! -z "$role_name" ] && [ "$role_name" != "None" ]; then
                echo "  Removing IAM role: $role_name"
                # Detach managed policies first
                aws iam list-attached-role-policies --role-name "$role_name" --query 'AttachedPolicies[].PolicyArn' --output text 2>/dev/null | while read policy_arn; do
                    if [ ! -z "$policy_arn" ] && [ "$policy_arn" != "None" ]; then
                        aws iam detach-role-policy --role-name "$role_name" --policy-arn "$policy_arn" >/dev/null 2>&1 || true
                    fi
                done
                # Delete inline policies
                aws iam list-role-policies --role-name "$role_name" --query 'PolicyNames[]' --output text 2>/dev/null | while read policy_name; do
                    if [ ! -z "$policy_name" ] && [ "$policy_name" != "None" ]; then
                        aws iam delete-role-policy --role-name "$role_name" --policy-name "$policy_name" >/dev/null 2>&1 || true
                    fi
                done
                # Delete the role
                aws iam delete-role --role-name "$role_name" >/dev/null 2>&1
                echo "    IAM role deleted: $role_name"
            fi
        done
    else
        echo "  No IAM roles to clean up"
    fi
    
    echo ""
    if [ "$DELETE_S3_BUCKETS" = true ]; then
        echo "Phase 4: Deleting S3 buckets..."
        local s3_buckets
        local delete_errors=0
        # Get all buckets and filter for project-specific ones
        s3_buckets=$(aws s3 ls --output text 2>/dev/null | tr -s '[:space:]' '\n' | grep "$BASE_NAME-$ENVIRONMENT" || echo "")
        
        if [ ! -z "$s3_buckets" ] && [ "$s3_buckets" != "None" ]; then
            echo "  Found S3 buckets to delete:"
            while read -r bucket_name; do
                if [ ! -z "$bucket_name" ] && [ "$bucket_name" != "None" ]; then
                                    echo "  Deleting S3 bucket: $bucket_name"
                echo "    Checking if bucket is versioned..."
                
                # Check if bucket has versioned objects and delete them first
                if aws s3api list-object-versions --bucket "$bucket_name" --query "length(Versions)" --output text 2>/dev/null | grep -q -v "^0$"; then
                    echo "    Bucket has versioned objects - removing all versions first..."
                    if aws s3api delete-objects --bucket "$bucket_name" --delete "$(aws s3api list-object-versions --bucket "$bucket_name" --output json --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}')" >/dev/null 2>&1; then
                        echo "    Versioned objects removed"
                    else
                        echo "    Failed to remove versioned objects"
                    fi
                fi
                
                # Check if bucket has delete markers and remove them
                if aws s3api list-object-versions --bucket "$bucket_name" --query "length(DeleteMarkers)" --output text 2>/dev/null | grep -q -v "^0$"; then
                    echo "    Bucket has delete markers - removing them first..."
                    if aws s3api delete-objects --bucket "$bucket_name" --delete "$(aws s3api list-object-versions --bucket "$bucket_name" --output json --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}')" >/dev/null 2>&1; then
                        echo "    Delete markers removed"
                    else
                        echo "    Failed to remove delete markers"
                    fi
                fi
                
                # Now try to delete the bucket
                if aws s3 rb "s3://$bucket_name" --force >/dev/null 2>&1; then
                    echo "    S3 bucket deleted: $bucket_name"
                else
                    echo "    Failed to delete S3 bucket: $bucket_name"
                    delete_errors=$((delete_errors + 1))
                fi
                fi
            done <<< "$s3_buckets"
            
            if [ $delete_errors -gt 0 ]; then
                echo "  WARNING: $delete_errors S3 bucket(s) failed to delete"
                return 1
            fi
        else
            echo "  No S3 buckets found"
        fi
    else
        echo "Phase 4: Preserving S3 buckets (data protection)..."
        local s3_buckets
        # Get all buckets and filter for project-specific ones
        s3_buckets=$(aws s3 ls --output text 2>/dev/null | tr -s '[:space:]' '\n' | grep "$BASE_NAME-$ENVIRONMENT" || echo "")
        
        if [ ! -z "$s3_buckets" ] && [ "$s3_buckets" != "None" ]; then
            echo "  Found S3 buckets to preserve:"
            echo "$s3_buckets" | while read -r bucket_name; do
                if [ ! -z "$bucket_name" ] && [ "$bucket_name" != "None" ]; then
                    echo "  Preserving S3 bucket: $bucket_name"
                fi
            done
        else
            echo "  No S3 buckets found"
        fi
        echo "  Use --delete-s3-buckets flag to delete S3 buckets"
    fi
    
    echo ""
    echo "Phase 5: Cleaning up CloudWatch log groups..."
    # EXACT match for project resources only
    local cloudwatch_log_groups
    cloudwatch_log_groups=$(aws logs describe-log-groups --query "logGroups[?starts_with(logGroupName, '/aws/lambda/$BASE_NAME-$ENVIRONMENT')].logGroupName" --output text 2>/dev/null || echo "")
    
    if [ ! -z "$cloudwatch_log_groups" ] && [ "$cloudwatch_log_groups" != "None" ]; then
        echo "  Found CloudWatch log groups to clean up:"
        local log_delete_errors=0
        # Handle tab/space-separated names by converting to newlines first
        while read -r log_group_name; do
            if [ ! -z "$log_group_name" ] && [ "$log_group_name" != "None" ]; then
                echo "  Removing CloudWatch log group: $log_group_name"
                if aws logs delete-log-group --log-group-name "$log_group_name" >/dev/null 2>&1; then
                    echo "    CloudWatch log group deleted: $log_group_name"
                else
                    echo "    Failed to delete CloudWatch log group: $log_group_name"
                    log_delete_errors=$((log_delete_errors + 1))
                fi
            fi
        done <<< "$(echo "$cloudwatch_log_groups" | tr -s '[:space:]' '\n')"
        
        if [ $log_delete_errors -gt 0 ]; then
            echo "  WARNING: $log_delete_errors CloudWatch log group(s) failed to delete"
        fi
    else
        echo "  No CloudWatch log groups to clean up"
    fi
    
    echo ""
    echo "Phase 6: Cleaning up CDK default created resources..."
    echo "  Searching for CDK auto-generated resources with pattern: ${CDK_INFRA_PATTERN}*"
    
    # Clean up CDK default created Lambda functions
    local cdk_lambda_functions
    cdk_lambda_functions=$(aws lambda list-functions --query "Functions[?contains(FunctionName, '$CDK_INFRA_PATTERN')].FunctionName" --output text 2>/dev/null || echo "")
    
    if [ ! -z "$cdk_lambda_functions" ] && [ "$cdk_lambda_functions" != "None" ]; then
        echo "  Found CDK Lambda functions to clean up:"
        local lambda_delete_errors=0
        while read -r function_name; do
            if [ ! -z "$function_name" ] && [ "$function_name" != "None" ]; then
                echo "  Removing CDK Lambda function: $function_name"
                if aws lambda delete-function --function-name "$function_name" >/dev/null 2>&1; then
                    echo "    CDK Lambda function deleted: $function_name"
                else
                    echo "    Failed to delete CDK Lambda function: $function_name"
                    lambda_delete_errors=$((lambda_delete_errors + 1))
                fi
            fi
        done <<< "$cdk_lambda_functions"
        
        if [ $lambda_delete_errors -gt 0 ]; then
            echo "  WARNING: $lambda_delete_errors CDK Lambda function(s) failed to delete"
        fi
    else
        echo "  No CDK Lambda functions found"
    fi
    
    # Clean up CDK default created CloudWatch log groups
    local cdk_log_groups
    cdk_log_groups=$(aws logs describe-log-groups --query "logGroups[?contains(logGroupName, '$CDK_INFRA_PATTERN')].logGroupName" --output text 2>/dev/null || echo "")
    
    if [ ! -z "$cdk_log_groups" ] && [ "$cdk_log_groups" != "None" ]; then
        echo "  Found CDK CloudWatch log groups to clean up:"
        local cdk_log_delete_errors=0
        # Handle tab/space-separated names by converting to newlines first
        while read -r log_group_name; do
            if [ ! -z "$log_group_name" ] && [ "$log_group_name" != "None" ]; then
                echo "  Removing CDK log group: $log_group_name"
                if aws logs delete-log-group --log-group-name "$log_group_name" >/dev/null 2>&1; then
                    echo "    CDK log group deleted: $log_group_name"
                else
                    echo "    Failed to delete CDK log group: $log_group_name"
                    cdk_log_delete_errors=$((cdk_log_delete_errors + 1))
                fi
            fi
        done <<< "$(echo "$cdk_log_groups" | tr -s '[:space:]' '\n')"
        
        if [ $cdk_log_delete_errors -gt 0 ]; then
            echo "  WARNING: $cdk_log_delete_errors CDK log group(s) failed to delete"
        fi
    else
        echo "  No CDK CloudWatch log groups found"
    fi
    
    # Clean up CDK default created IAM roles
    local cdk_iam_roles
    cdk_iam_roles=$(aws iam list-roles --query "Roles[?contains(RoleName, '$CDK_INFRA_PATTERN')].RoleName" --output text 2>/dev/null || echo "")
    
    if [ ! -z "$cdk_iam_roles" ] && [ "$cdk_iam_roles" != "None" ]; then
        echo "  Found CDK IAM roles to clean up:"
        echo "$cdk_iam_roles" | while read -r role_name; do
            if [ ! -z "$role_name" ] && [ "$role_name" != "None" ]; then
                echo "  Removing CDK IAM role: $role_name"
                # Detach policies first
                aws iam list-attached-role-policies --role-name "$role_name" --query 'AttachedPolicies[].PolicyArn' --output text 2>/dev/null | while read policy_arn; do
                    if [ ! -z "$policy_arn" ] && [ "$policy_arn" != "None" ]; then
                        aws iam detach-role-policy --role-name "$role_name" --policy-arn "$policy_arn" >/dev/null 2>&1 || true
                    fi
                done
                # Delete inline policies
                aws iam list-role-policies --role-name "$role_name" --query 'PolicyNames[]' --output text 2>/dev/null | while read policy_name; do
                    if [ ! -z "$policy_name" ] && [ "$policy_name" != "None" ]; then
                        aws iam delete-role-policy --role-name "$role_name" --policy-name "$policy_name" >/dev/null 2>&1 || true
                    fi
                done
                # Delete the role
                if aws iam delete-role --role-name "$role_name" >/dev/null 2>&1; then
                    echo "    CDK IAM role deleted: $role_name"
                else
                    echo "    Failed to delete CDK IAM role: $role_name"
                fi
            fi
        done
    else
        echo "  No CDK IAM roles found"
    fi
    
    echo ""
    echo "Infrastructure cleanup completed successfully!"
}

# Function to cleanup application resources
cleanup_application_resources() {
    echo "Phase 1: Cleaning up application resources..."
    echo "=================================================="
    
    echo "Searching for application resources with pattern: $BASE_NAME-$ENVIRONMENT"
    
    echo ""
    echo "Phase 2: Cleaning up event source mappings (Lambda-SQS connections)..."
    local mappings_removed=0
    
    echo "  Searching for event source mappings..."
    
    # Find all event source mappings for our Lambda functions
    local response
    response=$(aws lambda list-event-source-mappings --output json 2>/dev/null || echo '{"EventSourceMappings": []}')
    
    # EXACT match only - only mappings for project Lambda functions
    echo "$response" | jq -r '.EventSourceMappings[] | select(.FunctionName | starts_with("'$BASE_NAME'-'$ENVIRONMENT'")) | .UUID' 2>/dev/null | while read -r uuid; do
        if [ ! -z "$uuid" ]; then
            echo "  Removing event source mapping: $uuid"
            if aws lambda delete-event-source-mapping --uuid "$uuid" >/dev/null 2>&1; then
                echo "    Event source mapping removed: $uuid"
                ((mappings_removed++))
            else
                echo "    Failed to remove event source mapping: $uuid"
            fi
        fi
    done
    
    echo "  Removed $mappings_removed event source mappings"
    echo ""
    
    echo "Phase 3: Cleaning up S3 event triggers..."
    local triggers_removed=0
    
    echo "  Searching for S3 event triggers..."
    
    # Get S3 bucket name from environment
    local bucket_name="${BASE_NAME}-${ENVIRONMENT}"
    
    # Check if bucket exists
    if aws s3api head-bucket --bucket "$bucket_name" >/dev/null 2>&1; then
        echo "  Checking S3 event notifications for bucket: $bucket_name"
        
        # Get current notification configuration
        local notification_config
        notification_config=$(aws s3api get-bucket-notification-configuration --bucket "$bucket_name" 2>/dev/null || echo '{}')
        
        # Check if there are Lambda function notifications
        local lambda_notifications
        lambda_notifications=$(echo "$notification_config" | jq -r '.LambdaConfigurations[]?.Id // empty' 2>/dev/null || echo "")
        
        if [ ! -z "$lambda_notifications" ]; then
            echo "  Removing S3 event notifications..."
            # Remove all event notifications by setting empty configuration
            aws s3api put-bucket-notification-configuration --bucket "$bucket_name" --notification-configuration '{}' >/dev/null 2>&1
            echo "    S3 event notifications removed from bucket: $bucket_name"
            ((triggers_removed++))
        else
            echo "  No S3 event notifications found"
        fi
    else
        echo "  S3 bucket does not exist: $bucket_name"
    fi
    
    echo "  Removed $triggers_removed S3 event triggers"
    echo ""
    
    echo "Phase 4: Cleaning up Lambda functions..."
    local lambda_functions
    # EXACT match only - only functions defined in the application stack
    lambda_functions=$(aws lambda list-functions --query "Functions[?starts_with(FunctionName, '$BASE_NAME-$ENVIRONMENT')].FunctionName" --output text 2>/dev/null || echo "")
    
    if [ ! -z "$lambda_functions" ] && [ "$lambda_functions" != "None" ]; then
        echo "$lambda_functions" | while read -r function_name; do
            if [ ! -z "$function_name" ] && [ "$function_name" != "None" ]; then
                echo "  Removing Lambda function: $function_name"
                aws lambda delete-function --function-name "$function_name" >/dev/null 2>&1
                echo "    Lambda function deleted: $function_name"
            fi
        done
    else
        echo "  No Lambda functions to clean up"
    fi
    
    echo ""
    echo "Phase 5: Cleaning up SQS queues..."
    local sqs_queues
    # EXACT match only - only queues defined in the application stack
    sqs_queues=$(aws sqs list-queues --query "QueueUrls[?contains(@, '$BASE_NAME-$ENVIRONMENT')]" --output text 2>/dev/null || echo "")
    
    if [ ! -z "$sqs_queues" ] && [ "$sqs_queues" != "None" ]; then
        echo "$sqs_queues" | while read -r queue_url; do
            if [ ! -z "$queue_url" ] && [ "$queue_url" != "None" ]; then
                local queue_name
                queue_name=$(echo "$queue_url" | sed 's/.*\///')
                echo "  Removing SQS queue: $queue_name"
                aws sqs delete-queue --queue-url "$queue_url" >/dev/null 2>&1
                echo "    SQS queue deleted: $queue_name"
            fi
        done
    else
        echo "  No SQS queues to clean up"
    fi
    
    echo ""
    echo "Phase 6: Cleaning up Step Functions..."
    local step_functions
    # EXACT match only - only step functions defined in the application stack
    step_functions=$(aws stepfunctions list-state-machines --query "stateMachines[?starts_with(name, '$BASE_NAME-$ENVIRONMENT')].stateMachineArn" --output text 2>/dev/null || echo "")
    
    if [ ! -z "$step_functions" ] && [ "$step_functions" != "None" ]; then
        echo "$step_functions" | while read -r state_machine_arn; do
            if [ ! -z "$state_machine_arn" ] && [ "$state_machine_arn" != "None" ]; then
                echo "  Removing Step Function: $state_machine_arn"
                aws stepfunctions delete-state-machine --state-machine-arn "$state_machine_arn" >/dev/null 2>&1
                echo "    Step Function deleted: $state_machine_arn"
            fi
        done
    else
        echo "  No Step Functions to clean up"
    fi
    
    echo ""
    echo "Phase 7: Cleaning up CloudWatch log groups..."
    # Clean up both project-specific Lambda log groups and CDK-generated log groups
    local cloudwatch_log_groups
    local cdk_log_groups
    local all_log_groups
    
    # Get project-specific Lambda log groups
    cloudwatch_log_groups=$(aws logs describe-log-groups --query "logGroups[?starts_with(logGroupName, '/aws/lambda/$BASE_NAME-$ENVIRONMENT')].logGroupName" --output text 2>/dev/null || echo "")
    
    # Get CDK-generated log groups (both AwsCustomResource and S3 deployment functions)
    cdk_log_groups=$(aws logs describe-log-groups --query "logGroups[?contains(logGroupName, 'JlLossRegisterApplica-')].logGroupName" --output text 2>/dev/null || echo "")
    
    # Get Step Functions execution log groups (created by the workflow in Application Stack)
    # Use grep filtering since JMESPath contains() can be unreliable
    step_functions_log_groups=$(aws logs describe-log-groups --query "logGroups[].logGroupName" --output text 2>/dev/null | tr -s '[:space:]' '\n' | grep "$BASE_NAME-workflow-$ENVIRONMENT" || echo "")
    
    # Combine all lists
    all_log_groups=$(echo -e "${cloudwatch_log_groups}\n${cdk_log_groups}\n${step_functions_log_groups}" | grep -v '^$' | sort -u)
    
    if [ ! -z "$all_log_groups" ] && [ "$all_log_groups" != "None" ]; then
        echo "  Found CloudWatch log groups to clean up:"
        local log_delete_errors=0
        # Handle tab/space-separated names by converting to newlines first
        while read -r log_group_name; do
            if [ ! -z "$log_group_name" ] && [ "$log_group_name" != "None" ]; then
                echo "  Removing CloudWatch log group: $log_group_name"
                if aws logs delete-log-group --log-group-name "$log_group_name" >/dev/null 2>&1; then
                    echo "    CloudWatch log group deleted: $log_group_name"
                else
                    echo "    Failed to delete CloudWatch log group: $log_group_name"
                    log_delete_errors=$((log_delete_errors + 1))
                fi
            fi
        done <<< "$(echo "$all_log_groups" | tr -s '[:space:]' '\n')"
        
        if [ $log_delete_errors -gt 0 ]; then
            echo "  WARNING: $log_delete_errors CloudWatch log group(s) failed to delete"
        fi
    else
        echo "  No CloudWatch log groups to clean up"
    fi
    
    echo ""
    echo "Note: Lambda layers are automatically cleaned up by CDK destroy"
    
    echo ""
    echo "Application cleanup completed successfully!"
}

# Main execution
main() {
    echo "Starting cleanup process..."
    echo ""
    
    # Confirm before proceeding
    echo "WARNING: This will DELETE project resources!"
    if [ "$DELETE_S3_BUCKETS" = true ]; then
        echo "WARNING: S3 buckets will also be DELETED (--delete-s3-buckets flag provided)!"
    fi
    echo ""
    echo "This script will check if the relevant CDK stacks are destroyed before proceeding."
    echo "If any required stack still exists, cleanup will fail (safety feature)."
    echo ""
            read -p "Are you sure you want to proceed with cleanup? (y/n): " confirm
        if [ "$confirm" != "y" ]; then
        echo "Cleanup cancelled by user"
        exit 0
    fi
    echo ""
    
    # Execute cleanup based on mode
    case $CLEANUP_MODE in
        "infra")
            echo "Running INFRASTRUCTURE cleanup only..."
            if ! check_infrastructure_stack; then
                echo ""
                echo "ERROR: Infrastructure stack '$INFRASTRUCTURE_STACK_NAME' still exists - cleanup cannot proceed"
                exit 1
            fi
            if ! cleanup_infrastructure_resources; then
                echo ""
                echo "ERROR: Infrastructure cleanup failed!"
                exit 1
            fi
            echo ""
            echo "Infrastructure cleanup completed successfully!"
            ;;
        "app")
            echo "Running APPLICATION cleanup only..."
            if ! check_application_stack; then
                echo ""
                echo "ERROR: Application stack '$APPLICATION_STACK_NAME' still exists - cleanup cannot proceed"
                exit 1
            fi
            if ! cleanup_application_resources; then
                echo ""
                echo "ERROR: Application cleanup failed!"
                exit 1
            fi
            echo ""
            echo "Application cleanup completed successfully!"
            ;;
        "all")
            echo "Running COMPLETE cleanup (infrastructure first, then application)..."
            echo ""
            
            # Check both stacks first
            if ! check_infrastructure_stack; then
                echo ""
                echo "ERROR: Infrastructure stack '$INFRASTRUCTURE_STACK_NAME' still exists - cleanup cannot proceed"
                exit 1
            fi
            if ! check_application_stack; then
                echo ""
                echo "ERROR: Application stack '$APPLICATION_STACK_NAME' still exists - cleanup cannot proceed"
                exit 1
            fi
            echo ""
            
            # Clean up infrastructure first
            if ! cleanup_infrastructure_resources; then
                echo ""
                echo "ERROR: Infrastructure cleanup failed!"
                exit 1
            fi
            echo ""
            
            # Then clean up application
            if ! cleanup_application_resources; then
                echo ""
                echo "ERROR: Application cleanup failed!"
                exit 1
            fi
            echo ""
            echo "ALL CLEANUP COMPLETED SUCCESSFULLY!"
            ;;
        *)
            echo "ERROR: Invalid cleanup mode: $CLEANUP_MODE"
            exit 1
            ;;
    esac
    
    echo ""
    echo "Final Summary:"
    case $CLEANUP_MODE in
        "infra")
            echo "- Infrastructure stack: Confirmed destroyed and resources cleaned up"
            echo "- DynamoDB tables: Cleaned up"
            echo "- IAM roles: Cleaned up"
            echo "- CloudWatch logs: Cleaned up"
            echo "- CDK default resources: Cleaned up (Lambda, IAM, CloudWatch)"
            if [ "$DELETE_S3_BUCKETS" = true ]; then
                echo "- S3 buckets: Deleted (--delete-s3-buckets flag used)"
            else
                echo "- S3 buckets: Preserved (data protection)"
            fi
            ;;
        "app")
            echo "- Application stack: Confirmed destroyed and resources cleaned up"
            echo "- Event source mappings: Cleaned up (prevented orphaned connections)"
            echo "- S3 event triggers: Cleaned up"
            echo "- Lambda functions: Cleaned up"
            echo "- SQS queues: Cleaned up"
            echo "- Step Functions: Cleaned up"
            echo "- CloudWatch logs: Cleaned up"
            ;;
        "all")
            echo "- Infrastructure stack: Confirmed destroyed and resources cleaned up"
            echo "- Application stack: Confirmed destroyed and resources cleaned up"
            echo "- All retained resources: Cleaned up"
            if [ "$DELETE_S3_BUCKETS" = true ]; then
                echo "- S3 buckets: Deleted (--delete-s3-buckets flag used)"
            else
                echo "- S3 buckets: Preserved (data protection)"
            fi
            ;;
    esac
    
    echo ""
    echo "Now run 'cdk deploy' to deploy fresh infrastructure and application"
  
}

# Run main function
main "$@"



