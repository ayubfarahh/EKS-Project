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
