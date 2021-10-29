provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_cluster_role_binding" "root" {
  metadata {
    name = "${var.cluster_name}-root-access"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${var.cluster_name}-root"
    api_group = ""
  }

  depends_on = [
    data.http.wait_for_cluster
  ]
}

resource "kubernetes_service_account" "root" {
  metadata {
    name = "${var.cluster_name}-root"
  }

  depends_on = [
    data.http.wait_for_cluster
  ]
}

resource "kubernetes_secret" "root" {
  metadata {
    name = "${var.cluster_name}-root"
    annotations = {
      "kubernetes.io/service-account.name" = "${var.cluster_name}-root"
    }
  }
  type = "kubernetes.io/service-account-token"

  depends_on = [
    data.http.wait_for_cluster
  ]
}
