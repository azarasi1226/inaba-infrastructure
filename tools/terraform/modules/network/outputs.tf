output "vpc_id" {
    value = aws_vpc.this.id
}

output "vpc_arn" {
    value = aws_vpc.this.arn
}

output "vpc_cidr" {
    value = aws_vpc.this.cidr_block
}

output "management_subnets_id" {
    value = aws_subnet.management_subnet.id
}

output "container_private_subnet_ids" {
    value = [
        aws_subnet.container_subnets[0].id,
        aws_subnet.container_subnets[1].id,
        aws_subnet.container_subnets[2].id
    ]
}

output "ingress_public_subnet_ids" {
    value = [
        aws_subnet.ingress_subnets[0].id,
        aws_subnet.ingress_subnets[1].id,
        aws_subnet.ingress_subnets[2].id
    ]
}


