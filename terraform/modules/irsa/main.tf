data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "token" {
  name = data.aws_eks_cluster.cluster.name

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
  source  = var.cert_manager_source
  version = var.cert_manager_version

  role_name                  = var.cerq
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
  source  = var.external_dns_source
  version = var.external_dns_version

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

