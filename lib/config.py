# Project Configuration
# Change this value to rename the entire project for reuse as a template

PROJECT_NAME = "incident-extractor"

# AWS Account Configuration
# Change these values for different AWS accounts per stage

AWS_ACCOUNTS = {
    "dev": "750389970429",
    "staging": "750389970429",
    "prod": ""  # To be provided later
}

# Environment-specific configurations
ENVIRONMENT_CONFIGS = {
    'dev': {
        'retention_days': 7,
        'public_access_blocked': False,
        'timeout_seconds': 30,
        'memory_size': 256,
        'max_receive_count': 1
    },
    'staging': {
        'retention_days': 30,
        'public_access_blocked': True,
        'timeout_seconds': 60,
        'memory_size': 512,
        'max_receive_count': 2
    },
    'prod': {
        'retention_days': 365,
        'public_access_blocked': True,
        'timeout_seconds': 300,
        'memory_size': 1024,
        'max_receive_count': 3
    }
}