variable "network" {
    type = object({
      resource_prefix = string
      vpc_cidr = string
      management_subnet_cidr = string
      ingress_subnet_cidrs = list(string)
      private_subnet_cidrs = list(string)
    })
}