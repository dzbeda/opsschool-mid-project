resource "aws_db_subnet_group" "rds" {
  name       = "rds"
  subnet_ids = var.private_subnet_id

  tags = {
    Name = "rds"
  }
}
resource "aws_db_instance" "kandula_postgres" {
  allocated_storage    = var.storage_size
  identifier           = var.rds_name
  engine               = "postgres"
  engine_version       = var.postgres_version
  instance_class       = var.posgres_rds_instance_type
  username             = var.username
  password             = var.password
  backup_retention_period = 0 #if replica is needed - more than 1
  vpc_security_group_ids = [aws_security_group.rds.id]
  name = "main"
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  skip_final_snapshot  = true
  publicly_accessible    = var.publicly_accessible
  tags = {
    Name = "rds-kandula-${var.project_name}"
    env = var.tag_enviroment
    role = "postgres-rds"
  }
}

resource "aws_security_group" "rds" {
  name ="rds-kandula-security-group"
  vpc_id = var.vpc_id
  ## Incoming roles
  ingress {
    from_port = 5432
    to_port =  5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow DB  access"
  }
  ingress {
    from_port = 22
    to_port =  22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow DB ssh access"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-rds-kandula-${var.project_name}"
    env = var.tag_enviroment

  }
}

