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
        Name = "${var.resource_prefix}-vpc"
    }
}

# AZのリスト
data "aws_availability_zones" "availability_zone" {
  state = "available"
}

# 管理用パブリックサブネット(192.168.0.0)
resource "aws_subnet" "management_subnet" {
    vpc_id            = aws_vpc.this.id
    cidr_block        = "192.168.0.0/24"
    availability_zone = data.aws_availability_zones.availability_zone.names[0]

    map_public_ip_on_launch = true

    tags = {
        Name = "${var.resource_prefix}-management-public-subnet"
    }
}

# ingress用パブリックサブネット(192.168.1.0 ~ 192.168.3.0)
resource "aws_subnet" "ingress_subnets" {
    count = local.az_count

    vpc_id            = aws_vpc.this.id
    cidr_block        = "192.168.${1 + count.index}.0/24"
    availability_zone = data.aws_availability_zones.availability_zone.names[count.index]

    map_public_ip_on_launch = true
    
    tags = {
        Name = "${var.resource_prefix}-ingress-public-subnet-${count.index}"
    }
}

# コンテナ用プライベートサブネット(192.168.100.0 ~ 192.168.102.0)
resource "aws_subnet" "container_subnets" {
    count = local.az_count

    vpc_id            = aws_vpc.this.id
    cidr_block        = "192.168.${100 + count.index}.0/24"
    availability_zone = data.aws_availability_zones.availability_zone.names[count.index]

    tags = {
        Name = "${var.resource_prefix}-container-private-subnet-${count.index}"
    }
}

# egress用プライベートサブネット(192.168.103.0 ~ 192.168.105.0)
resource "aws_subnet" "egress_subnets" {
    count = local.az_count

    vpc_id            = aws_vpc.this.id
    cidr_block        = "192.168.${103 + count.index}.0/24"
    availability_zone = data.aws_availability_zones.availability_zone.names[count.index]

    tags = {
        Name = "${var.resource_prefix}-egress-private-subnet-${count.index}"
    }
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "${var.resource_prefix}-internet-gateway"
    }
}

# パブリックサブネット用ルートテーブル
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.this.id
    
    tags = {
        Name = "${var.resource_prefix}-public-route-table"
    }
}

# パブリックサブネット用ルート
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.ig.id
  destination_cidr_block = "0.0.0.0/0"
}

# コンテナ用サブネットルートテーブル(今のところNATゲートウェイ使ってないからVPCエンドポイントにしか用途がない)
resource "aws_route_table" "container_private_route_table" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "${var.resource_prefix}-container-public-route-table"
    }
}

# ルートテーブルとサブネットの紐づけ
resource "aws_route_table_association" "management-subnet-associations" {
    subnet_id      = aws_subnet.management_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "ingress-subnet-associations" {
    count = local.az_count

    subnet_id      = aws_subnet.ingress_subnets[count.index].id
    route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "container-subnet-associations" {
    count = local.az_count
    
    subnet_id = aws_subnet.container_subnets[count.index].id
    route_table_id = aws_route_table.container_private_route_table.id
}

data "aws_region" "current" {}

# 実はエンドポイントにもセキュリティグループが必要なんだZE!俺はこれで４時間溶かしたZE!
# エンドポイントにも専用にNICが割り当てられてるらしく、インスタンス的な感じポイ？
# 忘れないようにコメント多めに書いておく。忘れないように。忘れないように
module "egress_sg" {
    source = "../../modules/security_group"

    resource_prefix = var.resource_prefix
    usage_name = "vpc-endpoint"
    vpc_id = aws_vpc.this.id
    port = 443
    cidr_blocks = [aws_vpc.this.cidr_block]
}

# ECR用VPCエンドポイント(awc ecr get-login-password等のコマンドで使用)
resource "aws_vpc_endpoint" "ecr" {
    vpc_id = aws_vpc.this.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
    vpc_endpoint_type = "Interface"
    subnet_ids = [
        aws_subnet.egress_subnets[0].id,
        aws_subnet.egress_subnets[1].id,
        aws_subnet.egress_subnets[2].id
    ]
    security_group_ids = [module.egress_sg.security_group_id]

    private_dns_enabled = true

    tags =  {
        Name = "${var.resource_prefix}-ecr-endpoint"
    }
}

# ECR用VPCエンドポイント(docker image push等のコマンドで使用)
resource "aws_vpc_endpoint" "dkr" {
    vpc_id = aws_vpc.this.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
    vpc_endpoint_type = "Interface"
    subnet_ids = [
        aws_subnet.egress_subnets[0].id,
        aws_subnet.egress_subnets[1].id,
        aws_subnet.egress_subnets[2].id
    ]
    security_group_ids = [module.egress_sg.security_group_id]

    private_dns_enabled = true

    tags =  {
        Name = "${var.resource_prefix}-dkr-endpoint"
    }
}

# ECR用VPCエンドポイント(実はECRのImageはS3に実態を格納してるんだZE!)
resource "aws_vpc_endpoint" "s3" {
    vpc_id = aws_vpc.this.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
    route_table_ids = [
        aws_route_table.public_route_table.id,
        aws_route_table.container_private_route_table.id
    ]

    tags = {
        Name = "${var.resource_prefix}-s3-endpoint"
    }
}

# CloudWatch Logs用VPCエンドポイント
resource "aws_vpc_endpoint" "logs" {
    vpc_id = aws_vpc.this.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.logs"
    vpc_endpoint_type = "Interface"
    subnet_ids = [
        aws_subnet.egress_subnets[0].id,
        aws_subnet.egress_subnets[1].id,
        aws_subnet.egress_subnets[2].id
    ]
    security_group_ids = [module.egress_sg.security_group_id]

    private_dns_enabled = true

    tags =  {
        Name = "${var.resource_prefix}-logs-endpoint"
    }
}