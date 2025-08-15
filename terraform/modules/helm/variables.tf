variable "cert_manager_irsa_role_arn" {
  type = string

}

variable "external_dns_irsa_role_arn" {
  type = string

}

variable "depends_on_modules" {
  type    = list(any)
  default = []
}

variable "eks_cluster_name" {
  type = string
  
}

variable "eks_cluster_endpoint" {
  type = string
}

variable "eks_cluster_ca_data" {
  type = string
}