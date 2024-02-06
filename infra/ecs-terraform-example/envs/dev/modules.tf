module "vpc" {
  source             = "../../vpc"
  project            = local.project
  vpc_cidr           = local.vpc.vpc_cidr
  azs                = local.vpc.azs
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.enable_nat_gateway
  tags               = merge(local.basicTags, local.componentType.networking)
}

module "alb" {
  source          = "../../alb"
  certificate_arn = local.alb.certificate_arn
  project         = local.project
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = [module.vpc.subnet_public_a_id, module.vpc.subnet_public_c_id]
  tags            = merge(local.basicTags, local.componentType.computing)
  depends_on      = [module.vpc]
}

module "redis" {
  source     = "../../redis"
  project    = local.project
  node_type  = local.redis.node_type
  vpc_id     = module.vpc.vpc_id
  tags       = merge(local.basicTags, local.componentType.database)
  depends_on = [module.vpc]
  subnet_ids = [module.vpc.subnet_private_a_id, module.vpc.subnet_private_c_id, module.vpc.subnet_private_d_id]
}

#module "rds" {
#  source        = "../../rds"
#  project       = local.project
#  node_type     = local.rds.node_type
#  vpc_id        = module.vpc.vpc_id
#  user_name     = local.rds.user_name
#  database_name = local.rds.database_name
#  tags          = merge(local.basicTags, local.componentType.database)
#  subnet_ids    = [module.vpc.subnet_public_a_id, module.vpc.subnet_public_c_id, module.vpc.subnet_public_d_id]
#  depends_on    = [module.vpc]
#}

module "rds" {
  source        = "../../aurora"
  project       = local.project
  node_type     = local.rds.node_type
  vpc_id        = module.vpc.vpc_id
  user_name     = local.rds.user_name
  database_name = local.rds.database_name
  tags          = merge(local.basicTags, local.componentType.database)
  subnet_ids    = [module.vpc.subnet_public_a_id, module.vpc.subnet_public_c_id, module.vpc.subnet_public_d_id]
  depends_on    = [module.vpc]
}

module "log" {
  source  = "../../log"
  project = local.project
}

module "ecs" {
  source                             = "../../ecs"
  project                            = local.project
  tags                               = merge(local.basicTags, local.componentType.computing)
  vpc_id                             = module.vpc.vpc_id
  web_image_repository_name          = local.ecr.web_image_repository_name
  app_image_repository_name          = local.ecr.app_image_repository_name
  memory                             = local.ecs.memory
  cpu                                = local.ecs.cpu
  capacity_provider_strategy         = local.ecs.capacity_provider_strategy
  subnet_ids                         = [module.vpc.subnet_public_a_id, module.vpc.subnet_public_c_id, module.vpc.subnet_public_d_id]
  lb_target_group_arn_http           = module.alb.lb_target_groups_http.arn
  db_instance_address                = module.rds.db_instance_address
  redis_host                         = module.redis.redis_host
  db_security_group_id               = module.rds.aws_security_group_id
  redis_security_group_id            = module.redis.aws_security_group_id
  s3_bucket_name                     = local.s3.bucket_name
  kms_decryption_key_id              = local.kms.kms_decryption_key_id
  aws_cloudwatch_log_group_nginx     = module.log.aws_cloudwatch_log_group_nginx
  aws_cloudwatch_log_group_php       = module.log.aws_cloudwatch_log_group_php
  aws_cloudwatch_log_group_migration = module.log.aws_cloudwatch_log_group_migration
  enable_ecs_exec                    = true
  desired_count                      = 2
  container_environments             = local.ecs.container_environments
  container_sectrets                 = local.ecs.container_sectrets
  aws_rds_db_password_arn            = module.rds.aws_rds_db_password.secret_arn
  enable_nat_gateway                 = var.enable_nat_gateway
  depends_on                         = [module.alb, module.rds, module.redis]
}

module "cicd" {
  source                             = "../../cicd"
  project                          = local.project
  web_image_repository_name        = local.ecr.web_image_repository_name
  app_image_repository_name        = local.ecr.app_image_repository_name
  circleci_deploy_ecs_cluster_arn = module.ecs.ecs_cluster_arn
  circleci_deploy_ecs_service_arn  = module.ecs.ecs_service_arn
}
