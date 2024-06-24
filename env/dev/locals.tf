locals {
  aws_region = "ap-northeast-1"

  network = {
    resource_prefix   = var.resource_prefix,
    vpc_cidr          = "192.168.0.0/16",
    management_subnet = { cidr = "192.168.0.0/24", az = "ap-northeast-1a" },
    ingress_subnets = [
      { cidr = "192.168.1.0/24", az = "ap-northeast-1a" },
      { cidr = "192.168.2.0/24", az = "ap-northeast-1c" },
      { cidr = "192.168.3.0/24", az = "ap-northeast-1d" }
    ],
    private_subnets = [
      { cidr = "192.168.4.0/24", az = "ap-northeast-1a" },
      { cidr = "192.168.5.0/24", az = "ap-northeast-1c" },
      { cidr = "192.168.6.0/24", az = "ap-northeast-1d" }
    ]
  }

  jump_server = {
    enabled = true
  }
}
