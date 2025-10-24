variable "name" { type = string }
variable "cidr" { type = string }
variable "public_cidrs" { type = list(string) }
variable "private_cidrs" { type = list(string) }
variable "azs" { type = list(string) }
