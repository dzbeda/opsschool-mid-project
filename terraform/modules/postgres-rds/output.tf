output "rds-endpoint"{
    value = aws_db_instance.kandula_postgres.address
}