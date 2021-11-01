module "kubeconfig" {
  source  = "HumbertoPeluso/terraform-aws-kubeconfig"
  version = "~> 1.0.0"

  endpoint               = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = aws_eks_cluster.this.certificate_authority[0].data
  token                  = kubernetes_secret.root.data.token
  create_kubeconfig      = var.create_kubeconfig
  kubeconfig_name        = "${var.cluster_name}-root"
}