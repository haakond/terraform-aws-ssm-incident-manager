terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.53.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.2.0"
    }
  }
}