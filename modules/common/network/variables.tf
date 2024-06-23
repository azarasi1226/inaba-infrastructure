variable "resource_prefix" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "management_subnet" {
  type = object({
    cidr = string
    az   = string
  })
}

variable "ingress_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
}