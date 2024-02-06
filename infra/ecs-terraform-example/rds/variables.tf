variable "project" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "node_type" {
  type    = string
  default = ""
}

variable "user_name" {
  type    = string
  default = ""
}

variable "database_name" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type    = list(any)
  default = []
}
