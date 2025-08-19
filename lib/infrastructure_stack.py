import json
from aws_cdk import (
    Stack,
    aws_s3 as s3,
    aws_dynamodb as dynamodb,
    aws_iam as iam,
    aws_logs as logs,
    aws_lambda as lambda_,
    aws_sqs as sqs,
    aws_ssm as ssm,
    RemovalPolicy,
    Duration,
    CfnOutput,
)
from constructs import Construct
from .config import PROJECT_NAME, ENVIRONMENT_CONFIGS

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

        # S3 Bucket for PDF storage and processed data
        self.pdf_storage_bucket = s3.Bucket(
            self, "PdfStorageBucket",
            bucket_name=f"{base_name}-storage{env_suffix}",
            versioned=True,
            removal_policy=RemovalPolicy.RETAIN if environment == 'prod' else RemovalPolicy.DESTROY,
            auto_delete_objects=environment != 'prod',
            public_read_access=False,
            block_public_access=s3.BlockPublicAccess.BLOCK_ALL if public_access_blocked else s3.BlockPublicAccess.BLOCK_ACLS,
            encryption=s3.BucketEncryption.S3_MANAGED,
            lifecycle_rules=[
                s3.LifecycleRule(
                    id="RetentionPolicy",
                    expiration=Duration.days(retention_days),
                    transitions=[
                        s3.Transition(
                            storage_class=s3.StorageClass.INFREQUENT_ACCESS,
                            transition_after=Duration.days(30)
                        )
                    ]
                )
            ]
        )

        # DynamoDB Table for structured data storage
        self.data_table = dynamodb.Table(
            self, "DataTable",
            table_name=f"{base_name}-data{env_suffix}",
            partition_key=dynamodb.Attribute(
                name="id",
                type=dynamodb.AttributeType.STRING
            ),
            sort_key=dynamodb.Attribute(
                name="timestamp",
                type=dynamodb.AttributeType.STRING
            ),
            billing_mode=dynamodb.BillingMode.PAY_PER_REQUEST,
            removal_policy=RemovalPolicy.RETAIN if environment == 'prod' else RemovalPolicy.DESTROY,
            point_in_time_recovery=environment == 'prod',
            time_to_live_attribute="ttl"
        )

        # CloudWatch Log Group for centralized logging
        self.main_log_group = logs.LogGroup(
            self, "MainLogGroup",
            log_group_name=f"{base_name}-logs{env_suffix}",
            retention=logs.RetentionDays.DAYS_7 if environment == 'dev' else logs.RetentionDays.DAYS_30 if environment == 'staging' else logs.RetentionDays.DAYS_365,
            removal_policy=RemovalPolicy.RETAIN if environment == 'prod' else RemovalPolicy.DESTROY
        )

        # IAM Role for Lambda functions
        self.lambda_execution_role = iam.Role(
            self, "LambdaExecutionRole",
            role_name=f"{base_name}-lambda-role{env_suffix}",
            assumed_by=iam.ServicePrincipal("lambda.amazonaws.com"),
            managed_policies=[
                iam.ManagedPolicy.from_aws_managed_policy_name("service-role/AWSLambdaBasicExecutionRole"),
                iam.ManagedPolicy.from_aws_managed_policy_name("service-role/AWSLambdaVPCAccessExecutionRole")
            ]
        )

        # SQS Queue for message processing
        self.processing_queue = sqs.Queue(
            self, "ProcessingQueue",
            queue_name=f"{base_name}-queue{env_suffix}",
            visibility_timeout=Duration.seconds(300),
            retention_period=Duration.days(14),
            removal_policy=RemovalPolicy.RETAIN if environment == 'prod' else RemovalPolicy.DESTROY
        )

        # Parameter Store for model configurations
        self.model_config_parameter = ssm.StringParameter(
            self, "ModelConfigParameter",
            parameter_name=f"/{base_name}/{environment}/bedrock-model",
            string_value="us.anthropic.claude-3-7-sonnet-20250219-v1:0",
            description="Bedrock model configuration for incident extraction",
            tier=ssm.ParameterTier.STANDARD
        )

        # CloudWatch Outputs
        CfnOutput(self, "StorageBucketName", value=self.pdf_storage_bucket.bucket_name)
        CfnOutput(self, "DataTableName", value=self.data_table.table_name)
        CfnOutput(self, "LogGroupName", value=self.main_log_group.log_group_name)
        CfnOutput(self, "QueueUrl", value=self.processing_queue.queue_url)