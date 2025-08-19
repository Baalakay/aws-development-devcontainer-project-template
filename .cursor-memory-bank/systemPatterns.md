# System Architecture Patterns - Loss Register Data Processing

## Current Architecture Overview
The system uses a hybrid CDK architecture with clear separation between infrastructure and application concerns, implementing intelligent Excel processing with LLM analysis for loss register detection.

## Core Architectural Patterns

### 1. Hybrid CDK Stack Architecture
- **Infrastructure Stack**: Core AWS resources (S3, DynamoDB, IAM, CloudWatch)
- **Application Stack**: Lambda functions, SQS queues, Lambda layers
- **Cross-Stack Dependencies**: Application stack imports from Infrastructure stack
- **Environment Separation**: Dev, Staging, Production with environment-specific configurations

### 2. Serverless Event-Driven Pipeline
```
S3 Upload → processS3UploadEvent → SQS → detectRawSchema → S3 Output
```

**Pattern Benefits:**
- **Scalability**: Automatic scaling based on S3 upload volume
- **Reliability**: SQS provides message durability and retry logic
- **Decoupling**: S3 events decoupled from processing logic
- **Monitoring**: CloudWatch logs for each stage of processing

### 3. Intelligent Excel Processing Pattern
- **XLSX to CSV Conversion**: Convert large Excel files to CSV for efficient processing
- **Intelligent Header Detection**: Advanced scoring with business terminology recognition
- **Phantom Column Filtering**: Automatic removal of empty columns from merged cells
- **Minimal Metadata Extraction**: Only extract necessary attributes to avoid overhead

### 4. LLM Analysis Pattern
- **Insurance Claims Analyst Role**: LLM acts as domain expert to identify loss register data
- **Structured Input**: Send headers and sample data in LLM_INPUT.json
- **Confidence Scoring**: LLM provides confidence scores for analysis decisions
- **File Classification**: Separate loss register vs supplemental worksheets

## Data Flow Patterns

### 1. File Upload and Trigger Pattern
- **S3 Event Notification**: Triggers on `s3:ObjectCreated:*` for `raw/` prefix
- **Metadata Recording**: Store file information in DynamoDB before processing
- **SQS Message**: Send processing message to queue for async processing

### 2. Excel Processing Pattern
- **Download and Convert**: Download XLSX, convert to CSV for efficiency
- **Worksheet Iteration**: Process each worksheet independently
- **Header Detection**: Use intelligent scoring to identify meaningful headers
- **Data Sampling**: Extract strategic samples for LLM analysis

### 3. LLM Integration Pattern
- **AWS Bedrock**: Use Claude 3.7 Sonnet for analysis
- **Structured Prompts**: Clear instructions for insurance claims analysis
- **JSON Output**: Structured responses for consistent processing
- **Error Handling**: Graceful fallback if LLM analysis fails

### 4. Output Organization Pattern
- **Loss Register Data**: Store in `loss-register/` subfolder
- **Supplemental Data**: Store in `supplemental/` subfolder
- **File Naming**: Consistent naming convention across all outputs
- **Metadata Preservation**: Include all necessary metadata in output files

## Technical Implementation Patterns

### 1. Lambda Function Patterns
- **Single Responsibility**: Each Lambda has one clear purpose
- **Error Handling**: Comprehensive error handling with logging
- **Metrics**: CloudWatch metrics for monitoring and alerting
- **Timeout Management**: Appropriate timeouts for different processing stages

### 2. SQS Queue Patterns
- **Dead Letter Queues**: Handle failed message processing
- **Visibility Timeout**: Prevent duplicate processing
- **Message Retention**: Appropriate retention for audit purposes
- **Batch Processing**: Process multiple messages when possible

### 3. S3 Storage Patterns
- **Prefix-Based Organization**: Use prefixes for logical file grouping
- **Lifecycle Policies**: Automatic cleanup of temporary files
- **Versioning**: Enable versioning for audit trails
- **Encryption**: Server-side encryption for all data

