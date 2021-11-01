output "cluster_certificate_authority_data" {
  description = "Certificate Authority Data do cluster Kubernetes. O certificado é codificado em base64 que é necessário para comunicação com o cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_endpoint" {
  description = "Endpoint da API do cluster Kubernetes."
  value       = aws_eks_cluster.this.endpoint
}

output "kubeconfig" {
  description = "kubectl config file contents for this EKS cluster. Will block on cluster creation until the cluster is really ready."
  value       = local.kubeconfig

  # So that calling plans wait for the cluster to be available before attempting to use it.
  # There is no need to duplicate this datasource
  depends_on = [data.http.wait_for_cluster]
}

output "kubeconfig_filename" {
  description = "The filename of the generated kubectl config. Will block on cluster creation until the cluster is really ready."
  value       = concat(local_file.kubeconfig.*.filename, [""])[0]

  # So that calling plans wait for the cluster to be available before attempting to use it.
  # There is no need to duplicate this datasource
  depends_on = [data.http.wait_for_cluster]
}