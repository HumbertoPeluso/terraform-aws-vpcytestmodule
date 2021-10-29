# Release Notes

## Version 1.3.0 - 2020-08-02

Features:

- Adicionado criação do kubeconfig.

## Version 1.2.0 - 2020-07-30

Features:

- Adicionado configuração de schedule action para o auto scaling group do Node Group.

## Version 1.1.1 - 2020-07-20

Features:

- Adicionado pipeline para upload do módulo para o registry do Gitlab.

## Version v1.1.0 - 2020-07-19

Features:

- Adicionado dependência de um submódulo para provisionar a VPC utilizada pelo cluster.

## Version v1.0.2 - 2020-07-19

Features:

- Adicionado configuração do cloudwatch para retenção de logs do cluster.
- Adicionado novas configurações aos node groups, sendo elas:
  - tags;
  - labels do kubernetes;
  - taints do kubernetes;
  - tipo do AMI;
  - tamanho do disco;
  - tipo da instância;
  - versão do AMI;
  - capaciade da instância (`ON_DEMAND` ou `SPOT`);
  - forçar atualização das instâncias.

Ajustes:

- Removido templates que não estavam sendo utilizados.

## Version v1.0.1 - 2020-07-18

Features:

- Adicionado 2 novos outputs:
  - `cluster_certificate_authority_data`: Certificate Authority Data do cluster Kubernetes. O certificado é codificado em base64 que é necessário para comunicação com o cluster.
  - `cluster_endpoint`: Endpoint da API do cluster Kubernetes.

Ajustes:

- Alterado nome do recurso `aws_eks_cluster` de `cluster` para `this`.
- Removido recursos do tipo data source que não estavam sendo utilizados.

## Version v1.0.0 - 2020-07-18

Release inicial do módulo.
