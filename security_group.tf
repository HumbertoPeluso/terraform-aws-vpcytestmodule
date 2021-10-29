# Cluster
resource "aws_security_group" "cluster" {
  name_prefix = var.cluster_name
  description = "EKS cluster security group."
  vpc_id      = module.vpc.vpc_id

  tags = merge(var.tags, {
    "Name"                                      = "${var.cluster_name}-eks-cluster-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  })
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  description       = "Allow cluster egress access to the Internet."
  protocol          = "-1"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = var.cluster_egress_cidrs
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "cluster_https_worker_ingress" {
  description       = "Allow workstation to communicate with the EKS cluster API."
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = var.cluster_endpoint_public_access_cidrs
  from_port         = 443
  to_port           = 443
  type              = "ingress"
}
