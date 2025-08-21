terraform {
  required_version = "~> 1.12.2"

  backend "s3" {
    bucket  = "aws-auto-scaling-group-nickolas-corazza"   # criar bucket na etapa 4
    key     = "tfstate/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
