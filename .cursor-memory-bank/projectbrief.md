# Johnson Lambert Loss Register Data Processing - Project Brief

## Project Overview
A comprehensive AWS-based data processing pipeline for normalizing and standardizing loss register files from various sources into a unified format for Johnson Lambert's Business Audit Team (BAT).

## Core Requirements
- **Intelligent Excel Processing**: Use openpyxl for efficient XLSX parsing with intelligent header detection
- **LLM Analysis**: AWS Bedrock (Claude 3.7 Sonnet) acts as insurance claims analyst to identify loss register worksheets
- **Zero Fallback**: Strict design principle - fail completely if real data cannot be processed, no hardcoded values
- **Performance**: Process files in 20-120 seconds depending on data size and worksheet count
- **Output Organization**: Separate loss register data from supplemental data in organized S3 structure

## Current Architecture
- **Hybrid CDK**: Infrastructure stack (core resources) + Application stack (Lambda functions, SQS, layers)
- **Serverless Pipeline**: S3 → Lambda → SQS → Lambda → S3 Output
- **Environment Support**: Dev, Staging, Production with environment-specific configurations

## Key Capabilities
- **Intelligent Header Detection**: Advanced scoring with business terminology recognition
- **Phantom Column Filtering**: Automatic removal of empty columns from Excel merged cells
- **Efficient Processing**: XLSX to CSV conversion for large files to avoid timeouts
- **Minimal Metadata**: Only extracts necessary attributes (sheet_state, last_modified_by)
- **Parallel Processing**: Support for both XLSX and CSV processing paths

## Output Files
- **LLM_INPUT.json**: Headers and sample data for LLM analysis
- **LLM_OUTPUT.json**: LLM analysis results and confidence scores
- **SCHEMA.json**: Detailed column schema with metadata
- **CSV**: Extracted data in CSV format

## File Organization
- **Loss Register Data**: `s3://customer/filename/loss-register/`
- **Supplemental Data**: `s3://customer/filename/supplemental/`

## Success Criteria
- Process Excel files with multiple worksheets efficiently
- Correctly identify loss register vs supplemental worksheets
- Generate all required output files with proper structure
- Maintain performance under 2 minutes for complex files
- Zero hardcoded values or fallback data 