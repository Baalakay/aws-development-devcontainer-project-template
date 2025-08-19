# Bedrock Service Lambda Layer

This Lambda layer provides the Bedrock service for LLM vision analysis integration.

## Contents

- `bedrock_service/` - The main service module
  - `__init__.py` - Module initialization
  - `client.py` - Bedrock client implementation
  - `config.py` - Configuration management
  - `prompts.py` - LLM prompt templates

## Dependencies

See `requirements.txt` for the required Python packages.

## Usage

Lambda functions can import and use the Bedrock service:

```python
from bedrock_service.client import BedrockClient
from bedrock_service.config import BedrockConfig
```

## Installation

This layer is automatically installed when deploying the CDK stack.
