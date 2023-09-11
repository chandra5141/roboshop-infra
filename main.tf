
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
  engine_version            = each.value.engine_version
  subnet_ids                = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null),"private_subnet_ids", null), each.value.subnets_name,null), "subnet_ids", null)
  vpc_id                    = lookup(lookup(module.network_vpc,each.value.vpc_name, null), "vpc_id", null)
  allow_cidr                = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null),"private_subnets", null), "app",null), "cidr_block", null)
  no_of_instance_docdb      = each.value.no_of_instance_docdb
  instance_class            = each.value.instance_class

}

module "rds" {
  source                    = "github.com/chandra5141/tf-module-rds.git"
  env                       = var.env

  for_each                  = var.rds
  engine_version            = each.value.engine_version
  engine                    = each.value.engine
  no_of_instance_rds        = each.value.no_of_instance_docdb
  instance_class            = each.value.instance_class

  subnet_ids                = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null),"private_subnet_ids", null), each.value.subnets_name,null), "subnet_ids", null)
  vpc_id                    = lookup(lookup(module.network_vpc,each.value.vpc_name, null), "vpc_id", null)
  allow_cidr                = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null),"private_subnets", null), "app",null), "cidr_block", null)


}

module "elasticache" {
  source                    = "github.com/chandra5141/tf-module-elasticache.git"
  env                       = var.env

  for_each                  = var.elasticache
  node_type                 = each.value.node_type
  replicas_per_node_group   = each.value.replicas_per_node_group
  num_node_groups           = each.value.num_node_groups

  subnet_ids                = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null),"private_subnet_ids", null), each.value.subnets_name,null), "subnet_ids", null)
  vpc_id                    = lookup(lookup(module.network_vpc,each.value.vpc_name, null), "vpc_id", null)
  allow_cidr                = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null),"private_subnets", null), "app",null), "cidr_block", null)

}
output "vpc" {
  value = module.network_vpc
}

