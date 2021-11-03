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
  default = "10.50.0.0/16"
}
variable "public_subnets" {
  description = "Lista de subnets públicas criadas na VPC."
  type        = list(string)
  default = ["10.50.4.0/24", "10.50.5.0/24", "10.50.6.0/24"]
}

variable "private_subnets" {
  description = "Lista de subnets privadas criadas na VPC."
  type        = list(string)
  default = ["10.50.1.0/24", "10.50.2.0/24", "10.50.3.0/24"]
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

variable "create_eks" {
  description = "Controls if EKS resources should be created (it affects almost all resources)"
  type        = bool
  default     = true
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

variable "kubeconfig_output_path" {
  description = "Where to save the Kubectl config file (if `write_kubeconfig = true`). Assumed to be a directory if the value ends with a forward slash `/`."
  type        = string
  default     = "./"
}

variable "kubeconfig_file_permission" {
  description = "File permission of the Kubectl config file containing cluster configuration saved to `kubeconfig_output_path.`"
  type        = string
  default     = "0600"
}

variable "write_kubeconfig" {
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to `kubeconfig_output_path`."
  type        = bool
  default     = true
}

variable "kubeconfig_aws_authenticator_command" {
  description = "Command to use to fetch AWS EKS credentials."
  type        = string
  default     = "aws-iam-authenticator"
}

variable "kubeconfig_aws_authenticator_command_args" {
  description = "Default arguments passed to the authenticator command. Defaults to [token -i $cluster_name]."
  type        = list(string)
  default     = []
}

variable "kubeconfig_aws_authenticator_additional_args" {
  description = "Any additional arguments to pass to the authenticator such as the role to assume. e.g. [\"-r\", \"MyEksRole\"]."
  type        = list(string)
  default     = []
}

variable "kubeconfig_aws_authenticator_env_variables" {
  description = "Environment variables that should be used when executing the authenticator. e.g. { AWS_PROFILE = \"eks\"}."
  type        = map(string)
  default     = {}
}

variable "kubeconfig_name" {
  description = "Override the default name used for items kubeconfig."
  type        = string
  default     = ""
}

variable "cluster_endpoint_private_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS private API server endpoint. To use this `cluster_endpoint_private_access` and `cluster_create_endpoint_private_access_sg_rule` must be set to `true`."
  type        = list(string)
  default     = null
}

