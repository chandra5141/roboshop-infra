
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

#module "docdb" {
#  source                    = "github.com/chandra5141/tf-module-docdb.git"
#  env                       = var.env
#
#  for_each                  = var.docdb
#  subnet_ids                = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null),"private_subnet_ids", null), each.value.subnets_name,null), "subnet_ids", null)
#  vpc_id                    = lookup(lookup(module.network_vpc,each.value.vpc_name, null), "vpc_id", null)
#  allow_cidr                = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null),"private_subnets", null), "app",null), "cidr_block", null)
#  engine_version            = each.value.engine_version
#  no_of_instance_docdb      = each.value.no_of_instance_docdb
#  instance_class            = each.value.instance_class
#
#}
#
#module "rds" {
#  source                    = "github.com/chandra5141/tf-module-rds.git"
#  env                       = var.env
#
#  for_each                  = var.rds
#  engine_version            = each.value.engine_version
#  engine                    = each.value.engine
#  no_of_instance_rds        = each.value.no_of_instance_rds
#  instance_class            = each.value.instance_class
#
#  subnet_ids                = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null),"private_subnet_ids", null), each.value.subnets_name,null), "subnet_ids", null)
#  vpc_id                    = lookup(lookup(module.network_vpc,each.value.vpc_name, null), "vpc_id", null)
#  allow_cidr                = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null),"private_subnets", null), "app",null), "cidr_block", null)
#
#
#}
#
#module "elasticache" {
#  source                    = "github.com/chandra5141/tf-module-elasticache.git"
#  env                       = var.env
#
#  for_each                  = var.elasticache
#  node_type                 = each.value.node_type
#  num_cache_nodes           =  each.value.num_cache_nodes
#  engine_version            = each.value.engine_version
#
#  subnet_ids                = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null),"private_subnet_ids", null), each.value.subnets_name,null), "subnet_ids", null)
#  vpc_id                    = lookup(lookup(module.network_vpc,each.value.vpc_name, null), "vpc_id", null)
#  allow_cidr                = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null),"private_subnets", null), "app",null), "cidr_block", null)
#
#}
#
#module "rabbitmq" {
#  source = "github.com/chandra5141/tf-module-rabbitmq.git"
#  env    = var.env
#  for_each = var.rabbitmq
#  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), "private_subnets_ids", null), each.value.subnets_name, null), "subnet_id", null )
#  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name,null),"private_subnets",null), "app",null), "cidr_block", null)
#  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null) // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
#  engine_version = each.value.engine_version
#  engine_type =  each.value.engine_type
#  host_instance_type =  each.value.host_instance_type
#  deployment_mode =  each.value.deployment_mode
#  bastion_cidr =var.bastion_cidr
#
#}
#module "alb" {
#  source = "github.com/chandra5141/tf-module-alb.git"
#  env    = var.env
#  for_each = var.alb
#  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), each.value.subnets_type, null), each.value.subnets_name, null), "subnet_id", null )
#  // the load balancer private should allow the web subnets where frontend is hosted apps also contacting the load balancer with in app subnets as well so for both web and app subnets should be allowd by load balanncer
#  allow_cidr   = each.value.internal ? concat(lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "web", null), "cidr_block", null), lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)) : ["0.0.0.0/0"]
#  //allow_cidr   = each.value.internal ? lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "web", null), "cidr_block", null) : [ "0.0.0.0/0" ]
#  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null)
#  // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
#  subnets_name = each.value.subnets_name
#  internal = each.value.internal
#  dns_domain = each.value.dns_domain
#}
#
#module "app" {
#  source = "github.com/pcs1999/tf-module-app.git"
#  depends_on = [module.docdb, module.rds, module.elasticache, module.rabbitmq]
#  env    = var.env
#  for_each = var.app
#  alb       = lookup(lookup(module.alb, each.value.alb,null ), "dns_name",null)
#  listener = lookup(lookup(module.alb, each.value.alb,null ), "listener",null)
#  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), each.value.subnets_type, null), each.value.subnets_name, null), "subnet_id", null )
#  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name,null),each.value.allow_cidr_subnet_types,null), each.value.allow_cidr_subnet_name,null), "cidr_block", null)
#  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null) // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
#  component = each.value.component
#  alb_arn = lookup(lookup(module.alb, each.value.alb,null ), "alb_arn",null)
#  app_port = each.value.app_port
#  max_size = each.value.max_size
#  min_size = each.value.min_size
#  desired_capacity = each.value.desired_capacity
#  instance_type = each.value.instance_type
#  bastion_cidr =var.bastion_cidr
#  monitor_cidr = var.monitor_cidr
#  listener_priority = each.value.listener_priority
#}
#
output "vpc" {
  value = module.network_vpc
}

