provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source  = "HumbertoPeluso/terraform-aws-vpcytestmodule"
  version = "~> 1.3.0"

  cluster_name    = "eks-example"
  cluster_version = "1.20"
  cidr            = "10.50.0.0/16"
  private_subnets = ["10.50.1.0/24", "10.50.2.0/24", "10.50.3.0/24"]
  public_subnets  = ["10.50.4.0/24", "10.50.5.0/24", "10.50.6.0/24"]

  node_groups = {
    example = {
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.small"]
    }
  }

  node_groups_schedule = {
    example_at_the_sunrise = {
      node_group_name  = "example"
      min_size         = 1
      max_size         = 3
      desired_capacity = 1
      recurrence       = "0 11 * * 1-5"
      start_time       = "2021-08-02T08:00:00Z"
    },
    example_at_the_moonrise = {
      node_group_name  = "example"
      min_size         = 0
      max_size         = 0
      desired_capacity = 0
      recurrence       = "0 22 * * 1-5"
      start_time       = "2021-08-02T19:00:00Z"
    }
  }

  tags = {
    Project     = "example"
    Environment = "dev"
  }
}
