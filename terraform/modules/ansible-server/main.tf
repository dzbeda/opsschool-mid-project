resource "aws_instance" "ansible_server" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  #availability_zone = var.availability_zone
  subnet_id = var.private_subnet_id
  vpc_security_group_ids  = [aws_security_group.ansible_server.id]
  iam_instance_profile = var.iam_instance_profile
  key_name = var.key_name
  # provisioner "file" {
  #   source     = var.private_key_file_name
  #   destination = "/home/ubuntu/.ssh/id_rsa"
  #   connection {   
  #     host        = self.public_ip
  #     user        = "ubuntu"
  #     private_key = file(var.private_key_file_name)      
  #   }   
  # }
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