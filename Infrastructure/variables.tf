# AWS Configuration
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region where resources will be created."
}

# DynamoDB Configuration
variable "dynamodb_table_name" {
  type        = string
  default     = "VisitorsTable"
  description = "Name of the DynamoDB table."
}

variable "gsi_name" {
  type        = string
  default     = "visitors_count"
  description = "Name of the Global Secondary Index."
}

variable "gsi_hash_key" {
  type        = string
  default     = "visitors"
  description = "Hash key for the Global Secondary Index."
}

# Lambda Configuration
variable "lambda_function_name" {
  type        = string
  default     = "VistorCounter"
  description = "Name of the Lambda function."
}

variable "lambda_code_file" {
  type        = string
  default     = "lambda_function.py"
  description = "Lambda function code file name."
}

# S3 Bucket Configuration
variable "s3_bucket_name" {
  type        = string
  default     = "prudhvikeshav-cloudresume.info"
  description = "S3 bucket name for static website hosting."
}

# IAM Role and Policy Configuration
variable "aws_iam_role" {
  type        = string
  default     = "aws_resume_lambda_role"
  description = "IAM role for the Lambda function."
}

variable "aws_iam_policy" {
  type        = string
  default     = "iam_policy_for_aws_resume_lambda_role"
  description = "IAM policy attached to the Lambda role."
}

# API Gateway Configuration
variable "api_gateway_name" {
  type        = string
  default     = "visitor_counter_http_api"
  description = "Name of the API Gateway."
}
