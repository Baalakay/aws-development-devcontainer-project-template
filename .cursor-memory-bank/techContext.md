# Technical Context - Loss Register Data Processing

## Current Technology Stack

### Core Technologies
- **Python 3.12**: Primary development language
- **AWS CDK v2**: Infrastructure as code framework
- **AWS Lambda**: Serverless compute for data processing
- **AWS S3**: Data storage and event triggers
- **AWS SQS**: Message queuing for async processing
- **AWS DynamoDB**: Metadata storage and processing history
- **AWS Bedrock**: LLM service (Claude 3.7 Sonnet)
- **AWS CloudWatch**: Logging, monitoring, and metrics

### Python Libraries
- **openpyxl**: Excel XLSX file processing
- **boto3**: AWS SDK for Python
- **fastjsonschema**: JSON schema validation
- **aws-lambda-powertools**: Lambda utilities (Logger, Tracer, Metrics)

## AWS Infrastructure

### Infrastructure Stack (`Dev-JlLossRegisterInfrastructureStack`)
- **S3 Bucket**: `jl-bat-loss-register-dev` - Data lake for all processing
- **DynamoDB Tables**:
  - `jl-bat-loss-register-metadata-dev` - File metadata tracking
  - `jl-bat-loss-register-processing-history-dev` - Processing history
  - `jl-bat-loss-register-schema-mappings-dev` - Schema mappings
  - `jl-bat-loss-register-schemas-dev` - Schema storage
- **CloudWatch Log Groups**: Environment-specific logging
- **IAM Roles**: Lambda execution roles with granular permissions

### Application Stack (`Dev-JlLossRegisterApplicationStack`)
- **Lambda Functions**:
  - `processS3UploadEvent` - S3 event handler and metadata recorder
  - `detectRawSchema` - Excel processing and LLM analysis (512MB, 300s timeout)
  - `analyze_raw_schema_csv` - CSV processing for comparison testing
  - `processS3UploadEventTest` - Test version for parallel processing
- **SQS Queues**:
  - `jl-bat-loss-register-queue-dev` - Main processing queue
  - `jl-bat-loss-register-queue-test` - Test queue for CSV comparison
- **Lambda Layers**:
  - `XlsxParsingLayer` - openpyxl and dependencies for Excel processing
- **S3 Event Notifications**: Configured for `raw/` and `raw-test/` prefixes

## Development Environment

### Local Development Setup
- **Python Virtual Environment**: `.venv` with Python 3.12
- **Dependencies**: `requirements-dev.txt` for development packages
- **AWS CLI**: Configured with appropriate profiles
- **CDK**: Version 2.x for infrastructure deployment

### Container Environment
- **Dev Container**: VS Code devcontainer with Python 3.12
- **Docker**: For local testing and development
- **LocalStack**: For local AWS service emulation (if needed)

## Deployment Configuration

### Environment Variables
- `ENVIRONMENT`: Set to 'dev', 'staging', or 'prod'
- `AWS_REGION`: AWS region for deployment (default: us-east-1)
- `AWS_PROFILE`: AWS profile for deployment
- `CDK_DEFAULT_ACCOUNT`: AWS account ID for deployment
- `CDK_DEFAULT_REGION`: AWS region for deployment

### CDK Context
- **Environment**: Determines resource naming and configuration
- **Account**: AWS account for deployment
- **Region**: AWS region for deployment
- **Stack Dependencies**: Infrastructure stack must be deployed first

## Performance Configuration

### Lambda Function Settings
- **detectRawSchema**:
  - Memory: 512MB
  - Timeout: 300 seconds
  - Runtime: Python 3.12
  - Layers: XlsxParsingLayer
- **processS3UploadEvent**:
  - Memory: 256MB
  - Timeout: 60 seconds
  - Runtime: Python 3.12

### SQS Configuration
- **Message Retention**: 14 days
- **Visibility Timeout**: 30 seconds
- **Dead Letter Queue**: Enabled for failed message handling
- **Batch Size**: 1 message per Lambda invocation

### S3 Configuration
- **Bucket Encryption**: Server-side encryption enabled
- **Public Access**: Blocked for all environments
- **Versioning**: Enabled for audit trails
- **Lifecycle Policies**: Automatic cleanup of temporary files

## Security Configuration

