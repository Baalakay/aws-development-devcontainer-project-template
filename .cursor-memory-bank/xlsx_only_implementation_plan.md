# XLSX-Only Implementation Plan - Loss Register Project

## **🎯 EXECUTIVE SUMMARY**

This document outlines the complete implementation plan for refactoring the `detectRawSchema` Lambda function to use **XLSX-only Python parsing** instead of LibreOffice + LLM approach. The new approach eliminates all external dependencies, simplifies deployment, and provides more reliable table detection through direct XLSX metadata parsing.

## **🔄 ARCHITECTURE SHIFT**

### **From LibreOffice + LLM Approach:**
- ❌ Container-based Lambda with LibreOffice 7.6
- ❌ PyUNO integration for programmatic control
- ❌ Excel to ODS conversion for table detection
- ❌ External process dependencies and container management
- ❌ Complex deployment with Docker builds

### **To XLSX-Only Python Parsing:**
- ✅ Zip-based Lambda with Lambda layer
- ✅ Pure Python implementation using openpyxl
- ✅ Direct XLSX parsing for table detection
- ✅ No external dependencies or containers
- ✅ Simple deployment with CDK

## **🔧 TECHNICAL ARCHITECTURE**

### **Deployment Model**
```
Lambda Function (Zip):
├── Main Function: detectRawSchema
├── Dependencies: Lambda Layer
├── Memory: 512MB
├── Timeout: 5 minutes
└── Runtime: Python 3.12

Lambda Layer:
├── openpyxl: XLSX parsing and structure detection
├── fastjsonschema: JSON schema validation
└── Size: ~50MB compressed
```

### **Technology Stack**
- **Primary Library**: openpyxl (XLSX parsing)
- **Validation**: fastjsonschema (JSON schema validation)
- **AWS Integration**: boto3, aws-lambda-powertools
- **File Processing**: zipfile (XLSX XML parsing)
- **No External Dependencies**: Pure Python implementation

## **📊 FORMAT SUPPORT MATRIX**

| Format | Support | Detection Method | Implementation |
|--------|---------|------------------|----------------|
| XLSX   | ✅ Full | ListObjects + Pivot + Named Ranges + Heuristic | openpyxl + XML parsing |
| XLS    | ❌ None | Fail completely | RuntimeError with clear message |
| XLSB   | ❌ None | Fail completely | RuntimeError with clear message |
| ODS    | ❌ None | Fail completely | RuntimeError with clear message |

## **🔍 TABLE DETECTION STRATEGY**

### **1. ListObjects Detection (Primary)**
```python
def detect_listobjects_in_worksheet(worksheet, sheet_name: str) -> List[Dict[str, Any]]:
    """
    Detect Excel ListObjects (defined tables) in worksheet.
    These are the most authoritative table definitions.
    """
    tables = []
    
    try:
        # Access worksheet's defined tables
        if hasattr(worksheet, 'tables'):
            for table in worksheet.tables:
                table_data = {
                    'table_id': f"table_{sheet_name}_{hash(table.name)}",
                    'table_type': 'regular_table',
                    'start_row': table.ref.start.row,
                    'end_row': table.ref.end.row,
                    'start_col': table.ref.start.column,
                    'end_col': table.ref.end.column,
                    'detection_method': 'xlsx_listobject_detection',
                    'worksheet_name': sheet_name,
                    'table_name': table.name
                }
                tables.append(table_data)
        
        return tables
        
    except Exception as e:
        logger.error(f"Failed to detect ListObjects: {str(e)}")
        # NO FALLBACK - fail completely
        raise
```

### **2. Pivot Table Detection (XML Parsing)**
```python
def detect_pivot_tables_from_xml(sheet_name: str, xlsx_path: str) -> List[Dict[str, Any]]:
    """
    Detect pivot tables by parsing XLSX XML directly.
    """
    tables = []
    
    try:
        # Parse XLSX as ZIP to access XML
        with zipfile.ZipFile(xlsx_path, 'r') as xlsx_zip:
            # Look for pivot table definitions
            pivot_files = [f for f in xlsx_zip.namelist() if 'pivotTable' in f]
            
            for pivot_file in pivot_files:
                # Parse pivot table XML to extract location
                pivot_xml = xlsx_zip.read(pivot_file).decode('utf-8')
                pivot_data = parse_pivot_table_xml(pivot_xml, sheet_name)
                if pivot_data:
                    tables.append(pivot_data)
        
        return tables
        
    except Exception as e:
        logger.error(f"Failed to detect pivot tables: {str(e)}")
        # NO FALLBACK - fail completely
        raise
```

