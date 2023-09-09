
module "network_vpc" {
  source                 = "github.com/chandra5141/tf-module-vpc.git"
  env                    = var.env
  default_vpc_id         = var.default_vpc_id


  for_each               = var.vpc
  cidr_block             = each.value.cidr_block
  public_subnets         = each.value.public_subnets
  private_subnets        = each.value.private_subnets
  availability_zone      = each.value.availablity_zone

}


module "docdb" {
  source                    = "github.com/chandra5141/tf-module-docdb.git"
  env                       = var.env
  default_vpc_id            = var.default_vpc_id

}