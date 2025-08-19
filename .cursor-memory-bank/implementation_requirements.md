# Implementation Requirements - XLSX-Only Python Parsing Approach

## **🎯 IMPLEMENTATION OVERVIEW**

### **New Lambda Function: detectRawSchema**
- **Purpose**: Replace current LLM approach with XLSX-only Python parsing + LLM hybrid
- **Deployment**: Zip function with Lambda layer (no container required)
- **Event Source**: SQS messages from S3 uploads
- **Output**: Schema JSON files only (no data extraction)
- **Format Support**: XLSX only (no legacy formats)

## **🔧 TECHNICAL REQUIREMENTS**

### **XLSX Integration (Pure Python)**
- **Table Detection**: Use openpyxl for XLSX metadata parsing
- **ListObjects**: Detect defined Excel tables with exact boundaries
- **Pivot Tables**: Parse XLSX XML for pivot table locations
- **Named Ranges**: Identify named ranges that represent table structures
- **Free-form Detection**: Heuristic detection when no structured tables found
- **No LibreOffice**: Eliminate all external dependencies

### **LLM Integration**
- **Model**: AWS Bedrock with Claude 3.7 Sonnet
- **API**: Converse API for modern chat-based interactions
- **Analysis**: Individual table analysis for loss register identification
- **Token Management**: Efficient sampling to stay within 200k token limit

### **Data Sampling Strategy**
- **Header Rows**: Always included in samples
- **Data Rows**: Strategic sampling (20-50 rows) with full column coverage
- **Column Coverage**: All columns included, no artificial limits
- **Table-by-Table**: Sample each detected table individually

## **📊 OUTPUT REQUIREMENTS**

### **File Naming Convention**
- **Output Path**: Same logic as `analyzeRawSchemaCsv` function
- **File Names**: `{worksheet_name}_HEADERS.json`
- **Folder Structure**: `extracted-csv/{file_id}/{worksheet_name}_HEADERS.json`

### **Schema Output Format**
```json
{
  "worksheet_name": "string",
  "table_count": "number",
  "tables": [
    {
      "table_id": "string",
      "table_type": "loss_register|summary|pivot|other",
      "header_row_start": "number",
      "header_row_end": "number",
      "column_headers": ["col1", "col2", ...],
      "column_count": "number",
      "confidence": "0.0-1.0",
      "detection_method": "xlsx_listobject|xlsx_pivot|xlsx_named_range|xlsx_heuristic"
    }
  ]
}
```

## **🚀 DEPLOYMENT REQUIREMENTS**

### **CDK Stack Updates**
- **Stack**: Modify `JlLossRegisterApplicationStack` only
- **SQS Binding**: Remove binding from `analyze_raw_schema_csv`
- **New Binding**: Bind SQS to `detectRawSchema` function
- **Deployment Type**: Zip function with Lambda layer (no container)

### **Lambda Layer Management**
- **Dependencies**: openpyxl, fastjsonschema
- **Size**: ~50MB compressed (XLSX-only support)
- **Integration**: Ensure layer works with main function

### **Deployment Commands**
```bash
# Always use --require-approval never for automated deployment
cdk deploy Dev/JlLossRegisterApplicationStack --require-approval never

# No container deployment required - pure Python implementation
```

## **🔐 PERMISSION REQUIREMENTS**

### **Lambda Function Permissions**
- **S3 Access**: Read from raw data, write to extracted-csv
- **SQS Access**: Consume messages and send responses
- **Bedrock Access**: Invoke Claude 3.7 Sonnet model
- **DynamoDB Access**: Read/write metadata and processing history

### **Service Integration Permissions**
- **EventSourceMapping**: Lambda needs SQS consume permissions
- **S3 Event Notifications**: Bucket needs Lambda invoke permissions
- **CloudWatch Logs**: Automatic logging for all Lambda functions

## **📈 PERFORMANCE REQUIREMENTS**

### **Processing Time Targets**
- **Small Files** (<1MB): 1-3 minutes
- **Medium Files** (1-10MB): 3-5 minutes
- **Large Files** (>10MB): 5-8 minutes

### **Resource Requirements**
- **Memory**: 512MB (sufficient for XLSX parsing)
- **CPU**: Efficient Python parsing with no external processes
- **Storage**: Temporary file cleanup and S3 optimization

## **🧪 TESTING REQUIREMENTS**

### **Test Data Requirements**
- **Primary Test File**: `docs/samples/sanitized_[C] -Treaty Year Loss Report Dec. 2024(SRS Sorted)V2.xlsx`
- **Simple Files**: Single table, basic structure
- **Complex Files**: Multiple tables, irregular layouts
- **Edge Cases**: Very large files, unusual formats
- **Real Data**: Actual loss register files from production

### **Validation Criteria**
- **Table Detection**: Verify all tables are identified
- **Column Coverage**: Ensure all columns are detected (36+ columns)
- **Loss Register Identification**: Validate LLM classification accuracy
- **Output Quality**: Verify schema extraction quality
- **Format Support**: Only XLSX files should be processed

## **🔍 ERROR HANDLING REQUIREMENTS**

### **XLSX Error Handling**
- **File Parsing Failures**: Graceful error reporting and complete failure
- **Table Detection Failures**: Log detection issues and continue processing
- **Memory Issues**: Handle large file processing with resource limits
- **Format Validation**: Fail completely for non-XLSX formats

### **LLM Error Handling**
- **API Failures**: Retry logic with exponential backoff
- **Token Limit Exceeded**: Reduce sampling and retry
- **Invalid Responses**: Validate JSON output and retry if needed

