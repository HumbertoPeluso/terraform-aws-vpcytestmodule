output "cluster_certificate_authority_data" {
  description = "Certificate Authority Data do cluster Kubernetes. O certificado é codificado em base64 que é necessário para comunicação com o cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_endpoint" {
  description = "Endpoint da API do cluster Kubernetes."
  value       = aws_eks_cluster.this.endpoint
}
