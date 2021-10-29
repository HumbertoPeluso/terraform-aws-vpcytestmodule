# Terrafom Module | AWS - Elastic Kubernetes Service

Módulo do Terraform para provisionamento na AWS do Elastic Kubernetes Service (EKS) e de todas suas dependências.

## :rocket: Como usar

Para utilizar o módulo é necessário gerar um [access token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) do GitLab e configurá-lo na máquina local ou pipeline para que o Terraform utilize. A seguinte configuração precisa ser criada em `~/.terraformrc`:

```hcl
credentials "gitlab.com" {
  token = "<GITLAB_ACCESS_TOKEN>"
}
```

### Permissões necessárias

Todas as permissões na AWS necessárias para provisionamento do EKS podem ser encontradas no arquivo [docs/policies.json](./docs/policies.json).

### Exemplo

O exemplo abaixo demonstra o mínimo de configuração necessária para o provisionamento do EKS.

```hcl
provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source  = "gitlab.com/vkpr/terraform-aws-eks/aws"
  version = "~> 1.3.0"

  cluster_name    = "eks-example"
  cluster_version = "1.20"
  cidr_block      = "10.50.0.0/16"
  private_subnets = ["10.50.1.0/24", "10.50.2.0/24", "10.50.3.0/24"]
  public_subnets  = ["10.50.4.0/24", "10.50.5.0/24", "10.50.6.0/24"]

  node_groups = {
    example = {
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.small"]
    }
  }

  tags = {
    Project     = "example"
    Environment = "dev"
  }
}
```

#### Outros exemplos

- [Exemplo básico](examples/basic)
- [Exemplo de node groups com uma configuração extensa](examples/node_group_extend)
- [Exemplo de configuração de schedule action no node group](examples/node_group_with_schedule)

### Providers
 
| Nome | Versão |
|------|--------|
| [aws](https://registry.terraform.io/providers/hashicorp/aws/3.50.0) | >= 3.50.0 |
| [local](https://registry.terraform.io/providers/hashicorp/local/2.1.0) | >= 2.1.0 |

### Modules

| Nome | Tipo | Versão |
|------|------|--------|
| vpc | [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.2.0) | >= 3.2.0 |

### Resources

| Nome | Tipo |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_autoscaling_schedule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_iam_instance_profile.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_egress_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cluster_https_worker_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

### Inputs

| Nome | Descrição | Tipo | Valor padrão | Obrigatório |
|------|-----------|------|--------------|-------------|
| cluster_name | Nome do cluster EKS. Utilizado como prefixo no nome de alguns recursos relacionados. | `string` | n/a | **Sim** |
| cluster_version | Versão do Kubernetes para o cluster EKS. | `string` | n/a | **Sim** |
| cidr_block | Bloco CIDR do VPC. | `string` | n/a | **Sim** |
| public_subnets | Lista de subnets públicas criadas na VPC. | `list(string)` | n/a | **Sim** |
| private_subnets | Lista de subnets privadas criadas na VPC. | `list(string)` | n/a | **Sim** |
| cluster_enabled_log_types | Lista de logs do control plane que deseja habilitar. Para mais informações, acesse a documentação do [Amazon EKS Control Plane Logging](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html). | `list(string)` | `[]` | Não |
| cluster_log_retention_in_days | Tempo de vida dos logs definido em dias. | `number` | `90` | Não |
| cluster_endpoint_private_access | Indica se o endpoint privado da API do Amazon EKS está habilitado. | `bool` | `false` | Não |
| cluster_endpoint_public_access | Indica se o endpoint público da API do Amazon EKS está habilitado. Quando atribuído `false`, certifique-se de ter um acesso privado adequado com o `cluster_endpoint_private_access = true`. | `bool` | `true` | Não |
| cluster_endpoint_public_access_cidrs | Lista de blocos CIDRs que podem acessar o endpoint público da API do Amazon EKS. | `list(string)` | `["0.0.0.0/0"]` | Não |
| cluster_service_ipv4_cidr | Bloco CIDR que deve ser atribuído ao endereço IP do serviço do Kubernetes. Se você não for especificado um bloco, o Kubernetes atribuirá endereços dos blocos CIDR `10.100.0.0/16` ou `172.20.0.0/16`. | `string` | `null` | Não |
| cluster_create_timeout | Timeout da criação do cluster EKS. | `string` | `"30m"` | Não |
| cluster_delete_timeout | Timeout da destruição do cluster EKS. | `string` | `"15m"` | Não |
| node_groups | Map de maps para criação dos node groups. Exemplo: `node_groups = { example = { ... } }`. | `any` | `{}` | Não |
| node_groups_schedule | Map de maps para criação de schedule actions nos node groups. | `any` | `{}` | Não |
| cluster_egress_cidrs | Lista de blocos CIDRs permitidos no tráfego de saída do cluster. | `list(string)` | `["0.0.0.0/0"]` | Não |
| iam_cluster_role_name | Nome da role utilizada pelo cluster EKS. | `string` | `""` | Não |
| iam_workers_role_name | Nome da role utilizada pelos Nodde Groups do cluster EKS. | `string` | `""` | Não |
| tags | Um mapa de tags para ser adicionada em todos os recursos. | `map(string)` | `{}` | Não |

### Outputs

| Nome | Descrição |
|------|-----------|
| cluster_certificate_authority_data | Certificate Authority Data do cluster Kubernetes. O certificado é codificado em base64 que é necessário para comunicação com o cluster. |
| cluster_endpoint | Endpoint da API do cluster Kubernetes. |

## :memo: Licença

[MIT](LICENSE)
