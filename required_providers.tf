terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.51.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.1.0"
    }
  }
}