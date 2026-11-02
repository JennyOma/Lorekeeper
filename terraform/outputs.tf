
# LoreKeeper - AWS Provider Configuration

terraform {
  required_version = ">= 1.16.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# AWS provider configuration
provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      Project     = "LoreKeeper"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}
