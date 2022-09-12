# SSH Keyの保存先
locals {
    private_key_export_path = "../../export/bastion-key.pem"
}

# SSH接続用セキュリティグループ
module "ssh_sg" {
    source = "../../modules/security_group"

    resource_prefix = var.resource_prefix
    usage_name = "bastion"
    vpc_id = var.vpc_id
    port = "22"
    cidr_blocks = ["0.0.0.0/0"]
}

# amazonlinux2の最新amiを取得
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# SSH Key
resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Key Pair
resource "aws_key_pair" "key_pair" {
  key_name = "bastion-key"
  public_key = tls_private_key.keygen.public_key_openssh
}

# ローカルにprivate Key出力
resource "local_file" "private_key_pem" {
  filename = local.private_key_export_path
  content = tls_private_key.keygen.private_key_pem
}

# 踏み台サーバー
resource "aws_instance" "this" {
    ami = data.aws_ssm_parameter.amzn2_ami.value
    instance_type = "t2.micro"
    subnet_id = var.subnet_id
    user_data = file("${path.module}/user-data.sh")
    key_name = aws_key_pair.key_pair.key_name
    security_groups = [module.ssh_sg.security_group_id]

    tags = {
        "Name" = "${var.resource_prefix}_bastion_ec2"
    }
}