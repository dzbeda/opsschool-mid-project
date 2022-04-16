resource "aws_instance" "consul_server" {
  count = var.consul_number_of_server
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.private_subnet_id[count.index]
  key_name      = var.key_name
  iam_instance_profile = var.iam_instance_profile
  vpc_security_group_ids = [aws_security_group.consul_server.id]
  user_data   = templatefile("./modules/consul-server/consul-server-userdata.tpl", { 
                server_id = "consul-server-${count.index + 1}"}
  )
  tags = {
    Name = "consul-server-${count.index + 1}-${var.project_name}"
    tag_enviroment= var.tag_enviroment
    project_name = var.project_name
    consul_server = "true"
    role = "consul-server"
  }
}
resource "aws_security_group" "consul_server" {
  name ="consul-server-private-security-group"
  vpc_id = var.vpc_id
  ## Incoming roles
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }
  ingress {
    from_port = 22
    to_port =  22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Connection"
  }
  ingress {
    from_port = 8500
    to_port =  8500
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-consul-server-sg"
    env = var.tag_enviroment
  }
}