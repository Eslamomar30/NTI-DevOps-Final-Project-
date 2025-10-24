variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_allocated_storage" { type = number }
variable "subnet_ids" { type = list(string) }

resource "random_password" "db_password" {
  length           = 16
  override_characters = "!@#$%&*()-_=+"
}

resource "aws_db_subnet_group" "this" {
  name       = "nti-rds-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier = "nti-rds"
  allocated_storage = var.db_allocated_storage
  engine = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"
  name = var.db_name
  username = var.db_username
  password = random_password.db_password.result
  db_subnet_group_name = aws_db_subnet_group.this.name
  skip_final_snapshot = true
  publicly_accessible = false
}

resource "aws_secretsmanager_secret" "rds_secret" {
  name = "nti/rds/credentials"
}

resource "aws_secretsmanager_secret_version" "rds_secret_ver" {
  secret_id = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    engine   = "postgres"
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
  })
}
