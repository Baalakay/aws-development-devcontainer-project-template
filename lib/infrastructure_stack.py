import json
from aws_cdk import (
    Stack,
    aws_s3 as s3,
    aws_dynamodb as dynamodb,
    aws_iam as iam,
    aws_logs as logs,
    aws_lambda as lambda_,
    RemovalPolicy,
    Duration,
    CfnOutput,
)
from constructs import Constructnfrom .config import PROJECT_NAME, ENVIRONMENT_CONFIGS

class InfrastructureStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, environment='dev', **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
        
        # Environment-specific naming
        env_suffix = f"-{environment}" if environment != 'prod' else ""
        base_name = PROJECT_NAME
        
        # Environment-specific configurations
        config = ENVIRONMENT_CONFIGS.get(environment, ENVIRONMENT_CONFIGS['dev'])
        retention_days = config['retention_days']
        public_access_blocked = config['public_access_blocked']





