data "aws_availability_zones" "available" {}

data "aws_iam_policy_document" "cluster" {
  statement {
    sid     = "EKSClusterAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "workers" {
  statement {
    sid     = "EKSWorkerAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "http" "wait_for_cluster" {
  url            = format("%s/healthz", aws_eks_cluster.this.endpoint)
  ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
  timeout        = 300
}

data "aws_eks_cluster_auth" "cluster" {
  name  = aws_eks_cluster.this.name
}
