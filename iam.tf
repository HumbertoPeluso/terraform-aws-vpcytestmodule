# Role master
resource "aws_iam_role" "cluster" {
  name                  = local.iam_cluster_role_name
  name_prefix           = local.iam_cluster_role_name_prefix
  assume_role_policy    = data.aws_iam_policy_document.cluster.json
  force_detach_policies = true
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#   role       = aws_iam_role.cluster.name
# }

# Role workers
resource "aws_iam_role" "workers" {
  name                  = local.iam_workers_role_name
  name_prefix           = local.iam_workers_role_name_prefix
  assume_role_policy    = data.aws_iam_policy_document.workers.json
  force_detach_policies = true
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_instance_profile" "workers" {
  name_prefix = aws_eks_cluster.this.name
  role        = aws_iam_role.workers.name
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
