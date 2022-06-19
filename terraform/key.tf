resource "tls_private_key" "project_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "project_key" {
  key_name   = "project_key"
  public_key = tls_private_key.project_key.public_key_openssh
}

resource "local_file" "project_key" {
  sensitive_content  = tls_private_key.project_key.private_key_pem
  filename           = var.private_key_file_name
  file_permission = "0400"
}