provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source  = "gitlab.com/vkpr/terraform-aws-eks/aws"
  version = "~> 1.3.0"

  cluster_name    = "eks-example"
  cluster_version = "1.20"
  cidr            = "10.50.0.0/16"
  private_subnets = ["10.50.1.0/24", "10.50.2.0/24", "10.50.3.0/24"]
  public_subnets  = ["10.50.4.0/24", "10.50.5.0/24", "10.50.6.0/24"]

  node_groups = {
    example = {
      desired_capacity = 1
      max_capacity     = 5
      min_capacity     = 1
      instance_types   = ["t3.small"]
    }
  }

  tags = {
    Project     = "example"
    Environment = "dev"
  }
}
