variable "project" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "web_image_repository_name" {
  type    = string
  default = ""
}

variable "app_image_repository_name" {
  type    = string
  default = ""
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "cpu" {
  type    = string
  default = "512"
}

variable "capacity_provider_strategy" {
  type = map(object({
    base   = number
    weight = number
  }))
  default = {
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

variable "lb_target_group_arn_http" {
  type    = string
  default = ""
}

variable "db_instance_address" {
  type    = string
  default = ""
}

variable "db_security_group_id" {
  type    = string
  default = ""
}

variable "redis_security_group_id" {
  type    = string
  default = ""
}

variable "redis_host" {
  type    = string
  default = ""
}

variable "s3_bucket_name" {
  type    = string
  default = ""
}

variable "kms_decryption_key_id" {
  type    = string
  default = ""
}

variable "user_name" {
  type    = string
  default = ""
}

variable "app_url" {
  type    = string
  default = ""
}

variable "container_environments" {
  type    = map(any)
  default = {}
}

variable "container_sectrets" {
  type    = map(any)
  default = {}
}

variable "aws_rds_db_password_arn" {
  type    = string
  default = ""
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "enable_ecs_exec" {
  type    = bool
  default = false
}

variable "aws_cloudwatch_log_group_nginx" {
  type    = string
  default = ""
}

variable "aws_cloudwatch_log_group_php" {
  type    = string
  default = ""
}

variable "aws_cloudwatch_log_group_migration" {
  type    = string
  default = ""
}
