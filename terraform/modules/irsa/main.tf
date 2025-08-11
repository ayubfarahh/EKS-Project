data "aws_eks_cluster" "cluster" {
    name = "eks-project"
}

data "aws_eks_cluster_auth" "token" {
    name = data.aws_eks_cluster.cluster.name
  
}

# Get thumbprint for the OIDC issuer
data "tls_certificate" "eks_oidc" {
    url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  
}

resource "aws_iam_openid_connect_provider" "eks" {
    url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
  
}

module "cert_manager" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
    version = "5.59.0"

    role_name = "cert-manager"
    attach_cert_manager_policy = true

    cert_manager_hosted_zone_arns = [
        "arn:aws:route53:::hostedzone/Z07838221XGZNVDC50BH8"
    ]

    oidc_providers = {
        eks = {
            provider_arn = aws_iam_openid_connect_provider.eks.arn
            namespace_service_accounts = ["cert-manager:cert-manager"]
        }
    }  
}

module "external_dns" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
    version = "5.59.0"

    role_name = "external-dns"
    attach_external_dns_policy = true

    external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z07838221XGZNVDC50BH8"]

    oidc_providers = {
        eks = {
            provider_arn = aws_iam_openid_connect_provider.eks.arn
            namespace_service_accounts = ["external-dns:external-dns"]
        }
    }
  
}

output "cert_manager" {
    value = module.cert_manager.iam_role_arn
  
}

output "external_dns" {
    value = module.external_dns.iam_role_arn
  
}

