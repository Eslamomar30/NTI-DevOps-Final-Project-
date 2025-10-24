variable "repo_name" { type = string }
variable "scan_on_push" { type = bool, default = true }

resource "aws_ecr_repository" "this" {
  name = var.repo_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = var.scan_on_push }
}

output "repository_url" { value = aws_ecr_repository.this.repository_url }
