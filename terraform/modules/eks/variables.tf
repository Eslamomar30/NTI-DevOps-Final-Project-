variable "cluster_name" { type = string }
variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }
variable "node_instance_type" { type = string }
variable "desired_capacity" { type = number }
variable "min_capacity" { type = number }
variable "max_capacity" { type = number }
