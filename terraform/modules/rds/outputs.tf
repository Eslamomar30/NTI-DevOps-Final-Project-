output "db_endpoint" { value = aws_db_instance.this.endpoint }
output "secret_arn" { value = aws_secretsmanager_secret.rds_secret.arn }
