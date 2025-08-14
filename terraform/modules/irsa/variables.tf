variable "cluster_name" {
    type = string
  
}

variable "client_id_list" {
    type = list(string)
  
}

variable "cert_manager_source" {
    type = string
  
}

variable "cert_manager_version" {
    type = string
  
}

variable "cert_manager_role_name" {
    type = string
  
}

variable "attach_cert_manager_policy" {
    type = bool
  
}

variable "cert_manager_hosted_zone_arns" {
    type = list(string)
  
}

variable "cert_manager_namespace" {
    type = list(string)
  
}

variable "external_dns_source" {
    type = string
  
}

variable "external_dns_version" {
    type = string
  
}

variable "external_dns_role_name" {
    type = string
  
}

variable "attach_external_dns_policy" {
    type = bool
  
}

variable "external_dns_hosted_zone_arns" {
    type = list(string)
  
}

variable "external_dns_namespace" {
    type = list(string)
  
}