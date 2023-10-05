env = "dev"
default_vpc_id = "	vpc-0fa17b77fda91fbdc"
bastion_cidr = ["172.31.31.240/32"] // from workstation to connect to by ssh app servers
monitor_cidr = ["172.31.25.165/32"] // prometheus server to get metrics


vpc = {
  main = {
    cidr_block        = "10.0.0.0/16"
    availability_zone = ["us-east-1a", "us-east-1b"]

    public_subnets = {
      public = {
        name        = "public"
        cidr_block  = ["10.0.0.0/24", "10.0.1.0/24"]
        internet_gw = true
      }
    }
    private_subnets = {
      web = {
        name       = "web"
        cidr_block = ["10.0.2.0/24", "10.0.3.0/24"]
        nat_gw     = true
      }
      app = {
        name       = "app"
        cidr_block = ["10.0.4.0/24", "10.0.5.0/24"]
        nat_gw     = true
      }
      db = {
        name       = "db"
        cidr_block = ["10.0.6.0/24", "10.0.7.0/24"]
        nat_gw     = true
      }
    }

  }
}

docdb = {
  main = {
    vpc_name             = "main"
    subnets_name         = "db"
    engine_version       = "4.0.0"
    no_of_instance_docdb = 1
    instance_class       = "db.t3.medium"
  }
}

rds = {
  main = {
    vpc_name             = "main"
    subnets_name         = "db"
    engine_version       = "5.7.mysql_aurora.2.11.1"
    engine               = "aurora-mysql"
    no_of_instance_rds   = 1
    instance_class       = "db.t3.small"
  }
}

elasticache = {
  main = {
    vpc_name                = "main"
    subnets_name            = "db"
    num_cache_nodes         = 1
    node_type               = "cache.t3.micro"
    engine_version          = "6.x"
  }
}


rabbitmq = {
  main = {
    vpc_name = "main"
    engine_version = "3.10.10"
    engine_type    = "RabbitMQ"
    subnets_name = "db"
    host_instance_type= "mq.t3.micro"
    deployment_mode = "SINGLE_INSTANCE"

  }
}

alb = {
  public = {
    vpc_name = "main"
    subnets_type = "public_subnet_ids"
    subnets_name = "public"
    internal = false
    dns_domain = "www"

  }

  private = {
    vpc_name = "main"
    subnets_type = "private_subnet_ids"
    subnets_name = "app"
    internal = true
    dns_domain = ""
  }

  }


app = {
  frontend = {
    component = "frontend"
    vpc_name = "main"
    subnets_type = "private_subnet_ids"
    subnets_name = "web"
    app_port = 80
    allow_cidr_subnet_types = "public_subnets"
    allow_cidr_subnet_name = "public"
    max_size                  = 2
    min_size                  = 1
    desired_capacity          = 1
    alb                       = "public"
    instance_type = "t3.micro"
    listener_priority = 0
  }

  catalogue = {
    component = "catalogue"
    vpc_name = "main"
    subnets_type = "private_subnet_ids"
    subnets_name = "app"
    app_port = 8080
    allow_cidr_subnet_types = "private_subnets"
    allow_cidr_subnet_name = "app"
    max_size                  = 2
    min_size                  = 1
    desired_capacity          = 1
    alb                       = "private"
    listener_priority = 100
    instance_type = "t3.micro"

  }
  user = {
    component = "user"
    vpc_name = "main"
    subnets_type = "private_subnet_ids"
    subnets_name = "app"
    app_port = 8080
    allow_cidr_subnet_types = "private_subnets"
    allow_cidr_subnet_name = "app"
    max_size                  = 2
    min_size                  = 1
    desired_capacity          = 1
    alb                       = "private"
    listener_priority = 101

    instance_type = "t3.micro"

  }
  cart = {
    component                = "cart"
    vpc_name                 = "main"
    subnets_type             = "private_subnet_ids"
    subnets_name             = "app"
    app_port                 = 8080
    allow_cidr_subnet_types  = "private_subnets"
    allow_cidr_subnet_name   = "app"
    max_size                 = 2
    min_size                 = 1
    desired_capacity         = 1
    instance_type            = "t3.micro"
    alb                      = "private"
    listener_priority        = 102


  }
  shipping = {
    component = "shipping"
    vpc_name = "main"
    subnets_type = "private_subnet_ids"
    subnets_name = "app"
    app_port = 8080
    allow_cidr_subnet_types = "private_subnets"
    allow_cidr_subnet_name = "app"
    max_size                  = 2
    min_size                  = 1
    desired_capacity          = 1
    alb                       = "private"
    listener_priority = 103

    instance_type = "t3.large"

  }

  payment = {
    component = "payment"
    vpc_name = "main"
    subnets_type = "private_subnet_ids"
    subnets_name = "app"
    app_port = 8080
    allow_cidr_subnet_types = "private_subnets"
    allow_cidr_subnet_name = "app"
    max_size                  = 2
    min_size                  = 1
    desired_capacity          = 1
    alb                       = "private"
    listener_priority = 104

    instance_type = "t3.micro"

  }
}
