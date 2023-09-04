

module "network_vpc" {
  source = "github.com/chandra5141/tf-module-vpc.git"
  env= var.env

  for_each   = var.vpc
  cidr_block = each.value.cidr_block
  subnets_cidr = each.value.subnets_cidr
}