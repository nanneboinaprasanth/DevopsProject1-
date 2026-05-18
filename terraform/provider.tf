terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = "DevOps"
      CreatedBy   = "Terraform"
    }
  )
}