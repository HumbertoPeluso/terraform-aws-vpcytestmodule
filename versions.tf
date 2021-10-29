terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.3.0"
    }
    http = {
      source  = "terraform-aws-modules/http"
      version = "~> 2.4.0"
    }
  }
}
