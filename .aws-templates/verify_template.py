#!/usr/bin/env python3
"""
Template Verification Script
Verifies that the AWS CDK template is properly configured and shows resource names.
"""

import sys
import os
sys.path.append('lib')

try:
    from config import PROJECT_NAME, AWS_ACCOUNTS, ENVIRONMENT_CONFIGS
except ImportError as e:
    print(f"❌ Error importing config: {e}")
    print("Make sure you're in the project root directory")
    sys.exit(1)

def print_header(title):
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}")

def print_section(title):
    print(f"\n{'-'*40}")
    print(f"  {title}")
    print(f"{'-'*40}")

def verify_config():
    """Verify the configuration is valid"""
    print_header("Template Configuration Verification")
    
    # Check PROJECT_NAME
    print_section("Project Configuration")
    print(f"✅ Project Name: {PROJECT_NAME}")
    
    if not PROJECT_NAME or PROJECT_NAME == "incident-extractor":
        print("⚠️  Warning: PROJECT_NAME still set to default 'incident-extractor'")
        print("   Consider changing this to your project name")
    
    # Check AWS_ACCOUNTS
    print_section("AWS Account Configuration")
    for env, account in AWS_ACCOUNTS.items():
        if account:
            print(f"✅ {env.capitalize()}: {account}")
        else:
            print(f"⚠️  {env.capitalize()}: Not configured")
    
    # Check ENVIRONMENT_CONFIGS
    print_section("Environment Configurations")
    for env, config in ENVIRONMENT_CONFIGS.items():
        print(f"✅ {env.capitalize()}: {config['retention_days']} days retention, "
              f"{config['timeout_seconds']}s timeout, {config['memory_size']}MB memory")

def show_resource_names():
    """Show what resource names will be created"""
    print_header("Resource Naming Preview")
    
    print_section("Resource Naming Pattern")
    print(f"Pattern: {PROJECT_NAME}-{{service}}-{{environment}}")
    
    print_section("Example Resource Names")
    services = [
        ("storage", "S3 Bucket"),
        ("data", "DynamoDB Table"),
        ("processor", "Lambda Function"),
        ("bedrock-service", "Lambda Layer"),
        ("lambda-role", "IAM Role"),
        ("logs", "CloudWatch Log Group"),
        ("queue", "SQS Queue")
    ]
    
    for service, description in services:
        for env in ['dev', 'staging', 'prod']:
            if env == 'prod':
                name = f"{PROJECT_NAME}-{service}"
            else:
                name = f"{PROJECT_NAME}-{service}-{env}"
            print(f"{description:20} {name}")

def show_deployment_info():
    """Show deployment information"""
    print_header("Deployment Information")
    
    print_section("CDK Commands")
    print("To deploy to different environments:")
    print(f"  Dev:      cdk deploy --profile default")
    print(f"  Staging:  cdk deploy --profile default")
    print(f"  Prod:     cdk deploy --profile default")
    
    print_section("Verification Commands")
    print("To verify your configuration:")
    print(f"  Check config: cat lib/config.py | grep -E '(PROJECT_NAME|AWS_ACCOUNTS)'")
    print(f"  Test synthesis: cdk synth")
    print(f"  List stacks: cdk list")

def check_critical_rules():
    """Check critical implementation rules"""
    print_header("Critical Rules Check")
    
    print_section("Bedrock API Usage")
    print("✅ MUST use: bedrock_runtime.converse()")
    print("❌ NEVER use: bedrock_runtime.invoke_model()")
    print("✅ Model ID: us.anthropic.claude-3-7-sonnet-20250219-v1:0")
    print("✅ System prompts: [{'text': 'prompt'}]")
    
    print_section("Naming Convention")
    print(f"✅ Follow pattern: {PROJECT_NAME}-{{service}}-{{environment}}")
    print("✅ Use config variables, not hardcoded names")
    print("✅ Environment suffixes: -dev, -staging, -prod")

def main():
    """Main verification function"""
    try:
        verify_config()
        show_resource_names()
        show_deployment_info()
        check_critical_rules()
        
        print_header("Template Verification Complete")
        print("✅ Your template is ready for customization!")
        print("\nNext steps:")
        print("1. Change PROJECT_NAME in lib/config.py")
        print("2. Update AWS_ACCOUNTS with your account IDs")
        print("3. Update package.json name field")
        print("4. Run 'npm install'")
        print("5. Test with 'cdk synth'")
        
    except Exception as e:
        print(f"❌ Verification failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
