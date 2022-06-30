#terraform configuration for creation of encrypted EBS attached to EC2
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = "us-west-2"
  profile = "default"
}
locals {
  availability_zone = "${local.region}a"
  name              = "example-ec2-volume-attachment"
  region            = "us-west-2"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "my-ec2-cluster"
  instance_count = 2

  ami                    = "ami-0c5204531f799e0c6"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = flatten(module.ec2.id)[0] 

}
resource "aws_ebs_volume" "this" {
  availability_zone = local.availability_zone
  size              = 1

  tags = local.tags
}
resource "aws_ebs_encryption_by_default" "enabled" {
     enabled = true
}
