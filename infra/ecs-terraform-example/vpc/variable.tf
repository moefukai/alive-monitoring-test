variable "project" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type = map(object({
    public_cidr  = string
    private_cidr = string
  }))
  default = {
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

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}
