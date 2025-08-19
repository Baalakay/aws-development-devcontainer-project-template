import json
from aws_cdk import (
    Stack,
    aws_lambda as lambda_,
    aws_logs as logs,
    aws_stepfunctions as sfn,
    aws_stepfunctions_tasks as sfn_tasks,
    aws_sqs as sqs,
    aws_iam as iam,
    aws_s3 as s3,
    aws_s3_notifications as s3n,
    RemovalPolicy,
    Duration,
    CfnOutput,
)
from constructs import Construct

class ApplicationStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, infrastructure_stack=None, environment='dev', **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
        
        # Reference infrastructure stack resources
        self.infrastructure_stack = infrastructure_stack
        
        # Environment-specific naming
        self.env_name = environment
        env_suffix = f"-{environment}" if environment != 'prod' else ""
        self.base_name = "jl-bat-loss-register"
        base_name = self.base_name  # Keep local variable for backward compatibility
        
        # Environment-specific configurations
        if environment == 'dev':
            timeout_seconds = 30  # Shorter timeouts for dev
            memory_size = 256  # Less memory for dev
            max_receive_count = 1  # Fewer retries for dev
        elif environment == 'staging':
            timeout_seconds = 60  # Medium timeouts for staging
            memory_size = 512  # Medium memory for staging
            max_receive_count = 2  # Medium retries for staging
        else:  # prod
            timeout_seconds = 300  # Full timeouts for production
            memory_size = 1024  # Full memory for production
            max_receive_count = 3  # Full retries for production

        # Lambda Layers for shared dependencies
        self.bedrock_service_layer = lambda_.LayerVersion(
            self, "BedrockServiceLayer",
            layer_version_name=f"{base_name}-{environment}-bedrock-service",
            code=lambda_.Code.from_asset("lambda-layers/bedrock-service"),
            compatible_runtimes=[lambda_.Runtime.PYTHON_3_12],
            description="Bedrock service for LLM vision analysis"
        )