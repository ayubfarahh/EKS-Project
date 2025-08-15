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
