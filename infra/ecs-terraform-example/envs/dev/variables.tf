variable "environments" {
  description = "Map of environments and secrets"
  type = map(object({
    env_variable = string
    secret_value = string
  }))
  default = {
    production = {
      env_variable = "prod_env"
      secret_value = "prod_secret"
    },
  }
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "enable_ecs_exec" {
  description = "Enable or disable SSM integration"
  type        = bool
  default     = false
}