### 4. DynamoDB Patterns
- **Metadata Storage**: Store file and processing metadata
- **Processing History**: Track processing status and results
- **Schema Storage**: Store detected schemas for future reference
- **Audit Trail**: Maintain complete processing history

## Performance Optimization Patterns

### 1. Excel Processing Optimization
- **CSV Conversion**: Convert XLSX to CSV for faster processing
- **Streaming Processing**: Process data in chunks to avoid memory issues
- **Parallel Processing**: Process multiple worksheets concurrently when possible
- **Minimal Metadata**: Only extract necessary attributes to reduce overhead

### 2. Lambda Optimization
- **Memory Allocation**: 512MB for Excel processing functions
- **Timeout Configuration**: 300 seconds for large file processing
- **Cold Start Minimization**: Minimize dependencies and initialization
- **Efficient Libraries**: Use openpyxl for XLSX processing

### 3. S3 Optimization
- **Efficient Downloads**: Download only necessary parts of files
- **Batch Operations**: Use batch operations for multiple files
- **Compression**: Compress output files when appropriate
- **Caching**: Cache frequently accessed metadata

## Security and Compliance Patterns

### 1. IAM Security Patterns
- **Principle of Least Privilege**: Grant minimum necessary permissions
- **Role-Based Access**: Use execution roles for Lambda functions
- **Cross-Account Security**: Secure cross-account resource access
- **Audit Logging**: Comprehensive CloudTrail logging

### 2. Data Protection Patterns
- **Encryption at Rest**: S3 bucket encryption for all data
- **Encryption in Transit**: HTTPS for all API calls
- **Access Control**: Block all public access to S3 buckets
- **Data Lifecycle**: Automatic cleanup of temporary data

### 3. Compliance Patterns
- **Audit Trails**: Complete processing history in DynamoDB
- **Data Retention**: Environment-specific retention policies
- **Access Logging**: S3 access logs for compliance
- **Monitoring**: CloudWatch monitoring and alerting

## Monitoring and Observability Patterns

### 1. Logging Patterns
- **Structured Logging**: JSON-formatted logs for easy parsing
- **Context Preservation**: Include relevant context in all log entries
- **Error Tracking**: Comprehensive error logging with stack traces
- **Performance Metrics**: Log processing times and resource usage

### 2. Metrics Patterns
- **Custom Metrics**: Track business-specific metrics
- **Performance Metrics**: Monitor processing times and success rates
- **Resource Metrics**: Track Lambda and S3 resource usage
- **Business Metrics**: Track files processed and success rates

### 3. Alerting Patterns
- **Error Rate Alerts**: Alert on high error rates
- **Performance Alerts**: Alert on slow processing times
- **Resource Alerts**: Alert on resource usage thresholds
- **Business Alerts**: Alert on processing failures

## Environment Management Patterns

### 1. Environment Separation
- **Resource Naming**: Environment-specific resource names
- **Configuration Management**: Environment-specific configurations
- **Security Levels**: Different security settings per environment
- **Retention Policies**: Environment-specific data retention

### 2. Deployment Patterns
- **Infrastructure First**: Deploy infrastructure stack before application
- **Dependency Management**: Clear dependency ordering between stacks
- **Rollback Strategy**: Ability to rollback to previous versions
- **Testing Strategy**: Environment-specific testing approaches

## Future Architecture Considerations

### 1. Scalability Patterns
- **Horizontal Scaling**: Add more Lambda functions for increased load
- **Vertical Scaling**: Increase Lambda memory and timeout for complex files
- **Queue Management**: Implement queue prioritization for different file types
- **Caching Layer**: Add Redis or DynamoDB caching for frequently accessed data

### 2. Advanced Processing Patterns
- **Machine Learning**: Integrate ML models for better data classification
- **Real-Time Processing**: Implement real-time processing for urgent files
- **Batch Processing**: Add batch processing for multiple files
- **Streaming**: Implement streaming processing for large files

### 3. Integration Patterns
- **API Gateway**: Expose processing capabilities via REST API
- **EventBridge**: Use EventBridge for more complex event routing
- **Step Functions**: Implement complex workflows with Step Functions
- **External APIs**: Integrate with external data sources and systems