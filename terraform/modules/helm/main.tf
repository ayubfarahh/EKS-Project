data "aws_eks_cluster" "cluster" {
     name = "eks-project"
  
}
data "aws_eks_cluster_auth" "token" { 
    name = data.aws_eks_cluster.cluster.name
  
}

provider "helm" {
    kubernetes {
      host = data.aws_eks_cluster.cluster.endpoint
      cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
      token = data.aws_eks_cluster_auth.token.token
    }
  
}

resource "helm_release" "ingress_nginx" {
    name = "ingress-nginx"
    repository = "https://kubernetes.github.io/ingress-nginx"
    chart = "ingress-nginx"
    version = "4.10.0"
    namespace = "nginx-ingress"
    create_namespace = true
  
}

resource "helm_release" "cert_manager" {
    name = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart = "cert-manager"
    version = "v1.15.3"
    namespace = "cert-manager"
    create_namespace = true

    set { 
    name = "crds.enabled"; 
    value = "true" }
  
    set {
        name = "serviceAccount.annotations.ek\\.amazonaws\\.com/role-arn"
        value = var.cert_manager_irsa_role_arn
    }
}

re