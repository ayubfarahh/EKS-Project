variable "vpc_cidr" {
    type = string
  
}

variable "public_subnet1_cidr" {
    type = string
  
}

variable "public_subnet1_az" {
    type = string
  
}

variable "map_public_ip_on_launch" {
    type = bool
  
}

variable "public_subnet2_cidr" {
    type = string
  
}

variable "public_subnet2_az" {
    type = string
}


variable "private_subnet1_cidr" {
    type = string
  
}

variable "private_subnet1_az" {
    type = string
  
}

variable "private_subnet2_cidr" {
    type = string
  
}

variable "private_subnet2_az" {
  type = string
}

variable "igw_cidr" {
    type = string
  
}

variable "eip_domain" {
    type = string
  
}


variable "eks_cluster_sg_name" {
  type = string
}

variable "eks_cluster_sg_desc" {
  type = string
  
}

variable "eks_nodes_sg_name" {
  type = string
  
}

variable "eks_nodes_sg_desc" {
  type = string
  
}

variable "from_port" {
  type = number
  
}

variable "to_port" {
  type = number
  
}

variable "all_protocols" {
  type = string
}

variable "cidr_blocks" {
  type = list(string)
  
}

variable "sg_rule_type" {
  type = string
  
}

variable "sg_rule_from_port" {
  type = number
  
}

variable "sg_rule_to_port" {
  type = number
  
}

variable "tcp_protocol" {
  type = string
  
}

variable "sg_rule_description" {
  type = string
}

variable "eks_cluster_name" {
  type = string
  
}

variable "eks_cluster_version" {
  type = string
  
}

variable "eks_node_name" {
  type = string
  
}

variable "instance_types" {
  type = list(string)
  
}

variable "disk_size" {
  type = number
  
}

variable "desired_size" {
  type = number
  
}

variable "min_size" {
  type = number
  
}

variable "max_size" {
  type = number
  
}

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

variable "depends_on_modules" {
  type    = list(any)
  default = []
}