### **Data Processing Errors**
- **Invalid Table Boundaries**: Validate and correct boundary detection
- **Missing Headers**: Fallback to structural analysis
- **Sampling Failures**: Use alternative sampling strategies

## **📝 LOGGING AND MONITORING REQUIREMENTS**

### **Structured Logging**
```python
# Use Lambda Powertools for structured logging
logger.info("Processing worksheet", extra={
    "worksheet_name": sheet_name,
    "table_count": len(detected_tables),
    "processing_time": processing_time,
    "detection_method": "xlsx_parsing"
})
```

### **Custom Metrics**
- **Processing Time**: Track time per worksheet and table
- **Success Rate**: Monitor table detection and LLM analysis success
- **Error Rates**: Track different types of failures
- **Resource Usage**: Monitor memory and CPU usage

## **🔄 WORKFLOW REQUIREMENTS**

### **Complete Processing Pipeline**
1. **Excel File Upload**: S3 event triggers SQS message
2. **Format Validation**: Verify file is XLSX format
3. **XLSX Parsing**: Use openpyxl to parse file structure
4. **Table Detection**: Detect ListObjects, pivot tables, named ranges
5. **Data Sampling**: Strategic sampling with full column coverage
6. **LLM Analysis**: Loss register identification for each table
7. **Schema Extraction**: Extract headers and structure information
8. **Output Generation**: Create JSON schema files
9. **S3 Storage**: Store results in organized folder structure

### **Table Detection Workflow**
1. **XLSX Metadata Parsing**: Use openpyxl for ListObjects and structure
2. **XML Pivot Detection**: Parse XLSX XML for pivot table locations
3. **Named Range Analysis**: Identify tabular named ranges
4. **Heuristic Detection**: Fallback for free-form data blocks
5. **Data Sampling**: Create efficient samples for LLM analysis
6. **LLM Processing**: Analyze each table individually
7. **Result Aggregation**: Combine results into final output

## **📚 DEPENDENCIES AND PACKAGES**

### **Core Python Packages**
- **boto3**: AWS SDK for Python
- **aws-lambda-powertools**: Lambda utilities and logging
- **json**: JSON processing and serialization
- **os**: Operating system interface
- **tempfile**: Temporary file handling
- **zipfile**: XLSX XML parsing

### **XLSX Processing**
- **openpyxl**: Primary XLSX parsing library
- **fastjsonschema**: JSON schema validation
- **No LibreOffice**: Eliminated all external dependencies

### **LLM Integration**
- **AWS Bedrock**: Claude 3.7 Sonnet model access
- **Converse API**: Modern Bedrock API for chat-based interactions
- **Token Management**: Efficient token usage and limit handling

## **🚨 CRITICAL SUCCESS FACTORS**

### **Accuracy Requirements**
- **Table Detection**: 95%+ accuracy in identifying all tables
- **Column Coverage**: 100% column detection (no artificial limits)
- **Loss Register Identification**: Near-perfect classification accuracy
- **Output Quality**: Consistent schema extraction across different file types
- **Format Support**: Only XLSX files processed (fail completely for others)

### **Performance Requirements**
- **Processing Time**: Meet target processing times for different file sizes
- **Resource Usage**: Efficient use of Lambda resources
- **Scalability**: Handle increasing data volumes and complexity
- **Reliability**: Consistent processing success across different XLSX file types

## **📋 IMPLEMENTATION CHECKLIST**

### **Phase 1: Lambda Function Creation**
- [ ] Create new `detectRawSchema` Lambda function
- [ ] Integrate openpyxl for XLSX parsing
- [ ] Implement ListObjects detection
- [ ] Implement pivot table XML parsing
- [ ] Implement named range detection
- [ ] Implement heuristic free-form detection
- [ ] Implement strategic data sampling with full column coverage
- [ ] Integrate Claude 3.7 Sonnet for loss register identification
- [ ] Implement error handling and logging

### **Phase 2: CDK Stack Updates**
- [ ] Modify `JlLossRegisterApplicationStack` for new function
- [ ] Remove SQS binding from `analyze_raw_schema_csv`
- [ ] Bind SQS to `detectRawSchema` function
- [ ] Ensure Lambda layer integration works correctly

### **Phase 3: Deployment and Testing**
- [ ] Deploy via CDK with `--require-approval never`
- [ ] Test with XLSX files only
- [ ] Verify non-XLSX files fail completely
- [ ] Test with various XLSX file types and complexities
- [ ] Validate table detection and schema extraction accuracy
- [ ] Test with primary sample file: Treaty Year Loss Report

## **🔒 FORMAT SUPPORT MATRIX**

| Format | Support | Detection Method | Notes |
|--------|---------|------------------|-------|
| XLSX   | ✅ Full | ListObjects + Pivot + Named Ranges + Heuristic | Primary format with full metadata |
| XLS    | ❌ None | Fail completely | Legacy format not supported |
| XLSB   | ❌ None | Fail completely | Binary format not supported |
| ODS    | ❌ None | Fail completely | LibreOffice format not supported |

## **💡 KEY ADVANTAGES OF XLSX-ONLY APPROACH**

1. **No External Dependencies**: Pure Python implementation
2. **Better Performance**: No external process overhead
3. **Easier Maintenance**: Standard Python libraries
4. **Rich Metadata**: Full access to Excel's table definitions
5. **Consistent Results**: XLSX format provides reliable structure
6. **Lambda Optimized**: Designed for serverless environment

---

**Last Updated**: 2025-01-27
**Current Focus**: XLSX-Only Implementation Requirements
**Next Update**: After Lambda function implementation and testing
