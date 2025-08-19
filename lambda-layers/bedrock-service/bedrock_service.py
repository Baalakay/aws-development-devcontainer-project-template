import boto3
import json
from typing import Dict, Any, Optional

class BedrockService:
    """
    Service class for AWS Bedrock operations.
    """
    
    def __init__(self, region_name: str = 'us-east-1'):
        """
        Initialize Bedrock service.
        
        Args:
            region_name: AWS region for Bedrock service
        """
        self.bedrock_runtime = boto3.client(
            service_name='bedrock-runtime',
            region_name=region_name
        )
        
    def invoke_converse_api(self, 
                           model_id: str, 
                           messages: list, 
                           system_prompt: Optional[str] = None) -> Dict[str, Any]:
        """
        Invoke Bedrock Converse API.
        
        Args:
            model_id: Bedrock model ID (e.g., us.anthropic.claude-3-7-sonnet-20250219-v1:0)
            messages: List of conversation messages
            system_prompt: Optional system prompt
            
        Returns:
            Response from Bedrock Converse API
        """
        try:
            # Prepare system prompts in correct format for Converse API
            system_prompts = None
            if system_prompt:
                system_prompts = [{"text": system_prompt}]
                
            # Use Bedrock Converse API - NOT invoke_model
            # Based on AWS documentation: https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference-examples.html
            response = self.bedrock_runtime.converse(
                modelId=model_id,
                messages=messages,
                system=system_prompts
            )
            
            return response
            
        except Exception as e:
            print(f"Error invoking Bedrock Converse API: {str(e)}")
            raise
            
    def extract_incident_data(self, 
                             pdf_content: str, 
                             model_id: str = "us.anthropic.claude-3-7-sonnet-20250219-v1:0") -> Dict[str, Any]:
        """
        Extract incident data from PDF content using Bedrock.
        
        Args:
            pdf_content: Text content extracted from PDF
            model_id: Bedrock model to use
            
        Returns:
            Extracted incident data
        """
        system_prompt = """
        You are an expert at extracting structured incident data from text. 
        Extract the following information in JSON format:
        - incident_type
        - severity
        - date_time
        - location
        - description
        - involved_parties
        - actions_taken
        - recommendations
        """
        
        messages = [
            {
                "role": "user",
                "content": f"Please extract incident data from the following text:\n\n{pdf_content}"
            }
        ]
        
        response = self.invoke_converse_api(model_id, messages, system_prompt)
        return response
