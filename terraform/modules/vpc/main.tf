variable "name" {}
variable "cidr" {}
variable "public_cidrs" { type = list(string) }
variable "private_cidrs" { type = list(string) }
variable "azs" { type = list(string) }

resource "aws_vpc" "this" {
  cidr_block = var.cidr
  tags = { Name = var.name }
}

resource "aws_subnet" "public" {
  for_each = toset(var.public_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = each.key
  availability_zone = var.azs[0]
  map_public_ip_on_launch = true
  tags = { Name = "${var.name}-public-${each.key}" }
}

resource "aws_subnet" "private" {
  for_each = toset(var.private_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = each.key
  availability_zone = var.azs[0]
  map_public_ip_on_launch = false
  tags = { Name = "${var.name}-private-${each.key}" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.name}-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.name}-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public
  subnet_id = each.value.id
  route_table_id = aws_route_table.public.id
}
