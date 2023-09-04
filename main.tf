
module "network_vpc" {
  source = "github.com/chandra5141/tf-module-vpc.git"
  env= var.env

  for_each   = var.vpc
  cidr_block = each.value.cidr_block
  public_subnets_cidr = each.value.public_subnets_cidr
  private_subnets_cidr = each.value.private_subnets_cidr

  default_vpc_id = var.default_vpc_id
}