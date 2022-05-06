resource "aws_instance" "ansible_server" {
  count = var.ansible_number_of_servers
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id = var.private_subnet_id[count.index]
  vpc_security_group_ids  = [aws_security_group.ansible_server.id]
  iam_instance_profile = var.iam_instance_profile
  key_name = var.key_name
  user_data = file("modules/ansible-server/ansible-userdata.tpl")
  tags = {
    Name = "ansible-server-${var.project_name}"
    env = var.tag_enviroment
    role = "ansible-server"
  }
}

resource "aws_security_group" "ansible_server" {
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
  }
}