terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}


data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  client_id_list  = var.client_id_list
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]

}

module "cert_manager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.59.0"

  role_name                  = var.cert_manager_role_name
  attach_cert_manager_policy = true

  cert_manager_hosted_zone_arns = var.cert_manager_hosted_zone_arns

  oidc_providers = {
    eks = {
      provider_arn               = aws_iam_openid_connect_provider.eks.arn
      namespace_service_accounts = var.cert_manager_namespace
    }
  }
}

module "external_dns" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.59.0"

  role_name                  = var.external_dns_role_name
  attach_external_dns_policy = true

  external_dns_hosted_zone_arns = var.external_dns_hosted_zone_arns

  oidc_providers = {
    eks = {
      provider_arn               = aws_iam_openid_connect_provider.eks.arn
      namespace_service_accounts = var.external_dns_namespace
    }
  }

}

output "cert_manager" {
  value = module.cert_manager.iam_role_arn

}

output "external_dns" {
  value = module.external_dns.iam_role_arn

}

