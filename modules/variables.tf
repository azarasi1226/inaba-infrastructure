variable "resource_prefix" {
    type = string
}

variable "network" {
    type = object({
      vpc_cidr = string
      management_subnet_cidr = string
      ingress_subnet_cidrs = list(string)
      private_subnet_cidrs = list(string)
    })
}