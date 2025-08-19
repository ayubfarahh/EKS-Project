// NETWORKING

vpc_cidr                = "10.0.0.0/24"
public_subnet1_cidr     = "10.0.0.0/26"
public_subnet1_az       = "eu-west-2a"
map_public_ip_on_launch = true
public_subnet2_az       = "eu-west-2b"
public_subnet2_cidr     = "10.0.0.64/26"
private_subnet1_az      = "eu-west-2a"
private_subnet1_cidr    = "10.0.0.128/26"
private_subnet2_az      = "eu-west-2b"
private_subnet2_cidr    = "10.0.0.192/26"
eip_domain              = "vpc"
igw_cidr                = "0.0.0.0/0"

// EKS 

eks_cluster_sg_name = "eks-project-cluster-sg"
eks_cluster_sg_desc = "EKS control-plane SG"
eks_nodes_sg_name   = "eks-project-nodes-sg"
eks_nodes_sg_desc   = "EKS Nodes SG"
from_port           = 0
to_port             = 0
all_protocols       = "-1"
cidr_blocks         = ["0.0.0.0/0"]
sg_rule_type        = "ingress"
sg_rule_from_port   = 10250
sg_rule_to_port     = 10250
tcp_protocol        = "tcp"
sg_rule_description = "EKS control-plane to kubelet communication"
eks_cluster_name    = "eks-project"
eks_cluster_version = "1.30"
eks_node_name       = "workers"
instance_types      = ["t3.large"]
disk_size           = 20
desired_size        = 4
min_size            = 3
max_size            = 5

// IRSA

client_id_list                = ["sts.amazonaws.com"]
cert_manager_role_name        = "cert-manager"
cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z07838221XGZNVDC50BH8"]
cert_manager_namespace        = ["cert-manager:cert-manager"]
attach_cert_manager_policy    = true

attach_external_dns_policy    = true
external_dns_role_name        = "external-dns"
external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z07838221XGZNVDC50BH8"]
external_dns_namespace        = ["external-dns:external-dns"]