### **3. Named Range Detection**
```python
def detect_named_range_tables(sheet_name: str, xlsx_path: str) -> List[Dict[str, Any]]:
    """
    Detect named ranges that represent table structures.
    """
    tables = []
    
    try:
        with zipfile.ZipFile(xlsx_path, 'r') as xlsx_zip:
            # Parse workbook.xml to find named ranges
            workbook_xml = xlsx_zip.read('xl/workbook.xml').decode('utf-8')
            named_ranges = parse_named_ranges_xml(workbook_xml)
            
            for named_range in named_ranges:
                if is_tabular_named_range(named_range, sheet_name):
                    table_data = create_table_from_named_range(named_range, sheet_name)
                    tables.append(table_data)
        
        return tables
        
    except Exception as e:
        logger.error(f"Failed to detect named ranges: {str(e)}")
        # NO FALLBACK - fail completely
        raise
```

### **4. Free-form Data Block Detection (Heuristic)**
```python
def detect_freeform_data_blocks(worksheet, sheet_name: str) -> List[Dict[str, Any]]:
    """
    Detect free-form data blocks using heuristics.
    Only used when no structured tables are found.
    """
    tables = []
    
    try:
        # Find data boundaries using content analysis
        data_bounds = find_data_boundaries(worksheet)
        
        if data_bounds:
            table_data = {
                'table_id': f"table_{sheet_name}_{hash(sheet_name)}",
                'table_type': 'regular_table',
                'start_row': data_bounds['start_row'],
                'end_row': data_bounds['end_row'],
                'start_col': data_bounds['start_col'],
                'end_col': data_bounds['end_col'],
                'detection_method': 'xlsx_heuristic_detection',
                'worksheet_name': sheet_name
            }
            tables.append(table_data)
        
        return tables
        
    except Exception as e:
        logger.error(f"Failed to detect free-form data blocks: {str(e)}")
        # NO FALLBACK - fail completely
        raise
```

## **📝 OUTPUT STRUCTURE REQUIREMENTS**

### **Maintain Exact Structure**
The function must produce output that **exactly matches** the reference JSON files:
- `docs/output/sanitized_(A) Canadian Auto Los_LLM_INPUT.json`
- `docs/output/sanitized_(A) Canadian Auto Los_LLM_OUTPUT-4.json`
- `docs/output/sanitized_(A) Canadian Auto Los_SCHEMA-3.json`

### **No Structural Changes Allowed**
- **File names**: Must match exactly
- **Field names**: Must match exactly
- **Data types**: Must match exactly
- **Nesting structure**: Must match exactly
- **Only allowed changes**: Replace LibreOffice terms with XML/XLSX equivalents

## **🚀 IMPLEMENTATION PHASES**

### **Phase 1: Lambda Layer Creation**
1. **Create Dependencies Package**
   - Package openpyxl and fastjsonschema
   - Optimize size for Lambda limits
   - Test layer integration

2. **Deploy Layer**
   - Create via CDK or AWS CLI
   - Verify dependencies are accessible
   - Test with simple Lambda function

### **Phase 2: Function Refactoring**
1. **Remove LibreOffice Dependencies**
   - Delete all PyUNO imports and code
   - Remove LibreOffice CLI calls
   - Clean up container-specific logic

2. **Implement XLSX Parsing**
   - Add openpyxl integration
   - Implement ListObjects detection
   - Implement pivot table XML parsing
   - Implement named range detection
   - Implement heuristic detection

3. **Maintain Output Structure**
   - Keep exact same JSON structure
   - Replace LibreOffice metadata with XLSX metadata
   - Ensure all required fields are present

### **Phase 3: Format Validation**
1. **XLSX File Processing**
   - Test with various XLSX file types
   - Verify table detection accuracy
   - Validate output structure

2. **Non-XLSX File Rejection**
   - Test XLS files (should fail completely)
   - Test XLSB files (should fail completely)
   - Test ODS files (should fail completely)
   - Verify clear error messages

### **Phase 4: Testing & Validation**
1. **Primary Test File**
   - `docs/samples/sanitized_[C] -Treaty Year Loss Report Dec. 2024(SRS Sorted)V2.xlsx`
   - Verify multiple worksheet handling
   - Verify different table type detection
   - Verify multi-table worksheet processing

2. **Output Validation**
   - Compare with reference JSON files
   - Verify exact structure match
   - Validate LLM integration
   - Test end-to-end workflow

## **🔒 CRITICAL REQUIREMENTS**

### **No Hard Coding or Fallbacks**
- **Data Values**: Never use hardcoded sample data
- **Table Names**: Never use hardcoded table names
- **Worksheet Names**: Never use hardcoded worksheet names
- **Structure Indicators**: Never use hardcoded structure flags
- **Error Handling**: Fail completely with clear error messages

### **Format Restrictions**
- **XLSX Only**: Process only XLSX files
- **Fail Fast**: Reject non-XLSX formats immediately
- **Clear Messages**: Provide actionable error information
- **No Conversion**: Don't attempt format conversion

