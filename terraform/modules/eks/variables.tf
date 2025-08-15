variable "vpc_id" {
  type = string

}

variable "private_subnet_ids" {
  type = list(string)

}

variable "cluster_role_arn" {
  type = string

}

variable "node_role_arn" {
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