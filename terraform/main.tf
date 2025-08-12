module "networking" {
  source = "./modules/networking"
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
}

module "helm" {
  source                     = "./modules/helm"
  cert_manager_irsa_role_arn = module.irsa.cert_manager_irsa_role_arn
  external_dns_irsa_role_arn = module.irsa.external_dns_irsa_role_arn
}

module "irsa" {
  source = "./modules/irsa"

}