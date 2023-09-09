
module "network_vpc" {
  source                 = "github.com/chandra5141/tf-module-vpc.git"
  env                    = var.env
  default_vpc_id         = var.default_vpc_id


  for_each               = var.vpc
  cidr_block             = each.value.cidr_block
  public_subnets         = each.value.public_subnets
  private_subnets        = each.value.private_subnets
  availability_zone      = each.value.availability_zone

}


module "docdb" {
  source                    = "github.com/chandra5141/tf-module-docdb.git"
  env                       = var.env

  for_each                  = var.docdb
  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null),"private_subnet_ids", null), each.value.subnets_name,null), "subnet_ids", null)

}

output "vpc" {
  value = module.network_vpc
}