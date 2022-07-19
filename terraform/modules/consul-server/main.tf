resource "aws_instance" "consul_server" {
  count = var.consul_number_of_server
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id =  element(var.private_subnet_id, count.index)
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
    role = "consul-server"
    consul_server = var.is_consul_server
  }
}

## Consul security group
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
    #security_groups = [var.alb1_security_group_id]
    description = "Allow consul UI access from alb securitygroup"
  }
  ingress {
    from_port = 8600
    to_port =  8600
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from alb securitygroup"
  }
  ingress {
    from_port = 8300
    to_port =  8303
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from alb securitygroup"
  }
  ingress {
    from_port = 53
    to_port =  53
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from alb securitygroup"
  }
  ingress {
    from_port = 9100
    to_port =  9100
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from alb securitygroup"
  }
  ingress {
    from_port = 0
    to_port =  0
    protocol = "-1"
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.jenkins_security_group_id]
    description = "Connection from jenkins security group"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "consul-server-sg-${var.project_name}"
    env = var.tag_enviroment
  }
}

## Cluster server target group for supporting ALB

resource "aws_alb_target_group" "consul-server" {
  name     = "consul-server-target-group"
  port     = 8500
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/ui/mid-project/services"
    port = 8500
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

resource "aws_alb_target_group_attachment" "consul-server" {
  count = var.consul_number_of_server
  target_group_arn = aws_alb_target_group.consul-server.arn
  target_id        = aws_instance.consul_server.*.id[count.index]
  port             = 8500
}
resource "time_sleep" "wait_for_consul_run_status" {
  depends_on = [aws_instance.consul_server]
  create_duration = "45s"
}
resource "null_resource" "ansible_consul" {
  depends_on = [time_sleep.wait_for_consul_run_status]
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/aws_ec2.yml ../ansible/install-consul-server.yml"
    environment = {
      ANSIBLE_CONFIG = "../ansible/ansible.cfg"
    }
  }
}