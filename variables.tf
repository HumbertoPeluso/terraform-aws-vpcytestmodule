# General
variable "tags" {
  description = "Um mapa de tags para ser adicionada em todos os recursos."
  type        = map(string)
  default     = {}
}

# VPC
variable "cidr_block" {
  description = "Bloco CIDR do VPC."
  type        = string
}
variable "public_subnets" {
  description = "Lista de subnets públicas criadas na VPC."
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de subnets privadas criadas na VPC."
  type        = list(string)
}

# Cluster
variable "cluster_name" {
  description = "Nome do cluster EKS. Utilizado como prefixo no nome de alguns recursos relacionados."
  type        = string
}

variable "cluster_version" {
  description = "Versão do Kubernetes para o cluster EKS."
  type        = string
}

variable "cluster_enabled_log_types" {
  description = "Lista de logs do control plane que deseja habilitar. Para mais informações, acesse a documentação do Amazon EKS Control Plane Logging (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)."
  type        = list(string)
  default     = []
}

variable "cluster_log_retention_in_days" {
  description = "Tempo de vida dos logs definido em dias."
  type        = number
  default     = 90
}

variable "cluster_endpoint_private_access" {
  description = "Indica se o endpoint privado da API do Amazon EKS está habilitado."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indica se o endpoint público da API do Amazon EKS está habilitado. Quando atribuído `false`, certifique-se de ter um acesso privado adequado com o `cluster_endpoint_private_access = true`."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_service_ipv4_cidr" {
  description = "Bloco CIDR que deve ser atribuído ao endereço IP do serviço do Kubernetes. Se você não for especificado um bloco, o Kubernetes atribuirá endereços dos blocos CIDR `10.100.0.0/16` ou `172.20.0.0/16`."
  type        = string
  default     = null
}

variable "cluster_create_timeout" {
  description = "Timeout da criação do cluster EKS."
  type        = string
  default     = "30m"
}

variable "cluster_delete_timeout" {
  description = "Timeout da destruição do cluster EKS."
  type        = string
  default     = "15m"
}

# Node Groups
variable "node_groups" {
  description = "Map de maps para criação dos node groups. Exemplo: `node_groups = { example = { ... } }`."
  type        = any
  default     = {}
}

variable "node_groups_schedule" {
  description = "Map de maps para criação de schedule actions nos node groups."
  type        = any
  default     = {}
}

# Security Group
variable "cluster_egress_cidrs" {
  description = "Lista de blocos CIDRs permitidos no tráfego de saída do cluster."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# IAM
variable "iam_cluster_role_name" {
  description = "Nome da role utilizada pelo cluster EKS."
  type        = string
  default     = ""
}

variable "iam_workers_role_name" {
  description = "Nome da role utilizada pelos Nodde Groups do cluster EKS."
  type        = string
  default     = ""
}

# Kubeconfig
variable "create_kubeconfig" {
  description = "Se `true` o arquivo kubeconfig será criado."
  type        = bool
  default     = true
}
