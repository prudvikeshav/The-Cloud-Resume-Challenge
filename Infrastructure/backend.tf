terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-resumeexample"
    key            = "path/to/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
