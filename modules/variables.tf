variable "resource_prefix" {
  type = string
}

variable "network" {
  type = object({
    vpc_cidr = string
    management_subnet = object({
      cidr = string
      az   = string
    })
    ingress_subnets = list(object({
      cidr = string
      az   = string
    }))
    private_subnets = list(object({
      cidr = string
      az   = string
    }))
  })
}