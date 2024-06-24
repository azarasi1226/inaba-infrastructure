resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${var.resource_prefix}-jump-server-key"
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_secretsmanager_secret" "this" {
  name        = "${var.resource_prefix}-jump-server-ssh-key"
  description = "Private key for SSH access"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = tls_private_key.this.private_key_pem
}