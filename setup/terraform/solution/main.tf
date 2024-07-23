# VPC Module
module "vpc" {
  source             = "./modules/vpc"
  public_az          = var.public_az
  private_az         = var.private_az
}
# EKS Module
module "eks" {
  source             = "./modules/eks"
  k8s_version        = var.k8s_version
  enable_private     = var.enable_private
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
}
