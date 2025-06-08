provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = local.public_subnet_cidr
  private_subnet_cidr  = local.private_subnet_cidr
  availability_zone    = var.availability_zone
}

module "ec2" {
  source              = "./modules/ec2"
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.private_subnet_id
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
}