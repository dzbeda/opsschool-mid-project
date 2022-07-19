resource "aws_instance" "elastic_server" {
  count = var.create_elastic_server
  ami           = var.elastic_server_ami_id
  instance_type = var.elastic-server-instance-type
  subnet_id =  element(var.private_subnet_id, count.index)
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.elastic.id]
  user_data   = templatefile("./modules/elastic/elastic-userdata.tpl", { 
                server_id = "elastic-server-1"}
  )
  tags = {
    Name = "elatic-server-${count.index + 1}-${var.project_name}"
    tag_enviroment= var.tag_enviroment
    project_name = var.project_name
    role = "elastic-server"
    consul_server = var.is_consul_server
  }
}

## elastic security group
resource "aws_security_group" "elastic" {
  name ="elastic-security-group"
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
    from_port = 5601
    to_port =  5601
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.alb1_security_group_id]
    description = "Kibana UI"
  }
  ingress {
    from_port = 9300
    to_port =  9300
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Elastic internal"
  }
  ingress {
    from_port = 9200
    to_port =  9200
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Elastic external"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "elastic-sg-${var.project_name}"
    env = var.tag_enviroment
 }
}

## elastic server target group for supporting ALB

resource "aws_alb_target_group" "elastic-server" {
  name     = "elastic-server-target-group"
  port     = 5601
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    port = 5601
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

resource "aws_alb_target_group_attachment" "elastic-server" {
  count = var.create_elastic_server
  target_group_arn = aws_alb_target_group.elastic-server.arn
  target_id        = aws_instance.elastic_server.*.id[count.index]
  port             = 5601
}
resource "time_sleep" "wait_for_elastic_server_run_status" {
  depends_on = [aws_instance.elastic_server]
  create_duration = "60s"
}

resource "null_resource" "ansible_elastic_server" {
  depends_on = [time_sleep.wait_for_elastic_server_run_status]
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/aws_ec2.yml ../ansible/install-elastic-server.yml"
    environment = {
      ANSIBLE_CONFIG = "../ansible/ansible.cfg"
    }
  }
}