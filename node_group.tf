resource "aws_eks_node_group" "workers" {
  for_each = local.node_groups_expanded

  node_group_name        = lookup(each.value, "name", null)
  node_group_name_prefix = lookup(each.value, "name", null) == null ? "${var.cluster_name}-${each.key}" : null

  cluster_name         = aws_eks_cluster.this.id
  node_role_arn        = aws_iam_role.workers.arn
  subnet_ids           = module.vpc.private_subnets
  ami_type             = lookup(each.value, "ami_type", null)
  disk_size            = lookup(each.value, "disk_size", null)
  instance_types       = lookup(each.value, "instance_types", null)
  release_version      = lookup(each.value, "ami_release_version", null)
  capacity_type        = lookup(each.value, "capacity_type", null)
  force_update_version = lookup(each.value, "force_update_version", null)
  labels               = lookup(var.node_groups[each.key], "k8s_labels", {})
  tags                 = var.tags

  scaling_config {
    desired_size = each.value["desired_capacity"]
    max_size     = each.value["max_capacity"]
    min_size     = each.value["min_capacity"]
  }

  dynamic "taint" {
    for_each = lookup(each.value, "taints", null) != null ? each.value["taints"] : []

    content {
      key    = taint.value["key"]
      value  = taint.value["value"]
      effect = taint.value["effect"]
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_autoscaling_schedule" "this" {
  for_each = var.node_groups_schedule

  scheduled_action_name  = each.key
  min_size               = lookup(each.value, "min_size", null)
  max_size               = lookup(each.value, "max_size", null)
  desired_capacity       = lookup(each.value, "desired_capacity", null)
  start_time             = lookup(each.value, "start_time", null)
  end_time               = lookup(each.value, "end_time", null)
  recurrence             = lookup(each.value, "recurrence", null)
  autoscaling_group_name = aws_eks_node_group.workers[lookup(each.value, "node_group_name", null)].resources[0].autoscaling_groups[0].name
}
