module "networking" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr
  public_subnet1_cidr = var.public_subnet1_cidr
  public_subnet1_az = var.public_subnet1_az
  map_public_ip_on_launch = var.map_public_ip_on_launch
  public_subnet2_cidr = var.public_subnet2_cidr
  public_subnet2_az = var.public_subnet2_az
  private_subnet1_az = var.private_subnet1_az
  private_subnet1_cidr = var.private_subnet1_cidr
  private_subnet2_az = var.private_subnet2_az
  private_subnet2_cidr = var.private_subnet2_cidr
  igw_cidr = var.igw_cidr
  eip_domain = var.eip_domain
}

module "iam" {
  source = "./modules/iam"

}

module "eks" {
  source             = "./modules/eks"
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet

  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn = module.iam.node_role_arn
  eks_cluster_sg_name = var.eks_cluster_sg_name
  eks_cluster_sg_desc = var.eks_cluster_sg_desc
  eks_nodes_sg_name = var.eks_nodes_sg_name
  eks_nodes_sg_desc = var.eks_nodes_sg_desc
  from_port = var.from_port
  to_port = var.to_port
  all_protocols = var.all_protocols
  cidr_blocks = var.cidr_blocks
  sg_rule_type = var.sg_rule_type
  sg_rule_to_port = var.sg_rule_to_port
  sg_rule_from_port = var.sg_rule_from_port
  sg_rule_description = var.sg_rule_description
  tcp_protocol = var.tcp_protocol
  eks_cluster_name = var.eks_cluster_name
  eks_cluster_version = var.eks_cluster_version
  eks_node_name = var.eks_node_name
  instance_types = var.instance_types
  disk_size = var.disk_size
  desired_size = var.desired_size
  min_size = var.min_size
  max_size = var.max_size

}

module "irsa" {
  source = "./modules/irsa"
  depends_on = [module.eks]

}

module "helm" {
  source                     = "./modules/helm"
  depends_on_modules         = [module.irsa]
  cert_manager_irsa_role_arn = module.irsa.cert_manager_irsa_role_arn
  external_dns_irsa_role_arn = module.irsa.external_dns_irsa_role_arn
}
