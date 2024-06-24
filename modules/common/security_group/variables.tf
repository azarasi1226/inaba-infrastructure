variable "resource_prefix" {
  type = string
}

variable "usage_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  type = list(object({
    allow_port  = number
    allow_cidrs = list(string)
  }))
}