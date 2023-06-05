# configured aws provider with proper credentials
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.1.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # access_key = "your-iam-qccess-key"
  # secret_key = "your-iam-secret-key"
}