### **Performance Requirements**
- **Processing Time**: 1-8 minutes based on file size
- **Memory Usage**: Stay within 512MB limit
- **Lambda Optimization**: Designed for serverless environment
- **Efficient Parsing**: Use read-only and data-only modes

## **🧪 TESTING STRATEGY**

### **Test Data Requirements**
1. **Primary Test File**: Treaty Year Loss Report (most complex)
2. **Simple Files**: Single table, basic structure
3. **Complex Files**: Multiple tables, irregular layouts
4. **Edge Cases**: Very large files, unusual formats

### **Validation Criteria**
1. **Table Detection**: 95%+ accuracy in identifying all tables
2. **Column Coverage**: 100% column detection (no artificial limits)
3. **Output Structure**: Exact match with reference JSON files
4. **Format Support**: Only XLSX files processed
5. **Error Handling**: Clear failure messages for unsupported formats

### **Success Metrics**
- **Functionality**: All tables detected and processed
- **Performance**: Meets processing time targets
- **Reliability**: Consistent results across different file types
- **Maintainability**: Clean, documented code

## **📋 IMPLEMENTATION CHECKLIST**

### **Phase 1: Setup & Dependencies**
- [ ] Create Lambda layer with openpyxl and fastjsonschema
- [ ] Deploy layer and verify integration
- [ ] Update CDK stack for new layer
- [ ] Test layer accessibility

### **Phase 2: Core Implementation**
- [ ] Remove all LibreOffice dependencies from detectRawSchema
- [ ] Implement XLSX format validation
- [ ] Implement ListObjects detection
- [ ] Implement pivot table XML parsing
- [ ] Implement named range detection
- [ ] Implement heuristic free-form detection
- [ ] Maintain exact output structure

### **Phase 3: Integration & Testing**
- [ ] Integrate with existing LLM workflow
- [ ] Test XLSX file processing
- [ ] Test non-XLSX file rejection
- [ ] Validate output structure
- [ ] Test with primary sample file

### **Phase 4: Deployment & Validation**
- [ ] Deploy updated function via CDK
- [ ] Test end-to-end workflow
- [ ] Validate performance metrics
- [ ] Document implementation details
- [ ] Update project documentation

## **💡 KEY ADVANTAGES**

### **Technical Benefits**
1. **No External Dependencies**: Pure Python implementation
2. **Better Performance**: No external process overhead
3. **Easier Maintenance**: Standard Python libraries
4. **Rich Metadata**: Full access to Excel's table definitions
5. **Consistent Results**: XLSX format provides reliable structure

### **Operational Benefits**
1. **Simplified Deployment**: No container build/deploy cycle
2. **Faster Updates**: Direct function updates via CDK
3. **Better Monitoring**: Standard Lambda CloudWatch integration
4. **Easier Debugging**: Python-native error handling
5. **Cost Optimization**: No container storage costs

### **Maintenance Benefits**
1. **Standard Libraries**: Well-documented Python packages
2. **Community Support**: Active openpyxl development
3. **Version Management**: Simple dependency updates
4. **Testing**: Standard Python testing frameworks
5. **Documentation**: Comprehensive openpyxl documentation

## **🚨 RISK MITIGATION**

### **Technical Risks**
1. **XLSX Complexity**: Handle large files and complex structures
   - **Mitigation**: Use read-only mode and streaming processing
2. **Memory Limits**: Stay within Lambda memory constraints
   - **Mitigation**: Process worksheets sequentially, close workbooks
3. **Performance**: Meet processing time requirements
   - **Mitigation**: Optimize parsing algorithms, use efficient data structures

### **Functional Risks**
1. **Table Detection Accuracy**: Ensure reliable detection
   - **Mitigation**: Multiple detection methods, comprehensive testing
2. **Output Structure**: Maintain exact JSON format
   - **Mitigation**: Strict validation, reference file comparison
3. **Format Support**: Handle only XLSX files
   - **Mitigation**: Early validation, clear error messages

## **📚 REFERENCES**

### **Primary Documentation**
- **openpyxl Documentation**: https://openpyxl.readthedocs.io/
- **AWS Lambda Documentation**: https://docs.aws.amazon.com/lambda/
- **Reference JSON Files**: `docs/output/` directory
- **Sample Data**: `docs/samples/` directory

### **Technical Standards**
- **JSON Schema**: Draft 2020-12 specification
- **XLSX Format**: ECMA-376 standard
- **Lambda Best Practices**: AWS Well-Architected Framework
- **Python Standards**: PEP 8 style guide

---

**Last Updated**: 2025-01-27
**Current Focus**: XLSX-Only Implementation Planning
**Next Update**: After Lambda function implementation and testing
**Document Owner**: Development Team
**Review Cycle**: Before each major implementation phase
