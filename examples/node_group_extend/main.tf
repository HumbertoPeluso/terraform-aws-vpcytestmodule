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
      desired_capacity     = 1
      max_capacity         = 3
      min_capacity         = 1
      instance_types       = ["t3.small"]
      ami_type             = "AL2_x86_64"
      disk_size            = 20
      capacity_type        = "ON_DEMAND"
      force_update_version = false
      k8s_labels = {
        Manage-by = "Terraform"
      }
      taints = [
        {
          key    = "dedicated"
          value  = "app"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }

  tags = {
    Project     = "example"
    Environment = "dev"
  }
}
