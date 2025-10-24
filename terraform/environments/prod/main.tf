terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type    = string
  default = "us-east-1"
}

# VPC
module "vpc" {
  source        = "../../modules/vpc"
  name          = "nti-vpc"
  cidr          = "10.0.0.0/16"
  public_cidrs  = ["10.0.1.0/24"]
  private_cidrs = ["10.0.2.0/24"]
  azs           = ["us-east-1a"]
}

# S3 (for ELB logs, general artifacts)
module "s3" {
  source    = "../../modules/s3"
  bucket_id = "nti-devops-logs-${random_id.bucket_suffix.hex}"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# ECR
module "ecr" {
  source     = "../../modules/ecr"
  repo_name  = "nti-app"
  scan_on_push = true
}

# EC2 Jenkins
module "ec2_jenkins" {
  source       = "../../modules/ec2-jenkins"
  subnet_id    = module.vpc.public_subnets[0]
  key_name     = var.ssh_key_name
  instance_type = "t3.medium"
}

variable "ssh_key_name" {
  type = string
  default = ""
}

# RDS (credentials stored in Secrets Manager)
module "rds" {
  source            = "../../modules/rds"
  db_name           = "ntiappdb"
  db_username       = "ntiadmin"
  db_allocated_storage = 20
  subnet_ids        = module.vpc.private_subnets
}

# EKS
module "eks" {
  source           = "../../modules/eks"
  cluster_name     = "nti-eks"
  vpc_id           = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  public_subnet_ids  = module.vpc.public_subnets
  node_instance_type = "t3.medium"
  desired_capacity   = 2
  max_capacity       = 3
  min_capacity       = 1
}

# AWS Backup for Jenkins EC2
module "backup" {
  source = "../../modules/backup"
  name   = "nti-backup"
  resource_arns = [module.ec2_jenkins.instance_arn]
  vault_name = "nti-backup-vault"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "jenkins_ec2_public_ip" {
  value = module.ec2_jenkins.public_ip
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "ecr_repo_url" {
  value = module.ecr.repository_url
}
