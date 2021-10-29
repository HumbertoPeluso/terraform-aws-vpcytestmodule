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
}
