locals {
    //AZは各リージョンに最低３つ保証されており、システム的にも３つ合わせた構成が推奨されているので決め打ち
    //またロードバランサーは最低でも２つのAZを保持していないと500エラーを返すので、2AZ構成でシステムを組むと結局詰む
    az_count = 3
}

# VPC
resource "aws_vpc" "this" {
    cidr_block = "192.168.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.resrouce_prefix}-vpc"
    }
}

# AZのリスト
data "aws_availability_zones" "availability_zone" {
  state = "available"
}

# 管理用パブリックサブネット(192.168.0.0 ~ 192.168.2.0)
resource "aws_subnet" "management_subnets" {
    count = local.az_count

    vpc_id            = aws_vpc.this.id
    cidr_block        = "192.168.${count.index}.0/24"
    availability_zone = data.aws_availability_zones.availability_zone.names[count.index]

    map_public_ip_on_launch = true

    tags = {
        Name = "${var.resrouce_prefix}_management_public_subnet_${count.index}"
    }
}

# ingress用パブリックサブネット(192.168.3.0 ~ 192.168.5.0)
resource "aws_subnet" "ingress_subnets" {
    count = local.az_count

    vpc_id            = aws_vpc.this.id
    cidr_block        = "192.168.${3 + count.index}.0/24"
    availability_zone = data.aws_availability_zones.availability_zone.names[count.index]

    map_public_ip_on_launch = true
    
    tags = {
        Name = "${var.resrouce_prefix}_ingress_public_subnet_${count.index}"
    }
}

# コンテナ用プライベートサブネット(192.168.100.0 ~ 192.168.102.0)
resource "aws_subnet" "container_subnets" {
    count = local.az_count

    vpc_id            = aws_vpc.this.id
    cidr_block        = "192.168.${100 + count.index}.0/24"
    availability_zone = data.aws_availability_zones.availability_zone.names[count.index]

    tags = {
        Name = "${var.resrouce_prefix}_container_private_subnet_${count.index}"
    }
}

# egress用プライベートサブネット(192.168.103.0 ~ 192.168.105.0)
resource "aws_subnet" "egress_subnets" {
    count = local.az_count

    vpc_id            = aws_vpc.this.id
    cidr_block        = "192.168.${103 + count.index}.0/24"
    availability_zone = data.aws_availability_zones.availability_zone.names[count.index]

    tags = {
        Name = "${var.resrouce_prefix}_egress_private_subnet_${count.index}"
    }
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "${var.resrouce_prefix}_internet-gateway"
    }
}

# パブリック用ルートテーブル
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.this.id
    
    tags = {
        Name = "${var.resrouce_prefix}_public_route-table"
    }
}

# パブリックegress用ルート
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.ig.id
  destination_cidr_block = "0.0.0.0/0"
}

# パブリックなサブネットに↑で作ったルートテーブルを紐づける
resource "aws_route_table_association" "management-subnet-associations" {
    count = local.az_count

    subnet_id      = aws_subnet.management_subnets[count.index].id
    route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "ingress-subnet-associations" {
    count = local.az_count

    subnet_id      = aws_subnet.ingress_subnets[count.index].id
    route_table_id = aws_route_table.public_route_table.id
}

# ECR用VPCエンドポイント(awc ecr get-login-password等のコマンドで使用)
resource "aws_vpc_endpoint" "ecr" {
    vpc_id = aws_vpc.this.id
    service_name = "com.amazonaws.ap-northeast-1.ecr.api"
    vpc_endpoint_type = "Interface"
    subnet_ids = [
        aws_subnet.egress_subnets[0].id,
        aws_subnet.egress_subnets[1].id,
        aws_subnet.egress_subnets[2].id
    ]

    private_dns_enabled = true

    tags =  {
        Name = "${var.resrouce_prefix}_ecr_endpoint"
    }
}

# ECR用VPCエンドポイント(docker image push等のコマンドで使用)
resource "aws_vpc_endpoint" "dkr" {
    vpc_id = aws_vpc.this.id
    service_name = "com.amazonaws.ap-northeast-1.ecr.dkr"
    vpc_endpoint_type = "Interface"
    subnet_ids = [
        aws_subnet.egress_subnets[0].id,
        aws_subnet.egress_subnets[1].id,
        aws_subnet.egress_subnets[2].id
    ]

    private_dns_enabled = true

    tags =  {
        Name = "${var.resrouce_prefix}_dkr_endpoint"
    }
}

# CloudWatch Logs用VPCエンドポイント
resource "aws_vpc_endpoint" "logs" {
    vpc_id = aws_vpc.this.id
    service_name = "com.amazonaws.ap-northeast-1.logs"
    vpc_endpoint_type = "Interface"
    subnet_ids = [
        aws_subnet.egress_subnets[0].id,
        aws_subnet.egress_subnets[1].id,
        aws_subnet.egress_subnets[2].id
    ]

    private_dns_enabled = true

    tags =  {
        Name = "${var.resrouce_prefix}_logs_endpoint"
    }
}