locals {
  # IAM
  iam_cluster_role_name        = var.iam_cluster_role_name != "" ? var.iam_cluster_role_name : null
  iam_cluster_role_name_prefix = var.iam_cluster_role_name != "" ? null : var.cluster_name
  iam_workers_role_name        = var.iam_workers_role_name != "" ? var.iam_workers_role_name : null
  iam_workers_role_name_prefix = var.iam_workers_role_name != "" ? null : var.cluster_name

  # Node groups
  node_groups_expanded = { for k, v in var.node_groups : k => merge(
    {
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 1
    }, v)
  }

kubeconfig = var.create_eks ? templatefile("${path.module}/templates/kubeconfig.tpl", {
    kubeconfig_name                   =  coalesce(var.kubeconfig_name, "eks_${var.cluster_name}")
    endpoint                          = local.cluster_endpoint
    cluster_auth_base64               = local.cluster_auth_base64
    aws_authenticator_command         = var.kubeconfig_aws_authenticator_command
    aws_authenticator_command_args    = coalescelist(var.kubeconfig_aws_authenticator_command_args, ["token", "-i", local.cluster_name])
    aws_authenticator_additional_args = var.kubeconfig_aws_authenticator_additional_args
    aws_authenticator_env_variables   = var.kubeconfig_aws_authenticator_env_variables
  }) : ""

}
