terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-resumeexample" # The name of your S3 bucket
    key            = "path/to/terraform.tfstate"               # Path to the state file in the S3 bucket
    region         = "us-east-1"                               # AWS region
    dynamodb_table = "terraform-lock-table"                    # DynamoDB table for state locking
    encrypt        = true                                      # Enable encryption for the state file
  }
}
