resource "aws_eks_cluster" "this" {
  name                      = var.cluster_name
  version                   = var.cluster_version
  enabled_cluster_log_types = var.cluster_enabled_log_types
  role_arn                  = aws_iam_role.cluster.arn
  tags                      = var.tags

  vpc_config {
    security_group_ids      = [aws_security_group.cluster.id]
    subnet_ids              = module.vpc.private_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  timeouts {
    create = var.cluster_create_timeout
    delete = var.cluster_delete_timeout
  }

  depends_on = [
    aws_security_group_rule.cluster_egress_internet,
    aws_security_group_rule.cluster_https_worker_ingress,
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    # aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.this
  ]
}

resource "aws_cloudwatch_log_group" "this" {
  count             = length(var.cluster_enabled_log_types) > 0 ? 1 : 0
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_in_days
  tags              = var.tags
}
