resource "aws_instance" "consul_server" {
  count = var.consul_number_of_server
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name      = aws_key_pair.opsschool_consul_key.key_name
  subnet_id                   = aws_subnet.public.id
  iam_instance_profile   = aws_iam_instance_profile.consul-join.name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.opsschool_consul.id]
  #user_data_base64 = "ZWNobyAiWjI5dlpDQnRiM0p1YVc1bklITjBZWEp6YUdsdVpRbz0ifGJhc2U2NCAtRCAgPiAvaG9tZS91YnVudHUvZ29vZC50eHQK"
  user_data            = "./run_server.sh"

  provisioner "file" {
    source      = "scripts/consul-server.sh"
    destination = "/home/ubuntu/consul-server.sh"
    connection {   
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(var.pem_key_name)      
    }   
  }

  tags = {
    Name = "consul-server${count.index}"
    tag_enviroment= var.tag_enviroment
    project_name = var.project_name
    consul_server = "true"
  }

}

resource "aws_security_group" "consul_server" {
  name ="ansible-server-public-security-group"
  vpc_id = var.vpc_id
  ## Incoming roles
  ingress {
    from_port = 22
    to_port =  22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-ansible-server-sg"
    env = var.tag_enviroment
    role = "ansible-server"
  }
}