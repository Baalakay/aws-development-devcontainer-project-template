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
from constructs import Construct

class InfrastructureStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, environment='dev', **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
        
        # Environment-specific naming
        env_suffix = f"-{environment}" if environment != 'prod' else ""
        base_name = "new-project"
        
        # Environment-specific configurations
        if environment == 'dev':
            retention_days = 7  # Shorter retention for dev
            public_access_blocked = False  # Easier debugging for development
        elif environment == 'staging':
            retention_days = 30  # Medium retention for staging
            public_access_blocked = True
        else:  # prod
            retention_days = 365  # Full retention for production
            public_access_blocked = True