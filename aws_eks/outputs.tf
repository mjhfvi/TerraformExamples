locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.main_node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.main.endpoint}
    certificate-authority-data: ${aws_eks_cluster.main.certificate_authority[0].data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
KUBECONFIG
}

output "aws_config_map_aws_auth" {
  description = ""
  value       = local.config_map_aws_auth
}

output "aws_kubeconfig" {
  description = ""
  value       = local.kubeconfig
}

output "admin_iam_role_arn" {
  description = "ARN of admin IAM role"
  value       = aws_iam_role.main_cluster.arn
}

output "eks_cluster_endpoint" {
  description = "Cluster Endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "aws_region_availability_zones" {
  description = "AWS Region Availability Zones"
  value       = var.aws_region
}

output "aws_eks_cluster" {
  description = "AWS Region Availability Zones"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_connection" {
  description = "EKS Connection String to EKS Cluster"
  value       = <<CONFIG

aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}

Source: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html#eks-configure-kubectl


eksctl
Source: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html

## Troubleshooting ##
https://repost.aws/knowledge-center/eks-cluster-connection
    CONFIG
}
