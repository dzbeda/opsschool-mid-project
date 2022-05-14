resource "aws_instance" "bastion_server" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids  = [aws_security_group.bastion_server.id]
  key_name = var.key_name
  user_data = file("modules/bastion-server/bastion-userdata.tpl")
  tags = {
    Name = "bastion-server-${var.project_name}"
    env = var.tag_enviroment
    role = "bastion-server"
  }
}

resource "aws_security_group" "bastion_server" {
  name ="bastion-server-public-security-group"
  vpc_id = var.vpc_id
  ## Incoming roles
  ingress {
    from_port = 22
    to_port =  22
    protocol = "tcp"
    cidr_blocks = [var.ssh_enable_ip]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-bastion-server-sg"
    env = var.tag_enviroment
  }
}