### IAM Permissions
- **Lambda Execution Role**: Minimal permissions for each function
- **S3 Access**: Read/write access to specific buckets and prefixes
- **DynamoDB Access**: Read/write access to specific tables
- **SQS Access**: Send/receive messages from specific queues
- **Bedrock Access**: Invoke Claude 3.7 Sonnet model

### Data Protection
- **Encryption at Rest**: S3 bucket encryption for all data
- **Encryption in Transit**: HTTPS for all API calls
- **Access Control**: IAM policies for resource access
- **Audit Logging**: CloudTrail and CloudWatch logging

## Monitoring and Observability

### CloudWatch Logs
- **Structured Logging**: JSON-formatted logs for easy parsing
- **Log Retention**: Environment-specific retention policies
- **Log Groups**: Separate groups for each Lambda function
- **Metrics**: Custom metrics for business and technical monitoring

### CloudWatch Metrics
- **Lambda Metrics**: Duration, errors, throttles
- **SQS Metrics**: Message count, age, visibility
- **S3 Metrics**: Request count, latency, errors
- **Custom Metrics**: Files processed, processing time, success rate

### CloudWatch Alarms
- **Error Rate**: Alert on high Lambda error rates
- **Processing Time**: Alert on slow processing times
- **Queue Depth**: Alert on SQS queue buildup
- **Resource Usage**: Alert on high resource utilization

## Integration Points

### AWS Bedrock Integration
- **Model**: Claude 3.7 Sonnet
- **Region**: us-east-1
- **Authentication**: IAM role-based access
- **Rate Limiting**: Respect Bedrock service limits
- **Error Handling**: Graceful fallback for service issues

### S3 Event Integration
- **Event Types**: `s3:ObjectCreated:*`
- **Prefix Filtering**: `raw/` and `raw-test/` prefixes
- **Lambda Trigger**: Direct Lambda invocation
- **Error Handling**: Dead letter queue for failed events

### SQS Integration
- **Event Source Mapping**: Lambda functions triggered by SQS messages
- **Batch Processing**: Single message processing for reliability
- **Error Handling**: Dead letter queue for failed messages
- **Monitoring**: CloudWatch metrics for queue health

## Testing and Validation

### Local Testing
- **Direct Python Execution**: Import and test Lambda functions directly
- **Mock AWS Services**: Use moto or similar for AWS service mocking
- **Test Events**: JSON event files for testing
- **Environment Variables**: Set test credentials for local development

### Integration Testing
- **S3 Upload Testing**: Upload test files to S3 buckets
- **End-to-End Testing**: Complete workflow testing
- **Performance Testing**: Large file processing validation
- **Error Testing**: Error condition validation

### Production Testing
- **Staging Environment**: Pre-production validation
- **Blue-Green Deployment**: Zero-downtime deployment strategy
- **Rollback Strategy**: Quick rollback to previous version
- **Health Checks**: Automated health check validation

## Maintenance and Operations

### Dependency Management
- **Python Dependencies**: Pinned versions in requirements files
- **Lambda Layers**: Updated when dependencies change
- **CDK Dependencies**: Managed through package.json
- **Security Updates**: Regular dependency vulnerability scanning

### Monitoring and Alerting
- **Proactive Monitoring**: Monitor key metrics and trends
- **Alert Response**: Automated and manual alert response
- **Incident Management**: Structured incident response process
- **Post-Incident Review**: Learn from incidents and improve

### Backup and Recovery
- **Data Backup**: S3 versioning and cross-region replication
- **Configuration Backup**: CDK code and configuration backup
- **Disaster Recovery**: Multi-region deployment strategy
- **Testing**: Regular backup and recovery testing

## Future Technical Considerations

### Scalability Improvements
- **Horizontal Scaling**: Add more Lambda functions for increased load
- **Vertical Scaling**: Increase Lambda memory and timeout for complex files
- **Queue Management**: Implement queue prioritization for different file types
- **Caching Layer**: Add Redis or DynamoDB caching for frequently accessed data

### Advanced Features
- **Machine Learning**: Integrate ML models for better data classification
- **Real-Time Processing**: Implement real-time processing for urgent files
- **Batch Processing**: Add batch processing for multiple files
- **Streaming**: Implement streaming processing for large files

### Integration Enhancements
- **API Gateway**: Expose processing capabilities via REST API
- **EventBridge**: Use EventBridge for more complex event routing
- **Step Functions**: Implement complex workflows with Step Functions
- **External APIs**: Integrate with external data sources and systems