variable "name" { type = string }
variable "resource_arns" { type = list(string) }
variable "vault_name" { type = string }

resource "aws_backup_vault" "vault" {
  name = var.vault_name
}

resource "aws_backup_plan" "daily" {
  name = "${var.name}-daily"
  rule {
    rule_name         = "daily-snap"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "cron(0 3 * * ? *)"
    lifecycle {
      delete_after = 30
    }
  }
}

resource "aws_backup_selection" "selection" {
  name    = "${var.name}-selection"
  plan_id = aws_backup_plan.daily.id
  iam_role_arn = aws_iam_role.backup_role.arn
  resources = var.resource_arns
}

resource "aws_iam_role" "backup_role" {
  name = "${var.name}-backup-role"
  assume_role_policy = data.aws_iam_policy_document.backup_assume.json
}

data "aws_iam_policy_document" "backup_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service" ; identifiers = ["backup.amazonaws.com"] }
  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  role = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}
