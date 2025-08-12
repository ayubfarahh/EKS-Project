terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}


data "aws_eks_cluster" "cluster" {
  name = "eks-project"

}
data "aws_eks_cluster_auth" "token" {
  name = data.aws_eks_cluster.cluster.name

}

provider "helm" {
  kubernetes {
    config_path = pathexpand("~/.kube/config")
  }
}

resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.10.0"
  namespace        = "ingress-nginx"
  create_namespace = true

}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.15.3"
  namespace        = "cert-manager"
  create_namespace = true

  values = [
    yamlencode({
      crds = { enabled = true }
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = var.cert_manager_irsa_role_arn
        }
      }
    })
  ]
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  version          = "1.15.0"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true

   values = [
    yamlencode({
      provider   = "aws"
      policy     = "sync"
      aws        = { zoneType = "public" }
      txtOwnerId = "eks-project"
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = var.external_dns_irsa_role_arn
        }
      }
    })
  ]
}

