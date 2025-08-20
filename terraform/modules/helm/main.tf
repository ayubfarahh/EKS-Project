terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

provider "kubernetes" {
  host                   = var.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(var.eks_cluster_ca_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_ca_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_name
}


resource "helm_release" "ingress_nginx" {
  depends_on       = [var.depends_on_modules]
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.10.0"
  namespace        = "ingress-nginx"
  create_namespace = true

}

resource "helm_release" "cert_manager" {
  depends_on       = [var.depends_on_modules]
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
  depends_on       = [var.depends_on_modules]
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

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "56.6.0"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("${path.module}/../../helm-values/kube-prometheus-stack.yaml")
  ]


}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "oci://ghcr.io/argoproj/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.18"

  values = [file("${path.root}/kubernetes/argocd/values.yaml")]

}


