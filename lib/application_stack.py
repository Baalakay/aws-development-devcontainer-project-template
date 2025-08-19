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
from constructs import Constructnfrom .config import PROJECT_NAME, ENVIRONMENT_CONFIGS

class ApplicationStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, infrastructure_stack=None, environment='dev', **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
        
        # Reference infrastructure stack resources
        self.infrastructure_stack = infrastructure_stack
        
        # Environment-specific naming
        self.env_name = environment
        env_suffix = f"-{environment}" if environment != 'prod' else ""
        self.base_name = PROJECT_NAME
        base_name = self.base_name  # Keep local variable for backward compatibility
        
        # Environment-specific configurations
        config = ENVIRONMENT_CONFIGS.get(environment, ENVIRONMENT_CONFIGS['dev'])
        timeout_seconds = config['timeout_seconds']
        memory_size = config['memory_size']
        max_receive_count = config['max_receive_count']









        # Lambda Layers for shared dependencies
        self.bedrock_service_layer = lambda_.LayerVersion(
            self, "BedrockServiceLayer",
            layer_version_name=f"{base_name}-{environment}-bedrock-service",
            code=lambda_.Code.from_asset("lambda-layers/bedrock-service"),
            compatible_runtimes=[lambda_.Runtime.PYTHON_3_12],
            description="Bedrock service for LLM vision analysis"
        )