
module "network_vpc" {
  source          = "github.com/chandra5141/tf-module-vpc.git"
  env             = var.env

  for_each        = var.vpc
  cidr_block      = each.value.cidr_block
  default_vpc_id  = var.default_vpc_id
  public_subnets_ids     = lookup(lookup(module.subnets,"public",null), "subnet_ids",null)
}

module "subnets" {
  source                    = "github.com/chandra5141/tf-module-subnets.git"
  env                       = var.env
  default_vpc_id            = var.default_vpc_id


  for_each                  = var.subnets
  igw                       = module.network_vpc.igw
  cidr_block                = each.value.cidr_block
  availability_zone         = each.value.availablity_zone
  default_vpc_id            = var.default_vpc_id
  igw_id                    = module.network_vpc.igw_id

  name                      = each.value.name
  vpc_id                    = lookup(lookup(module.network_vpc,each.value.vpc_name.null),"vpc_id",null)
  vpc_peering_connection_id = lookup(lookup(module.network_vpc,each.value.vpc_name.null),"vpc_peering_connection_id",null)
  internet_gateway_id       = lookup(lookup(module.network_vpc,each.value.vpc_name.null),"internet_gateway_id",null)

}