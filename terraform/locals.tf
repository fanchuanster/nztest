locals {
  public_subnet_cidr  = cidrsubnet(var.vpc_cidr, 8, 0)
  private_subnet_cidr = cidrsubnet(var.vpc_cidr, 8, 1)
}