module "networking" {
  source = "./modules/networking"
}

module "iam" {
    source = "./modules/iam"
  
}

module "eks" {
    source = "./modules/eks"
    vpc_id = module.networking.vpc_id
    private_subnet_ids = module.networking.private_subnet
}