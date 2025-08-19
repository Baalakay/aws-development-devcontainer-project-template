import json
from aws_cdk import (
    Stack,
    aws_lambda as lambda_,
    aws_logs as logs,
    aws_sqs as sqs,
    aws_iam as iam,
    aws_s3 as s3,
    aws_s3_notifications as s3n,
    RemovalPolicy,
    Duration,
    CfnOutput,
)
from constructs import Construct
from .config import PROJECT_NAME, ENVIRONMENT_CONFIGS

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
            layer_version_name=f"{base_name}-bedrock-service{env_suffix}",
            code=lambda_.Code.from_asset("lambda-layers/bedrock-service"),
            compatible_runtimes=[lambda_.Runtime.PYTHON_3_12],
            description="Bedrock service for LLM vision analysis"
        )

        # Main processing Lambda function
        self.processing_function = lambda_.Function(
            self, "ProcessingFunction",
            function_name=f"{base_name}-processor{env_suffix}",
            runtime=lambda_.Runtime.PYTHON_3_12,
            code=lambda_.Code.from_asset("lambdas/processor"),
            handler="index.handler",
            timeout=Duration.seconds(timeout_seconds),
            memory_size=memory_size,
            role=self.infrastructure_stack.lambda_execution_role,
            environment={
                "ENVIRONMENT": environment,
                "DATA_TABLE": self.infrastructure_stack.data_table.table_name,
                "QUEUE_URL": self.infrastructure_stack.processing_queue.queue_url,
                "MODEL_PARAMETER": self.infrastructure_stack.model_config_parameter.parameter_name
            },
            layers=[self.bedrock_service_layer]
        )

        # S3 Event Notification for PDF uploads
        self.pdf_upload_notification = s3n.LambdaDestination(self.processing_function)
        self.infrastructure_stack.pdf_storage_bucket.add_event_notification(
            s3.EventType.OBJECT_CREATED,
            self.pdf_upload_notification,
            s3.NotificationKeyFilter(suffix=".pdf")
        )

        # Grant permissions
        self.infrastructure_stack.pdf_storage_bucket.grant_read(self.processing_function)
        self.infrastructure_stack.data_table.grant_write_data(self.processing_function)
        self.infrastructure_stack.processing_queue.grant_send_messages(self.processing_function)

        # CloudWatch Outputs
        CfnOutput(self, "ProcessingFunctionName", value=self.processing_function.function_name)
        CfnOutput(self, "BedrockLayerName", value=self.bedrock_service_layer.layer_version_name)