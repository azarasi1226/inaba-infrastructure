module "jump_server" {
  source = "../security_group"

  resource_prefix = var.resource_prefix
  usage_name      = "jump_server"
  vpc_id          = var.vpc_id
  ingress_rules   = [
    {
      allow_port = 22
      allow_cidrs = ["0.0.0.0/0"]
    }
  ] 
}

# TODO: ここをlatestにすると、Linuxのバージョンアップのせいでuser-dataが使えなくなる可能性があるのでバージョンは固定したほうがよさそう
# 最新のバージョンに固定して、userdataを更新しよう
data "aws_ssm_parameter" "this" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "this" {
  ami                    = data.aws_ssm_parameter.this.value
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  user_data              = file("${path.module}/user-data.sh")
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [module.jump_server.security_group_id]

  tags = {
    "Name" = "${var.resource_prefix}-jump-server"
  }
}