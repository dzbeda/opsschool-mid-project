resource "aws_instance" "jenkins_server" {
  count = var.jenkins_master_number_of_servers
  ami           = var.jenkins_server_ami_id
  instance_type = var.jenkins-server-instance-type
  subnet_id =  var.private_subnet_id[count.index]
  key_name      = var.key_name
  iam_instance_profile = var.iam_instance_profile
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  user_data   = templatefile("./modules/jenkins/jenkins-server-userdata.tpl", { 
                server_id = "jenkins-server-1"}
  )
  tags = {
    Name = "jenkins-server-${var.project_name}"
    enviroment= var.tag_enviroment
    project_name = var.project_name
    role = "jenkins-server"
  }
}

resource "aws_instance" "jenkins_node" {
  count = var.jenkins_nodes_number_of_server
  ami           = var.jenkins_client_ami_id
  instance_type = var.jenkins-node-instance-type
  subnet_id =  element(var.private_subnet_id, count.index)
  key_name      = var.key_name
  iam_instance_profile = var.iam_instance_profile
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  user_data   = templatefile("./modules/jenkins/jenkins-agent-userdata.tpl", { 
                server_id = "jenkins-node-${count.index + 1}"}
  )
  tags = {
    Name = "jenkins-node-${count.index + 1}-${var.project_name}"
    tag_enviroment= var.tag_enviroment
    project_name = var.project_name
    consul_server = "false"
    role = "jenkins-node"
  }
}

## Jenkins security group
resource "aws_security_group" "jenkins" {
  name ="jenkins-security-group"
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
    from_port = 9000
    to_port =  9000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.alb1_security_group_id]
    description = "UI"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "jenkins-sg-${var.project_name}"
    env = var.tag_enviroment
 }
}

## Jenkins server target group for supporting ALB

resource "aws_alb_target_group" "jenkins-server" {
  name     = "jenkins-server-target-group"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    port = 9000
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

resource "aws_alb_target_group_attachment" "jenkins-server" {
  count = var.jenkins_master_number_of_servers
  target_group_arn = aws_alb_target_group.jenkins-server.arn
  target_id        = aws_instance.jenkins_server.*.id[count.index]
  port             = 9000
}