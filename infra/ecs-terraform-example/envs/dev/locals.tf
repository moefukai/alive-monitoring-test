locals {
  project = "example"
  app_url = "template-test-withnat.stg.sdb.dev"

  vpc = {
    vpc_cidr = "10.0.0.0/16"
    azs = {
      a = {
        public_cidr  = "10.0.1.0/24"
        private_cidr = "10.0.4.0/24"
      },
      c = {
        public_cidr  = "10.0.2.0/24"
        private_cidr = "10.0.5.0/24"
      },
      d = {
        public_cidr  = "10.0.3.0/24"
        private_cidr = "10.0.6.0/24"
      }
    }
  }

  alb = {
    certificate_arn = "arn:aws:acm:ap-northeast-1:124415925411:certificate/3042f0fa-7bcd-49e9-8c14-dc1072f6b44a"
  }

  redis = {
    node_type = "cache.t2.micro"
  }

  rds = {
    node_type     = "db.t3.medium"
    database_name = "laravel"
    user_name     = "laravel"
  }

  s3 = { # These must be unique in the world.
    bucket_name = ""
  }

  ecs = {
    memory = "1024"
    cpu    = "512"
    container_environments = {
      "DB_USERNAME"    = local.rds.user_name
      "DB_DATABASE"    = local.rds.database_name
      "SESSION_DRIVER" = "redis"
    }
    # "ENVIROMENT_VALUE" = "secret-arn"
    container_sectrets = {
      "APP_KEY" = "arn:aws:secretsmanager:ap-northeast-1:124415925411:secret:template-test/staging/APP_KEY-mOW2Wg"
    }
    capacity_provider_strategy = {
      fargate = {
        base   = 1
        weight = 1
      }
      fargate_spot = {
        base   = 0
        weight = 1
      }
    }
  }

  kms = {
    kms_decryption_key_id = "aws/secretsmanager"
  }

  ecr = {
    web_image_repository_name = "alive-monitoring-web"
    app_image_repository_name = "alive-monitoring-php"
  }
}

locals {
  basicTags = {
    Product = "${local.project}"
  }
  componentType = {
    computing       = { "CostComponentType" = "Computing" }
    storage         = { "CostComponentType" = "Storage" }
    database        = { "CostComponentType" = "Database" }
    networking      = { "CostComponentType" = "Networking" }
    queue           = { "CostComponentType" = "Queue" }
    operation       = { "CostComponentType" = "Operation" }
    other           = { "CostComponentType" = "Other" }
    storageDatabase = { "CostComponentType" = "Storage_Database" }
  }
}

