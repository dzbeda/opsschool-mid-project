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
  engine               = var.rds-engine
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
locals {
  depends_on = [aws_db_instance.kandula_postgres]
  rds-endpoint-address = aws_db_instance.kandula_postgres.address
}
resource "local_file" "create_pgpass_file" {
  filename        = "/home/ubuntu/.pgpass"
  file_permission = "0600"
  sensitive_content = templatefile("./modules/postgres-rds/pgpass.tftpl", {
    db_name           = var.rds-engine,
    db_admin_user     = var.username,
    db_admin_password = var.password
  })
}
# resource "null_resource" "open_ssh_tunnel" {
#   depends_on = [local_file.create_pgpass_file]
#   provisioner "local-exec" {
#     command = "timeout 300 ssh ${var.bastion-ip} -L 5432:${local.rds-endpoint-address}:5432 -T -N &"
#     on_failure = continue
#   }
# }
# resource "time_sleep" "wait_for_ssh_tunnel" {
#   depends_on = [local_file.create_pgpass_file]
#   create_duration = "30s"
# }
# resource "null_resource" "update_db" {
#   depends_on = [time_sleep.wait_for_ssh_tunnel]
#   provisioner "local-exec" {
#     command = "psql -h localhost -p 5432 -U ${var.username}  -d ${var.db_name} -a -f ./modules/postgres-rds/sql-scripts/create-schema.sql"
#     on_failure = continue
#   }
#   provisioner "local-exec" {
#     command = "psql -h localhost -p 5432 -U ${var.username}  -d ${var.db_name} -a -f ./modules/postgres-rds/sql-scripts/create-table.sql"
#     on_failure = continue
#   }
#   provisioner "local-exec" {
#     command = "psql -h localhost -p 5432 -U ${var.username}  -d ${var.db_name} -a -f ./modules/postgres-rds/sql-scripts/create-role.sql"
#   }
#   provisioner "local-exec" {
#     command = "psql -h localhost -p 5432 -U ${var.username}  -d ${var.db_name} -a -f ./modules/postgres-rds/sql-scripts/create-permission.sql"
#   }
# }